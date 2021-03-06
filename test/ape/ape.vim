"ape.vim	:	vim script to implement annotated program execution

let g:top_win_height = 5
let g:mid_win_height = 25
let g:bot_win_height = 5
let g:nav_win_width = 20

let g:ape_dir = "test/ape"
let g:help_file = g:ape_dir . "/" . "ape-doc.txt"

"0-based index of current program step in 'ape_steps' array, indicated by '>' cursor in the nav window
let g:ape_steps = []

"0-based index of step in steps array that corresponds to current exe pos in gdb
let g:exe_pos = -1	

"0-based index of line position of the '>' cursor in the nav window, need this variable to track prev cursor pos in nav window for 'CursorMoved' event-handling
let g:nav_pos = -1	

let g:ape_steps_file = "ape_steps.vim"
let g:in_autonav = 0

let g:show_detail_win = 1

function! DbOut(s)
	if !g:show_detail_win 
		return
	endif
	"get cur win
	let cur_win = winnr()
	call GotoDetailWin()	
	call append('$', a:s)
	:w
	call GotoWin(cur_win)
endfunction

function! SetMappings()
	"debug mappings
	:map <f5> :call Init()
	:map <f6> :call CloseWindows()
	
	:map <f1> :call Help()
	:map <f8> :call Step('step')
	:map <f9> :call Step('next')
endfunction

function! Help()
	call CloseWindows()
	exe ":e " . g:help_file
endfunction

function! SetupWindows()
	"create narrative window at top
	:new
	call WinMoveUp()
	:clo
	:e narrative

	"create middle src window
	exe ":" g:mid_win_height "new"
	:e source

	"create nav window left of narrative window
	call WinMoveUp()
	exe "vert " g:nav_win_width "new"
	:e nav
	:set cursorline

	"create detail window below source window
	if g:show_detail_win 
		call WinMoveDown()
		exe g:bot_win_height "new"
		:e detail
	endif 

endfunction

function! CloseWindows()
	"goto final window
	let endnr = winnr("$")
	":echo "final window nr: " endnr
	while endnr > 1
		exe ":" endnr " wincmd w"
		:clo
		let endnr = winnr("$")
	endwhile
endfunction

function! WinMoveUp()
	sil exe "normal \<c-w>k"
	"can also do:  :wincmd k
endfunction

function! WinMoveDown()
	sil exe "normal \<c-w>j"
	"can also do:  :wincmd j
endfunction

function! GotoWin(nr)
	sil exe ":" a:nr "wincmd w"
endfunction

function! GotoNavWin()
	call GotoWin(1)
endfunction

function! GotoNarWin()
	call GotoWin(2)
endfunction

function! GotoSrcWin()
	call GotoWin(3)
endfunction

function! GotoDetailWin()
	call GotoWin(winnr("$"))
endfunction

"returns src file of vim cursor line in nav window
function! GetNavSourceFile()
"	call GotoNavWin()
"	let pos = line(".")
	let pos = GetNavPos()
	let step = g:ape_steps[pos]
	let src_file = step['src_file']
	return src_file
endfunction

"returns src line of vim cursor line in nav window
function! GetNavSourceLine()
"	call GotoNavWin()
"	let pos = line(".")
	let pos = GetNavPos()
	let step = g:ape_steps[pos]
	let step = g:ape_steps[pos]
	let src_line = step['src_line']
	return src_line
endfunction

"get-source-file.vim	:	parses output of gdb 'info source', returns fqp of source file
function! GetExeSourceFile()
	:sil new scratch
	:sil %!gclient gdb_cmd info source
	:sil exe ":1,$y s"
	let info_source = @s
	:sil clo!
	let lines = split(info_source, "\n")
	let ln = lines[2]
	let toks = split(ln)
	let fname = toks[2]
	return fname
endfunction

"get-current-line.vim	:	parses output of gdb 'bt' command to get the current line number of a running program
"bt output:
"#0  main (argc=1, argv=0xbffff444) at main.c:450
function! GetExeSourceLine()
	:sil new scratch
	:sil %!gclient gdb_cmd bt
	:sil 1,$y l
	:let g:ln = @l
	:let g:matches = matchlist(g:ln, ":\\(\\d\\+\\)")
	:sil clo!
	return g:matches[1]
endfunction

"starts gdb and debuggee program, sets exe index pos to 0
function! SetupGdb()
	:sil new scratch

	:sil exe "%!gclient start_gdb"
	:sil 1,$y r
	let result = @r

	"check gserver running
	if result == "connect() failed: Connection refused\n"
		:throw "can't connect to gserver"
	endif

	"check gdb running
	if result == "504 Gdb Not Running"
		:throw 'gdb not running'
	endif

	"check gdb failed to start
	if result == "503 Gdb Failed To Start"
		:throw 'gdb failed to start'
	endif

	"check gdb init response
	let exp_result = "GNU gdb"
	let result_pre = strpart(result, 0, 7)
	if result_pre != exp_result
		:throw 'gdb start result: expected: [' . exp_result . ']... . got: [' . result_pre . ']'
	endif

	:sil exe "%!gclient gdb_cmd file lua"
	:sil exe "%!gclient gdb_cmd start"
	:sil clo!

	"fix heights
"	call ResizeWindows()

	"set exe pos after first (start) step
	let g:exe_pos = 0

endfunction

"resizes top and bottom window heights, which get changed after function calls
"that create new temporary windows
function! ResizeWindows()
	call GotoNavWin()
	sil exe "res" g:top_win_height
	if g:show_detail_win 
		call GotoDetailWin()
		exe "res" g:bot_win_height
	endif
endfunction

function! GotoSrcLine(src, lnum)
	call GotoSrcWin()
	:sil exe ":e " a:src
	call cursor(a:lnum, 1)
endfunction

function! BaseName(fname)
	let toks = split(a:fname, "/")
	return toks[len(toks) - 1]
endfunction

"appends final recorded step file:line to nav win
"TODO: possibly replace with call to UpdateNav()
"DONE
function! AppendNavLine()
	call GotoNavWin()
	let step_info = g:ape_steps[len(g:ape_steps) - 1]
	let fname = BaseName(step_info['src_file'])
	let lnum = step_info['src_line']
	exe "normal o" . fname . ":" . lnum . "\n"
	exe "normal dd"
	:w
endfunction

"appends current src file:line to steps list, appends to nav win, erases nar win
function! NewNavNarStep()

	let step_info = {}
	let cur_src_file = GetExeSourceFile()
	let cur_src_line = GetExeSourceLine()
	let step_info['src_file'] = cur_src_file
	let step_info['src_line'] = cur_src_line
	let step_info['continue'] = ""
	let step_info['narr'] = ""
	call add(g:ape_steps, step_info)

	"check after append new step: exe pos should be equal to position of final step in list
	if g:exe_pos != len(g:ape_steps) - 1 
		let final_step_pos = len(g:ape_steps) - 1
		:throw "invalid exe pos after increment in NewNavNarStep(), g:exe_pos: " . g:exe_pos . ", len(g:ape_steps) - 1: " . final_step_pos
	endif

	"update nav window
	call UpdateNav()

	"set cursorline to final nav line
	sil call cursor('$', 1)

	" goto nar win for new entry
	call GotoNarWin()
	"erase any existing nar window content
	:%d
	:w

endfunction

"fills content of nav window with step lines, sets exe cursor at exe line
function! UpdateNav()
	call GotoNavWin()
	"delete existing content
	:1,$d

	"get current exe step info
	let exe_step = g:ape_steps[g:exe_pos]
	let exe_src_file = BaseName(exe_step['src_file'])
	let exe_src_line = exe_step['src_line']

	"build new content for nav window
	let lines = []
	let num_steps = len(g:ape_steps)
	for i in range(0, num_steps - 1)
		let step = g:ape_steps[i]
			let prefix = '  '
			let fname = BaseName(step['src_file'])
			let lnum = step['src_line']
			if fname == exe_src_file && lnum == exe_src_line
				let prefix = '> '
			endif
			let ln = prefix . fname . ":" . lnum
			call add(lines, ln)
	endfor

	"put to nav buffer
	call setline(1, lines)

	"save it
	:w

	"init nav cursor pos
	if g:nav_pos == -1
		let g:nav_pos = 0
	end

	"set cursor to nav cursor pos
	call GotoNavWin()
	call cursor(g:nav_pos + 1, 1)

endfunction

"returns 0-based index of line position of cursor in nav window.
"NOTE: currently, sets the focus to the nav window.
"TODO: add save/restore of current window
function! GetNavPos()
"	call GotoNavWin()
"	let cursor_pos = line(".")
"	return cursor_pos
	return g:nav_pos
endfunction

"fills content of narrative window with current nav step narrative content
function! UpdateNar()
	let cursor_pos = GetNavPos()

	call GotoNarWin()
	"delete existing content
	:1,$d

	"build new content
	let nav_step = g:ape_steps[cursor_pos]
	let narr = nav_step['narr']

	"put to nar buffer
	let @t = narr
	exe 'normal "tP'

	"save it
	:w
endfunction

"writes out g:ape_steps list in vim format, allowing for sourcing by ReadSteps()
function! WriteSteps()

	"save narr in current step
	let pos = GetNavPos()
	call SaveNarrative(pos)

	let lines = []
	let ln = "let g:ape_steps = ["
	call add(lines, ln)

	let num_steps = len(g:ape_steps)
	for i in range(0, num_steps - 1)
		let step = g:ape_steps[i]
		let ln = "\\ {"
		call add(lines, ln)

		let ln = "\\    'src_file' : \"" . step['src_file'] . "\"," 
		call add(lines, ln)

		let ln = "\\    'src_line' : \"" . step['src_line'] . "\"," 
		call add(lines, ln)

		let ln = "\\    'continue' : \"" . step['continue'] . "\"," 
		call add(lines, ln)

		let narr = get(step, 'narr', '')
		let snarr = substitute(narr, "\n", "\\\\n", "g")
		let ln = "\\    'narr' : \"" . snarr . "\","
		call add(lines, ln)

		let ln = "\\ },"
		call add(lines, ln)
	endfor

	let ln = "\\]"	
	call add(lines, ln)

	let fname = g:ape_steps_file
	call writefile(lines, fname)
endfunction

function! ReadSteps()
	let fname = g:ape_steps_file 
	if !filereadable(fname)
		return 0
	endif
	exe "so " fname

	return 1
endfunction

function! OnNavCursorMoved()
	"recursion check
	if g:in_autonav 
		throw "already in OnNavCursorMoved()!"
	endif
	let g:in_autonav = 1

call DbOut("BEG OnNavCursorMoved()")
"call DbOut("---g:ape_steps:\n" . string(g:ape_steps))

	"don't do anything if no content yet
	if g:exe_pos < 0
		return
	endif

	"get the actual cursor pos in nav window, not the one returned by GetNavPos()
"	call GotoNavWin()	"this shouldn't be needed as focus should already be in nav window
	let actual_pos = line(".") - 1
call DbOut("actual_pos: " . actual_pos)
	
	"save current nar content if any, first
"call DbOut("---g:ape_steps:\n" . string(g:ape_steps))
	let prev_pos = g:nav_pos
call DbOut("prev_pos: " . prev_pos)
"call DbOut("BEF SaveNarrative()")
	call SaveNarrative(prev_pos)

"call DbOut("BEF UpdateNar()")
"call DbOut("---g:ape_steps:\n" . string(g:ape_steps))

	"set new nav cursor pos to actual pos
	let g:nav_pos = actual_pos

	"update narrative window to correspond to nav pos
"call DbOut("BEF UpdateNar()")
	call UpdateNar()

	"update cursor pos in source win to correspond to nav pos
	let src_file = GetNavSourceFile()
	let src_line = GetNavSourceLine()
	call GotoSrcLine(src_file, src_line)
	:sil redraw

"call DbOut("BEF GotoNavWin()")
	"make sure focus is back in nav win at end
	call GotoNavWin()

	let g:in_autonav = 0
call DbOut("END OnNavCursorMoved()")
endfunction

function! DefineAutoNav()
	:au! CursorMoved nav
	:au CursorMoved nav :call OnNavCursorMoved()
endfunction

function! Init()
	"clear global vars
	let g:in_autonav = 0

	call CloseWindows()
	call SetupWindows()
	call SetupGdb()
	call SetMappings()

	"erase any existing nav window content
	call GotoNavWin()
	:%d
	:w

	"erase any existing nar window content
	call GotoNarWin()
	:%d
	:w

	"erase any existing detail window content
	call GotoDetailWin()
	:%d
	:w

	"append first file:line to nav window, ape list
	let have_steps = ReadSteps()

	"get exe info
	let exe_src_file = GetExeSourceFile()
	let exe_src_line = GetExeSourceLine()
	
	"set nav/narr to content of first step
	if have_steps
		let g:exe_pos = 0

		"make sure first step matches current (beginning) gdb exe location
		let nav_step = g:ape_steps[g:exe_pos]
		if nav_step['src_file'] != exe_src_file
			:throw "init nav file != init exe file"
		end
		if nav_step['src_line'] != exe_src_line
			:throw "init nav line != init exe line"
		end

		"fill nav window with steps
		call UpdateNav()

		"set the nav cursor pos to exe pos, so the narr for the correct step will be set
		"TODO: replace with function SetNavPos()
		call cursor(g:exe_pos + 1, 1)
		
		"fill nar window with narr text for first step
		call UpdateNar()
	else
		let g:ape_steps = []

		"add initial pos to steps list
		call NewNavNarStep()

		"delete empty line above first step
		exe "normal k"
		exe "normal dd"
		:w
	endif

	"show initial location in src window
	call GotoSrcLine(exe_src_file, exe_src_line)

	call ResizeWindows()

	"end with cursor in narr win
	call GotoNarWin()

	"define autocmd for nav cursor
	call DefineAutoNav()

	call DbOut("End Init()")
endfunction

"saves content of narrative window to 'narr' member of step at param 0-based index in steps array
function! SaveNarrative(step_pos)
"	let pos = g:exe_pos
"	let pos = GetNavPos()
	let pos = a:step_pos
"call DbOut("SaveNarrative(): saving narrative to nav pos: " . pos)
	let step_info = g:ape_steps[pos]
	call GotoNarWin()
	:sil 1,$y n
	let step_info['narr'] = @n		
endfunction

"if exe pos at end of step list, does new gdb step_type, else does gdb step['continue']
function! Step(step_type)

	"save current narrative
	let pos = GetNavPos()
	call SaveNarrative(pos)

	let step_type = a:step_type
	let num_steps = len(g:ape_steps)

	"if before final recorded step, get 'continue' type
	if g:exe_pos < num_steps - 1

		"get step type from recorded step
		let cur_step = g:ape_steps[g:exe_pos]
		let step_type = cur_step['continue']

		"do step in gdb
		:sil new scratch
		:sil exe "%!gclient gdb_cmd " step_type
		:sil clo!

		"increment exe pos
		let g:exe_pos = g:exe_pos + 1

		"update source win
		let exe_src_file = GetExeSourceFile()
		let exe_src_line = GetExeSourceLine()
		call GotoSrcLine(exe_src_file, exe_src_line)

		"update nav win
		call UpdateNav()

		"set nav cursor pos to exe pos
		"TODO: replace with function SetNavPos()
		call cursor(g:exe_pos + 1, 1)

		"update nar win
		call UpdateNar()

	else
		"do new step in gdb
		call NewStep(step_type)

	endif

	"get everything all positioned nicely and such at the end
	call ResizeWindows()
	call GotoSrcWin()
	call GotoNarWin()
	:sil redraw

endfunction

"does a new step in gdb, appends to step list
function! NewStep(step_type)

	"save continue type for current step
	let cur_step = g:ape_steps[g:exe_pos]
	let cur_step['continue'] = a:step_type

	"step
	:sil new scratch
	:sil exe "%!gclient gdb_cmd " a:step_type
	:sil clo!

	"inc exe pos
	let g:exe_pos = g:exe_pos + 1	

	"get line info
	let src = GetExeSourceFile()
	let lnum = GetExeSourceLine()

	"update src win
	call GotoSrcLine(src, lnum)

	"add current pos to steps list
	call NewNavNarStep()

endfunction


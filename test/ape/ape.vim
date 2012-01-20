"ape.vim	:	vim script to implement annotated program execution

let g:top_win_height = 5
let g:mid_win_height = 25
"let g:bot_win_height = 5
let g:nav_win_width = 20

let g:ape_dir = "test/ape"
let g:help_file = g:ape_dir . "/" . "ape-doc.txt"

"0-based index of line position of the '>' cursor in the nav window
"let g:nav_pos = 0

"0-based index of current program step in 'ape_steps' array, indicated by '>' cursor in the nav window
let g:ape_steps = []
let g:exe_pos = -1

let g:ape_steps_file = "ape_steps.vim"

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
"	call WinMoveDown()
"	exe g:bot_win_height "new"
"	:e detail
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
	exe "normal \<c-w>k"
	"can also do:  :wincmd k
endfunction

function! WinMoveDown()
	exe "normal \<c-w>j"
	"can also do:  :wincmd j
endfunction

function! GotoWin(nr)
	exe ":" a:nr "wincmd w"
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

"function! GotoDetailWin()
"	call GotoWin(winnr("$"))
"endfunction

"returns src file of vim cursor line in nav window
function! GetCursorSourceFile()
	call GotoNavWin()
	let pos = line(".")
	let step = g:ape_steps[pos]
	let src_file = step['src_file']
	return src_file
endfunction

"returns src line of vim cursor line in nav window
function! GetCursorSourceLine()
	call GotoNavWin()
	let pos = line(".")
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

	:sil exe "%!gclient gdb_cmd file lua"
	:sil exe "%!gclient gdb_cmd start"
	:sil clo!

	"fix heights
	call ResizeWindows()

	"set exe pos after first (start) step
	let g:exe_pos = 0

endfunction

"resizes top and bottom window heights, which get changed after function calls
"that create new temporary windows
function! ResizeWindows()
	call GotoNavWin()
	exe "res" g:top_win_height
"	call GotoDetailWin()
"	exe "res" g:bot_win_height
endfunction

function! GotoSrcLine(src, lnum)
	call GotoSrcWin()
	:sil exe ":e " a:src
	:sil exe ":" a:lnum
	:sil set cursorline
	:sil redraw
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
"	call AppendNavLine()
	call UpdateNav()

	"TODO: set cursorline to final nav line

	" goto nar win for new entry
	call GotoNarWin()
	"erase any existing nar window content
	:%d
	:w

endfunction

"obsolete, replaced by WriteSteps()
function! WriteStepsXml()
	let lines = []
	call add(lines, "<ape>")
	call add(lines, "<title>")
	call add(lines, "Annotated Program Execution for lua interpreter")
	call add(lines, "</title>")

	let num_steps = len(g:ape_steps)
	for i in range(0, num_steps - 1)
		let step = g:ape_steps[i]
		let ln = '<step src_file="' . step['src_file'] . '" src_line="' . step['src_line'] . '">'
		call add(lines, ln)

		let ln = '<narrative>'
		call add(lines, ln)

		let narr = get(step, 'narr', '')
		"must get narr lines into list because writefile() will write null for newlines
		let narr_lines = split(narr, '\n')
"		call add(lines, ln)
		call extend(lines, narr_lines)

		let ln = '</narrative>'
		call add(lines, ln)

		let ln = '</step>'
		call add(lines, ln)
	endfor

	call add(lines, "</ape>")

	let fname = g:ape_steps_file
	call writefile(lines, fname)
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

endfunction

"fills content of narrative window with current nav step narrative content
function! UpdateNar()
	call GotoNarWin()
	"delete existing content
	:1,$d

	"build new content
	let cursor_pos = line(".")
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

	"fill nav window with steps
	call UpdateNav()

	"fill nar window with narr text for first step
	call UpdateNar()

	return 1
endfunction

function! Init()
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

	"append first file:line to nav window, ape list
	let have_steps = ReadSteps()

	"get exe info
	let exe_src_file = GetExeSourceFile()
	let exe_src_line = GetExeSourceLine()

	"if steps were read, make sure first step matches current (beginning) gdb exe location
	if have_steps
		let g:exe_pos = 0
		let nav_step = g:ape_steps[g:exe_pos]
		if nav_step['src_file'] != exe_src_file
			:throw "init nav file != init exe file"
		end
		if nav_step['src_line'] != exe_src_line
			:throw "init nav line != init exe line"
		end
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
	call ResizeWindows()
	call GotoSrcLine(exe_src_file, exe_src_line)

	"end with cursor in nav win
	call GotoNavWin()

endfunction

function! SaveNarrative()
	let step_info = g:ape_steps[len(g:ape_steps) - 1]
	call GotoNarWin()
	:sil 1,$y n
	let step_info['narr'] = @n
endfunction

"if exe pos at end of step list, does new gdb step_type, else does gdb step['continue']
function! Step(step_type)
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

	else
		"do new step in gdb
		call NewStep(step_type)

	endif

endfunction

"does a new step in gdb, appends to step list
function! NewStep(step_type)

	"save current narrative
	call SaveNarrative()

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
	call ResizeWindows()
	call GotoSrcLine(src, lnum)

	"add current pos to steps list
	call NewNavNarStep()

endfunction


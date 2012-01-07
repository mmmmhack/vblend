let s:top_win_height = 5
let s:mid_win_height = 25
"let s:bot_win_height = 5
let s:nav_win_width = 20

"let s:cur_src_file = ""
"let s:cur_src_line = 0

"0-based index of line position of the '>' cursor in the nav window
let s:nav_pos = 0

"0-based index of current program step in 'ape_steps' array
let s:exe_pos = 0

let g:ape_steps = []
let g:ape_steps_file = "ape_steps.vim"

function! SetupWindows()
	"create narrative window at top
	:new
	call WinMoveUp()
	:clo
	:e narrative

	"create middle src window
	exe ":" s:mid_win_height "new"
	:e source

	"create nav window left of narrative window
	call WinMoveUp()
	exe "vert " s:nav_win_width "new"
	:e nav
	:set cursorline

	"create detail window below source window
"	call WinMoveDown()
"	exe s:bot_win_height "new"
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
function! GetExeSrcLine()
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

	"check gdb running
	:sil 1,$y r
	let result = @r
	if result == "504 Gdb Not Running"
		:throw 'gdb not running'
	endif

	:sil exe "%!gclient gdb_cmd file lua"
	:sil exe "%!gclient gdb_cmd start"
	:sil clo!
	"get line info
"	let src = GetSourceFile()
"	let lnum = GetCurrentLine()

	"fix heights
	call ResizeWindows()

	"goto line in src file
"	call GotoSrcLine(src, lnum)

	"save cur file,line for script
"	let s:cur_src_file = src
"	let s:cur_src_line = lnum
	let s:exe_pos = 0

endfunction

"resizes top and bottom window heights, which get changed after function calls
"that create new temporary windows
function! ResizeWindows()
	call GotoNavWin()
	exe "res" s:top_win_height
"	call GotoDetailWin()
"	exe "res" s:bot_win_height
endfunction

function! GotoSrcLine(src, lnum)
	call GotoSrcWin()
	:sil exe ":e " a:src
	:sil exe ":" a:lnum
	:sil set cursorline
	:sil redraw
endfunction

function! SetMappings()
	:map <f8> :call Step('step')
	:map <f9> :call Step('next')
endfunction

function! BaseName(fname)
	let toks = split(a:fname, "/")
	return toks[len(toks) - 1]
endfunction

"appends current src file:line to nav win
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
function! AppendStep()
	let step_info = {}
"	let step_info['src_file'] = s:cur_src_file
"	let step_info['src_line'] = s:cur_src_line
	let cur_src_file = GetExeSourceFile()
	let cur_src_line = GetExeSourceLine()
	let step_info['src_file'] = cur_src_file
	let step_info['src_line'] = cur_src_line
	call add(g:ape_steps, step_info)
	call AppendNavLine()

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

"fills content of nav window with step lines, sets pointer to current line
function! UpdateNav()
	call GotoNavWin()
	"delete existing content
	:1,$d

	"build new content
	let cur_src_file = BaseName(s:cur_src_file)
	let lines = []
	let num_steps = len(g:ape_steps)
	for i in range(0, num_steps - 1)
		let step = g:ape_steps[i]
			let pref = '  '
			let fname = BaseName(step['src_file'])
			let lnum = step['src_line']
			if fname == cur_src_file && lnum == s:cur_src_line
				let pref = '> '
				let s:ape_cursor_pos = i
			endif
			let ln = pref . fname . ":" . lnum
			call add(lines, ln)
	endfor

	"put to nav buffer
	call setline(1, lines)

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
	if !ReadSteps()
		let g:ape_steps = []
		call AppendStep()

		"delete empty line above first step
		exe "normal k"
		exe "normal dd"
		:w
	endif

endfunction

function! SaveNarrative()
	let step_info = g:ape_steps[len(g:ape_steps) - 1]
	call GotoNarWin()
	:sil 1,$y n
	let step_info['narr'] = @n
endfunction

"if ape cursor at end of step list, does new step, else increments cursor position
function!Step(step_type)
	let num_steps = len(g:ape_steps)
	if s:ape_cursor_pos < num_steps - 1
		let s:ape_cursor_pos = s:ape_cursor_pos + 1
		call UpdateNav()
	else	
		call NewStep(a:step_type)
	endif
endfunction

"does a new step in gdb, appends to step list
function! NewStep(step_type)
	"save current narrative
	call SaveNarrative()

	"step
	:sil new scratch
	:sil exe "%!gclient gdb_cmd " a:step_type
	:sil clo!

	"get line info
	let src = GetSourceFile()
	let lnum = GetCurrentLine()

	"save cur file,line for script
	let s:cur_src_file = src
	let s:cur_src_line = lnum

	"fix heights
	call ResizeWindows()

	"goto line in src file
	call GotoSrcLine(src, lnum)

	"add current pos to steps list
	call AppendStep()

endfunction


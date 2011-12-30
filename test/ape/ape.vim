let s:top_win_height = 5
let s:mid_win_height = 25
let s:bot_win_height = 5
let s:nav_win_width = 20

let s:cur_file = ""
let s:cur_line = 0

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

	"create detail window below source window
	call WinMoveDown()
	exe s:bot_win_height "new"
	:e detail
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

function! GotoDetailWin()
	call GotoWin(winnr("$"))
endfunction

"get-source-file.vim	:	parses output of gdb 'info source', returns fqp of source file
function! GetSourceFile()
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
function! GetCurrentLine()
	:sil new scratch
	:sil %!gclient gdb_cmd bt
	:sil 1,$y l
	:let g:ln = @l
	:let g:matches = matchlist(g:ln, ":\\(\\d\\+\\)")
	:sil clo!
	return g:matches[1]
endfunction

function! SetupGdb()
	:sil new scratch
	:sil exe "%!gclient start_gdb"
	:sil exe "%!gclient gdb_cmd file lua"
	:sil exe "%!gclient gdb_cmd start"
	:sil clo!
	"get line info
	let src = GetSourceFile()
	let lnum = GetCurrentLine()

	"fix heights
	call ResizeWindows()

	"goto line in src file
	call GotoSrcLine(src, lnum)

	"save cur file,line for script
	let s:cur_file = src
	let s:cur_line = lnum

endfunction

"resizes top and bottom window heights, which get changed after function calls
"that create new temporary windows
function! ResizeWindows()
	call GotoNavWin()
	exe "res" s:top_win_height
	call GotoDetailWin()
	exe "res" s:bot_win_height
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

function! Init()
	call CloseWindows()
	call SetupWindows()
	call SetupGdb()
	call SetMappings()

	"append current file:line to nav window, ape list
	call GotoNavWin()
	let fname = BaseName(s:cur_file)
	exe "normal i" . fname . ":" . s:cur_line . "\n"
	:w
	exe "normal k"

endfunction

function! Step(step_type)
	"step
	:sil new scratch
	:sil exe "%!gclient gdb_cmd " a:step_type
	:sil clo!

	"get line info
	let src = GetSourceFile()
	let lnum = GetCurrentLine()

	"save cur file,line for script
	let s:cur_file = src
	let s:cur_line = lnum

	"fix heights
	call ResizeWindows()

	"goto line in src file
"	call GotoSrcWin()
"	:sil exe ":e " src
"	:sil exe ":" lnum
"	:sil set cursorline
	call GotoSrcLine()

	"back to nav window
	call GotoNavWin()
endfunction


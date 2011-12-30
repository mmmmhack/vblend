:function! WinMoveUp()
:exe "normal \<c-w>k"
"can also do:  :wincmd k
:endfunction

:function! WinMoveDown()
:exe "normal \<c-w>j"
"can also do:  :wincmd j
:endfunction

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

function! ExeLine()
	:exe "normal" '"ay$'
	:exe "normal" "j"
	:let cur_win = winnr()
	:let detail_win = winnr("$")
	:exe ":" detail_win "wincmd w"
	:exe ":%!" @a
	:exe ":" cur_win "wincmd w"
endfunction

function! GotoWin(nr)
	:exe ":" a:nr "wincmd w"
endfunction

function! Trace()
	:let trace_win = 2
	:let detail_win = winnr("$")
	:call GotoWin(detail_win)
	:sil exe "%!gclient gdb_cmd step"
	:sil exe "normal" '"sy$'
	:sil exe "%!gclient gdb_cmd bt"
	:sil exe "normal" '"by$'
	:let backtrace = @b
	:sil exe "%!gclient gdb_cmd info locals"
	:sil exe ":1,$y l"
	:let locals = @l
	:let msg = backtrace . "\n--- locals:\n" . locals
	:let @m = msg
	:sil exe ":1,$d"
	:sil exe "normal" '"mp'
	:call GotoWin(trace_win)
endfunction

function! SetupWindows()
	"create narrative window at top
	:new
	:call WinMoveUp()
	:clo
	:e narrative
	:25new
	:e source
	:call WinMoveUp()
	"create nav window left of narrative window
	:vert 20new
	:e nav

	"create detail window below source window
	:call WinMoveDown()
	:10new
	:e detail
endfunction


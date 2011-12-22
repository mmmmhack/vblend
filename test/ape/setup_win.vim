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

"create narrative window at top
:new
:call WinMoveUp()
:clo
:e narrative
:25new
:e source
:call WinMoveUp()
"create nav window left of narrative window
:vert 10new
:e nav

"create detail window below source window
:call WinMoveDown()
:10new
:e detail

-- line_buf.lua	:	manages lines of text in a text buffer
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.cur_line = 0
M.lines = {
	[0] = "",
}

-- returns content of param line number or current line number if not specified
M.get = function(ln_num)
	ln_num = ln_num or M.cur_line
	return M.lines[ln_num]
end

-- updates screen with current line content
M.update_scr = function()
	row = M.cur_line
	col = 0

	-- erase existing row
	content = string.rep(" ", tflua.num_screen_cols())
	tflua.set_screen_buf(row, col, content)

	-- set new row
	content = M.get()
	tflua.set_screen_buf(row, col, content)
end

-- sets content of param line number or current line number if not specified
M.set = function(content, ln_num)
	ln_num = ln_num or M.cur_line
	M.lines[ln_num] = content

	M.update_scr()
end



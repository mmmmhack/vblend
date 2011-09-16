-- cursor.lua	: sets/gets screen cursor (obsolete) TODO: remove
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.buf = nil  -- TODO: replace with buffer
M.saved_buf_pos = {0, 0}

--[[
M.inc = function (ncols)
--	row, col = tflua.get_cursor()
	
	M.buf.set_cursor_pos({row, col+ncols})
end
--]]

--[[
M.save_scr_pos = function (pos)
	M.saved_pos[1] = pos[1]
	M.saved_pos[2] = pos[2]
end
--]]

M.get_scr_pos = function()
	local row, col = tflua.get_cursor()
	return {row, col}
end

M.set_scr_pos = function(pos)
--print(string.format("cursor.set_pos(%d, %d)", pos[1], pos[2]))
	tflua.set_cursor(pos[1], pos[2])
--	win.scroll_to_visible()
end



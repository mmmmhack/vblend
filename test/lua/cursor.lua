-- cursor.lua
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.saved_pos = {0, 0}

M.inc = function (ncols)
	row, col = tflua.get_cursor()
--	tflua.set_cursor(row, col + ncols)
	M.set_pos({row, col+ncols})
end

M.save_pos = function (pos)
	M.saved_pos[1] = pos[1]
	M.saved_pos[2] = pos[2]
end

M.get_pos = function()
	row, col = tflua.get_cursor()
	return {row, col}
end

M.set_pos = function(pos)
--print(string.format("cursor.set_pos(%d, %d)", pos[1], pos[2]))
	tflua.set_cursor(pos[1], pos[2])
end



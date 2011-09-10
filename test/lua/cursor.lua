-- cursor.lua
local modname = ...
local M = {}
M.saved_pos = {[0] = 0, [1] = 0}

M.inc = function (ncols)
	row, col = tflua.get_cursor()
	tflua.set_cursor(row, col + ncols)
end

M.save_pos = function (pos)
	M.saved_pos[0] = pos[0]			
	M.saved_pos[1] = pos[1]			
end

M.set_pos = function(pos)
	tflua.set_cursor(pos[0], pos[1])
end

_G[modname] = M
package.loaded[modname] = M
--return M

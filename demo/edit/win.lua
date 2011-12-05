-- win.lua	:	window routines (obsolete?)
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.win_rows = 36
M.win_cols = 80
M._scroll_pos = {0, 0}

M.scroll_pos = function()
	return M._scroll_pos
end

-- called on cursor movement, scrolls window to make cursor visible
M.scroll_to_visible = function()
	-- get cursor pos
	local cpos = cursor.get_pos()
	local crow = pos[1]
	local ccol = pos[2]
	-- get new view dimensions
	-- get current view dimensions
	-- calc scroll
end

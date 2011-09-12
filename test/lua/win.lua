-- win.lua	:	window routines
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M._scroll_pos = {0, 0}

M.scroll_pos = function()
	return M._scroll_pos
end

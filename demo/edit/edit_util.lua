-- edit_util.lua : utility for edit app

local modname = ...
local M = {}
_G[modname] = M
package.loaded[modname] = M

M.pos2str = function(t)
	local s = string.format("(%d, %d)", t[0], t[1])
	return s
end

-- edit_util.lua : utility for edit app

local modname = ...
local M = {}
_G[modname] = M
package.loaded[modname] = M

M.pos2str = function(t)
	local s = string.format("(%d, %d)", t[0], t[1])
	return s
end

M.new_pos = function(x, y)
	local t = {[0]=x, [1]=y}
	return t
end

-- splits line at param col into 3 pieces and returns them: (line_pre, ch, line_post)
M.split_line = function(ln, col)
	local ln_pre = string.sub(ln, 1, col-1 + 1) -- convert from 0-based to 1-based
	local ch = string.sub(ln, col + 1, col + 1)
	local ln_pst = string.sub(ln, col + 1 + 1)
	return ln_pre, ch, ln_pst
end


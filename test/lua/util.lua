-- util.lua	:	misc utilities
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.isdigit = function(s)
	n = string.byte(s)
	return n >= string.byte("0") and n <= string.byte("9")
end

M.isprintable = function(ch)
	n = string.byte(ch)
	min = string.byte(' ')
	max = string.byte('~')
	return n >= min and n <= max
end

M.ptable = function(t)
	for k,v in pairs(t) do
		print("k: [" .. k .. "], v: [" .. tostring(v) .. "]")
	end
end

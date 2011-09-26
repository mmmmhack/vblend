-- util.lua	:	misc utilities
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.isdigit = function(s)
	local n = string.byte(s)
	return n >= string.byte("0") and n <= string.byte("9")
end

M.isprintable = function(ch)
	local n = string.byte(ch)
	local min = string.byte(' ')
	local max = string.byte('~')
	return n >= min and n <= max
end

M.ptable = function(t)
	for k,v in pairs(t) do
		print("k: [" .. k .. "], v: [" .. tostring(v) .. "]")
	end
end

M.trim = function(s)
	local r = string.match(s, "^%s*(.-)%s*$")
	return r
end

M.dump_debug_info = function (info, label)
	print(string.format("---%s: debug info:", label))
	for k,v in pairs(info) do
		print("  ", k, v)
	end
end


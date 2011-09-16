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

--M.traceback = function()
--TODO: modularize
function traceback()
	for level = 1, math.huge do 
		local info = debug.getinfo(level, "Sl") 
		if not info then break end 
		if info.what == "C" then -- is a C function? 
			print(level, "C function") 
		else -- a Lua function 
			print(string.format("[%s]:%d", info.short_src, 
			info.currentline)) 
		end 
	end 
end


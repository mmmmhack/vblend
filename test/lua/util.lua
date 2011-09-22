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

local _break_src = nil
local _break_line = nil
function trace(event, line)
	local info = debug.getinfo(2, 'Sl')
--print("trace(): source:line: " .. info.source .. ":" .. line)
	if info.source == "@./lua/" .. _break_src and info.currentline == _break_line then
		print("breakpoint hit!")
		traceback()
		while true do
			io.write("trace> ")
			local ln = io.read()
			print("you entered: " .. ln)
		end
	end
end

function set_breakpoint(src, line_num)
	_break_src = src
	_break_line = line_num
	debug.sethook(trace, "l")
end


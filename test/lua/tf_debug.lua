-- tf_debug.lua	:	implements a simple lua debugger
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

local _break_src = nil
local _break_line = nil

M.print_help = function ()
	print("--- commands:");
	print("  b FILE:LINE   :    set breakpoint");
	print("  c             :    continue program execution");
	print("  q             :    quit program");
	print("  h             :    show this help");
	print("");
end

M.print_prompt = function ()
	io.write("> ");
end

M.set_breakpoint = function (ln)
	ln = util.trim(ln)
	-- pat match: \s*SRC_FILE:LINE_NUM
	local src, line = string.match(ln, "(.+):(%d+)")
	line = tonumber(line)
	if src == nil or line == nil then
		io.stderr:write("Error: missing or invalid breakpoint arg\n")
		debug.sethook()
		return
	end
	_break_src = src
	_break_line = line
	print(string.format("breaking at %s:%d\n", _break_src, _break_line));
	debug.sethook(M.check_breakpoints, "l")
end

M.check_breakpoints = function (event, line)
	local info = debug.getinfo(2, 'Sl')
--print("tf_debug.check_breakpoints(): source:line: " .. info.source .. ":" .. line)
--print("_break_src=[" .. _break_src .. "], _break_line=[" .. _break_line .. "]")
	if info.source == "@./lua/" .. _break_src and info.currentline == _break_line then
		print("breakpoint hit!")
		traceback()
		debug_console()
	end
end

-- global funcs
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

function debug_console()
	local get_input = true
	while get_input do
		M.print_prompt();
		local ln = io.read()
		ln = util.trim(ln)
		if #ln ~= 0 then
			local c = string.sub(ln, 1, 1)
--print("c: [" .. c .. "]")
			-- continue
			if 		 c == 'c' then
				get_input = false;
			elseif c == 'b' then
				M.set_breakpoint(string.sub(ln, 2))
			elseif c == 'h' then
				M.print_help()
			elseif c == 'q' then
				tflua.quit()		-- TODO: replace with tfedit.quit()
				do return end
			else
				print("unknown command '" .. c .. "'")
			end
		end
	end
	print("continuing program execution");
end


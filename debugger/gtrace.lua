-- gtrace.lua	:	traces single-step execution of a program using gstep and gdb

require('util')
require('debugger')

local sources_filters = {
	-- blank line
	'^%s*$',	
	-- descrip lines
	'^Source files for which.*',
	-- prompt
	'%(gdb%) ',
}

function cmd(cmd, debug)
	if debug then
		print(string.format("---%s:", cmd))
	end
	local fh = io.popen("gclient " .. cmd)
	local resp = fh:read("*a")
	if debug then
		print(string.format("resp: %s", resp))
	end
	return resp
end

function gcmd(gcmd, debug)
	local resp = cmd("gdb_cmd " .. gcmd, debug)
	return resp
end

function filter_string(s, filters)
	for i, pat in ipairs(filters) do
		local m = string.match(s, pat)		
		if m ~= nil then
			return nil
		end
	end
	return s
end

function filter_strings(strings, filters)
	local filtered_strings = {}
	for i, s in ipairs(strings) do
		local fs = filter_string(s, filters)
		if fs ~= nil then
			filtered_strings[#filtered_strings + 1] = fs
		end
	end
	return filtered_strings
end

function pass_string(s, pass_conds)
	for i, pat in ipairs(pass_conds) do
		local m = string.match(s, pat)		
		if m == nil then
			return nil
		end
	end
	return s
end

function pass_strings(strings, pass_conds)
	local passed_strings = {}
	for i, s in ipairs(strings) do
		local fs = pass_string(s, pass_conds)
		if fs ~= nil then
			passed_strings[#passed_strings + 1] = fs
		end
	end
	return passed_strings
end


function pstrings(strings, descrip)
	descrip = descrip or ""
	print(string.format("--- %d %s:", #strings, descrip))
	for i, s in ipairs(strings) do
		print(string.format("string %d: [%s]", i, s))
	end		
end

function trim_strings(strings)
	local tstrings = {}
	for i, s in ipairs(strings) do
		tstrings[#tstrings + 1] = util.trim(s)
	end		
	return tstrings
end

function get_prog_sources()
	local resp = gcmd("info sources")
	local lines = util.split(resp, '\n')
--	pstrings(lines, "lines split from sources response")
	local flines = filter_strings(lines, sources_filters)
--	plines(flines, "filtered source lines")
	local sources = util.join(flines, ',')
--	print(string.format("sources: [%s]", sources))
	local files = util.split(sources, ',')
	files = trim_strings(files)
	files = pass_strings(files, {'^.+%.c$'})
--	pstrings(files, "source files")
	-- make em a hash for better lookup
	local hash = {}
	for i, f in ipairs(files) do
		hash[f] = 1
	end
--	return files
	return hash
end

--[[
(gdb) info source
Current source file is lua.c
Compilation directory is /Users/williamknight/proj/git/vblend/lua
Located in /Users/williamknight/proj/git/vblend/lua/lua.c
Contains 392 lines.
Source language is c.
Compiled with DWARF 2 debugging format.
Does not include preprocessor macro info.
(gdb)
--]]
function parse_info_source(resp)
	local lines = util.split(resp, '\n')
	local ln = lines[3]
	local toks = util.split(ln, ' ')
	local src_file = toks[3]
	toks = util.split(src_file, '/')
	local base_name = toks[#toks]
	return base_name
end

function in_source_list(step_src, sources)
	return sources[step_src] ~= nil
end

--[[
(gdb) info line
Line 380 of "lua.c" starts at address 0x2daf <main+13> and ends at 0x2db7 <main+21>.
(gdb) 
--]]
function parse_info_line(resp)
	local lines = util.split(resp, '\n')
	local ln = lines[1]
	local toks = util.split(ln, ' ')
	local line_num = toks[2]
	return line_num
end

function main()
	local debug = false
	cmd("start_gdb", debug)
	gcmd("file lua", debug)
	local sources = get_prog_sources()

	-- start
	gcmd("start")

local i = 0
  while true do
i = i + 1
		local src_resp = gcmd("info source")
		local step_src = parse_info_source(src_resp)

		if not in_source_list(step_src, sources) then
			break
		end

		local line_resp =gcmd("info line")
--print(string.format("line_resp: %s", line_resp))
--debug_console()
		local step_line = parse_info_line(line_resp)
		
		print(string.format("%s:%s", tostring(step_src), tostring(step_line)))

		gcmd("step")
if i > 10 then
break
end
	end

	cmd("quit_gdb")

end

main()

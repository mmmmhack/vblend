-- gen_linux_from_osx_makefile.lua  : generates Makefile.linux from Makefile.osx

require('debugger')

local this_script = "gen_linux_from_osx_makefile.lua"

local global_subs = {
  ['Mac OSX makefile'] = 'linux makefile',
  ['Makefile%.osx'] = 'Makefile.linux',
  ['%-dynamiclib %-undefined dynamic_lookup'] = '-shared -Wl,-soname,$(PREFIX)/$(notdir $@)',
  ['%-framework Cocoa'] = '',
  ['%-framework OpenGL'] = '-lGL -lGLU',
	['install_name_tool.*'] = '',
  ['SO=so'] = 'SO=so',
  ['EXE='] = 'EXE=',
}

-- math.huge works funky 
local math_real_big = 10000000000

function read_local_subs(fname)
	local local_subs = {}
	local pat = "^# local_sub %['(.+)'%] = '(.+)'$"
	for ln in io.open(fname, "r"):lines() do
--		local match = string.match(ln, pat)		-- this returns literal string match instead of captures...?
		local b, e, k, v = string.find(ln, pat)
		if b then
			local_subs[k] = v
		end
	end
	return local_subs
end

function apply_subs(buf_lines, subs)
	local sub_lines = {}
	for i = 1, #buf_lines do
		local ln = buf_lines[i]
		local skip_line = false
		if string.match(ln, "^# local_sub") then
			skip_line = true
		end
		if not skip_line then
			for pat, repl in pairs(subs) do
				ln = string.gsub(ln, pat, repl)
			end
		end
		sub_lines[i] = ln
	end
	return sub_lines
end

function main()
  if #arg < 1 then
    print(string.format("usage: %s OSX_MAKEFILE", "script"))
    os.exit(1)
  end
  local makefile_in = arg[1]

	local local_subs = read_local_subs(makefile_in) 

--  io.input(makefile_in) 
 -- local in_buf = io.read(math_real_big)
 	local in_lines = {}
	for ln in io.open(makefile_in, "r"):lines() do
		in_lines[#in_lines + 1] = ln
	end
  io.close()

  local buf_lines = in_lines
	buf_lines = apply_subs(buf_lines, local_subs)
	buf_lines = apply_subs(buf_lines, global_subs)

	print(string.format("### auto-generated from %s by %s\n", makefile_in, this_script))
	for i = 1, #buf_lines do
	  print(buf_lines[i])
	end
end

main()

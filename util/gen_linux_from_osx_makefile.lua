-- gen_linux_from_osx_makefile.lua  : generates Makefile.linux from Makefile.osx

local this_script = "gen_linux_from_osx_makefile.lua"

local subs = {
  ['Mac OSX makefile'] = 'linux makefile',
  ['Makefile%.osx'] = 'Makefile.linux',
  ['%-dynamiclib %-undefined dynamic_lookup'] = '-shared -Wl,-soname,$(PREFIX)/$(notdir $@)',
  ['%-framework Cocoa'] = '',
  ['%-framework OpenGL'] = '-lGL -lGLU',
  ['SO=so'] = 'SO=so',
  ['EXE='] = 'EXE=',
--  ['%.%./util/sys%.$%(SO%)'] = '',
--  ['libglfw/libglfw%.$%(SO%)'] = '', 
--  ['%.%./img/img.$%(SO%)'] = '',
--  ['%.%./font/tfont%.$%(SO%)'] = '', 

--  ['lua_libs='] = 'lua_libs=$(lua_dir)/lua51.dll',
}

-- math.huge works funky 
local math_real_big = 10000000000

function main()
  if #arg < 1 then
    print(string.format("usage: %s OSX_MAKEFILE", "script"))
    os.exit(1)
  end
  local makefile_in = arg[1]
--print(string.format("reading %s...", makefile_in))
  io.input(makefile_in) 
  local in_buf = io.read(math_real_big)
--print(string.format("read %d bytes", #buf))
  local buf = in_buf
  io.close()
  for pat, repl in pairs(subs) do
    buf = string.gsub(buf, pat, repl)
  end
--  print("done")
	print(string.format("### auto-generated from %s by %s\n", makefile_in, this_script))
  print(buf)
end

main()

-- gen_mingw_from_osx_makefile.lua  : generates Makefile.mingw from Makefile.osx

local subs = {
  ['Mac OSX makefile'] = 'mingw makefile',
  ['Makefile%.osx'] = 'Makefile.mingw',
  ['%-dynamiclib %-undefined dynamic_lookup'] = '-shared',
  ['%-framework Cocoa %-framework OpenGL'] = '-lopengl32 -glu32',
  ['SO=so'] = 'SO=dll',
  ['EXE='] = 'EXE=.exe',
  ['CP=cp'] = 'CP=copy',
  ['lua_libs='] = 'lua_libs=$(lua_dir)/lua51.dll',
}

-- math.huge works funky on mingw
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
  print(buf)
end

main()

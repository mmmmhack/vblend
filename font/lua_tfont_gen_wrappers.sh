# lua_tfont_gen_wrappers.sh  : script to generate lua wrapper functions for tfont.c
#lua ../parse/gen_wrappers.lua -p gl -t lua_gl_typemap.lua -s lua_gl_selfuncs.lua gl.i
lua ../parse/gen_wrappers.lua -p tfont_ -s lua_tfont_selfuncs.lua tfont.i

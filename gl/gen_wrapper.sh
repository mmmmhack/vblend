# gen_wrapper.sh  : script to generate lua wrapper functions for opengl functions
export LUA_PATH="../parse/?.lua;../gamelib/?.lua"
lua ../parse/gen_wrappers.lua -p gl -t lua_gl_typemap.lua -s lua_gl_selfuncs.lua gl.i

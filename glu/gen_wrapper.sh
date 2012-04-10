# gen_wrapper.sh  : script to generate lua wrapper functions for glu functions
export LUA_PATH="../parse/?.lua;../gamelib/?.lua;../debugger/?.lua"
lua ../parse/gen_wrappers.lua -v -p glu -t lua_glu_typemap.lua -s lua_glu_selfuncs.lua glu.i

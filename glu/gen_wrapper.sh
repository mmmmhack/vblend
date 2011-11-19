# gen_wrapper.sh  : script to generate lua wrapper functions for glu functions
lua ../parse/gen_wrappers.lua -p glu -t lua_glu_typemap.lua -s lua_glu_selfuncs.lua glu.i

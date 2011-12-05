# lua_edit_gen_wrappers.sh  : script to generate lua wrapper functions for edit.c
lua ../parse/gen_wrappers.lua -p edit_ --ret-params lua_edit_ret_params.lua edit.i

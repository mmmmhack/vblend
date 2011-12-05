// lua_edit.c	:	C code for edit module lua wrapper
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "GL/glfw.h"

#include "edit.h"

//#include "constant_defs.c"
#include "lua_edit_func_def.c"

static const struct luaL_Reg funcs[] = {
#include "lua_edit_func_reg.c"
	{NULL, NULL},
};

LUALIB_API int luaopen_lua_edit(lua_State* L) {
	luaL_register(L, "edit", funcs);
//  define_constants(L);
	return 1;
}


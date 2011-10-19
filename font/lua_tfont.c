// lua_tfont.c	:	C code for tfont lua wrapper
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "GL/glfw.h"

#include "tfont.h"

//#include "constant_defs.c"
#include "lua_tfont_func_def.c"

static const struct luaL_Reg funcs[] = {
#include "lua_tfont_func_reg.c"
	{NULL, NULL},
};

LUALIB_API int luaopen_lua_tfont(lua_State* L) {
	luaL_register(L, "tfont", funcs);
//  define_constants(L);
	return 1;
}


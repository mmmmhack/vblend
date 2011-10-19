// lua_glfw.c	:	C-lua wrapper for glfw
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "GL/glfw.h"

#include "lua_glfw_const_def.c"
#include "lua_glfw_func_def.c"

static const struct luaL_Reg funcs[] = {
#include "lua_glfw_func_reg.c"
	{NULL, NULL},
};

LUALIB_API int luaopen_lua_glfw(lua_State* L) {
	luaL_register(L, "glfw", funcs);
  define_constants(L);
	return 1;
}


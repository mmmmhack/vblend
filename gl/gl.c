// gl.c	:	C code for gl lua wrapper
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "GL/glfw.h"

#include "constant_defs.c"
#include "wrapper_funcs.c"

static const struct luaL_Reg funcs[] = {
#include "reg_list.c"
	{NULL, NULL},
};

LUALIB_API int luaopen_gl(lua_State* L) {
	luaL_register(L, "gl", funcs);
  define_constants(L);
	return 1;
}


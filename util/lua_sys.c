// lua_sys.c	:	lua-C wrappers for sys.c functions
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "sys.h"

#include "lua_sys_func_def.c"

static const struct luaL_Reg funcs[] = {
#include "lua_sys_func_reg.c"
	{NULL, NULL},
};

LUALIB_API int luaopen_lua_sys(lua_State* L) {
	luaL_register(L, "sys", funcs);
	return 1;
}


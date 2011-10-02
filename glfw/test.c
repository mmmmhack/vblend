// test glfw wrapper module by calling from C, allowing for gdb debug
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "GL/glfw.h"

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

extern int lw_getWindowParam(lua_State* L);

LUALIB_API int luaopen_glfw(lua_State* L);

int main(int argc, char* argv[]) {
	int rc;

	lua_State* L = luaL_newstate();
	luaL_openlibs(L);

/*
	int rc = luaL_dofile(L, "require_glfw.lua");
	printf("lua_dofile(require_glfw.lua) returned: %d\n", rc);
*/

	luaopen_glfw(L);

	rc = luaL_dofile(L, "test2.lua");
	printf("lua_dofile(test2) returned: %d\n", rc);

	lua_pushnumber(L, GLFW_OPENED);
	rc = lw_getWindowParam(L);
	int n = lua_tonumber(L, -1);
	printf("lw_getWindowParam() returned: %d\n", n);
	return 0;
}

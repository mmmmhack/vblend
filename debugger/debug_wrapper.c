// debug_wrapper.c : calls lua wrapper code from C, for gdb-debugging
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lua.h" 
#include "lauxlib.h" 
#include "lualib.h" 

//#include "lua_util.h"

static lua_State *L = NULL;

int main(int argc, char* argv[]) {
	printf("BEG debug_wrapper.c main()\n");

	L = luaL_newstate(); /* opens Lua */ 
	luaL_openlibs(L);    /* opens the standard libraries */ 

	// open glfw libs (if loaded from lua, gdb doesn't see it)
	LUALIB_API int luaopen_lua_glfw(lua_State* L);
	int rc = luaopen_lua_glfw(L);

	// load lua func
	const char* lua_file = "debug_wrapper.lua";
	rc = luaL_dofile(L, lua_file);
	if(rc) {
		const char* err = lua_tostring(L, -1);
		fprintf(stderr, "failed loading lua file %s: %s\n", lua_file, err);
		fprintf(stderr, "luaL_dofile() failed");
	}

	// call lua func
	lua_getglobal(L, "main");
	rc = lua_pcall(L, 0, 0, 0);
	if(rc) {
		const char* err = lua_tostring(L, -1);
		fprintf(stderr, "failed calling lua function main(): %s\n", err);
	}

	printf("END debug_wrapper.c main()\n");
  return 0;
}


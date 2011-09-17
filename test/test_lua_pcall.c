// test_lua_pcall.c : tests lua_pcall() function, with error handler
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lua.h" 
#include "lauxlib.h" 
#include "lualib.h" 

static lua_State *L = NULL;

static int l_traceback(lua_State* L) {
	printf("BEG l_traceback()\n");
	const char* err = lua_tostring(L, -1);
	if(!err) {
		printf("err is NULL\n");
//exit(0);
		return;
	}
	printf("---l_traceback\n");
	fprintf(stderr, "err: %s\n", err);
	printf("calling traceback() function\n");
	lua_getglobal(L, "traceback");
	int rc = lua_pcall(L, 0, 0, 1);
	printf("lua_pcall returned: %d\n", rc);
//exit(0);
	printf("END l_traceback()\n");
	return 0;
}

int main(int argc, char* argv[]) {
	printf("BEG main()\n");

	L = luaL_newstate(); /* opens Lua */ 
	luaL_openlibs(L); /* opens the standard libraries */ 

	// load lua test func
	const char* lua_file = "test_pcall.lua";
	int rc = luaL_dofile(L, lua_file);
	if(rc) {
		const char* err = lua_tostring(L, -1);
		fprintf(stderr, "failed loading lua file %s: %s\n", lua_file, err);
		fprintf(stderr, "luaL_dofile() failed");
	}

	// call lua func
	lua_pushcfunction(L, l_traceback);
	lua_getglobal(L, "test_pcall");
	rc = lua_pcall(L, 0, 0, 1);
	if(rc) {
		const char* err = lua_tostring(L, -1);
		fprintf(stderr, "failed calling lua function test_pcall(): %s\n", err);
	}

	printf("END main()\n");
  return 0;
}


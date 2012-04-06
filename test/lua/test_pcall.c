#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lauxlib.h"

void dump_stack(lua_State* L) {
	printf("=== lua stack:\n");
	int top = lua_gettop(L);
	if(top == 0) {
		printf("stack is empty\n");
		return;
	}
	int i;
	for(i = 1; i <= top; ++i) {
		char type[256] = "(unknown type)";
		char val[256] = "";
	
		int t = lua_type(L, i);			
		switch(t) {
		case LUA_TBOOLEAN:
			strcpy(type, "boolean");
			if(lua_toboolean(L, i))
				strcpy(val, "true");
			else
				strcpy(val, "false");
			break;
		case LUA_TFUNCTION:
			strcpy(type, "function");
			sprintf(val, "(function)");
			break;
		case LUA_TLIGHTUSERDATA:
			strcpy(type, "lightuserdata");
			sprintf(val, "(lightuserdata)");
			break;
		case LUA_TNIL:
			strcpy(type, "nil");
			sprintf(val, "nil");
			break;
		case LUA_TNONE:
			strcpy(type, "(none)");
			sprintf(val, "(invalid stack index)");
			break;
		case LUA_TNUMBER:
			strcpy(type, "number");
			lua_Number lnum = lua_tonumber(L, i);
			sprintf(val, "%f", lnum);
			break;
		case LUA_TSTRING:
			{
			strcpy(type, "string");
			const char* p = lua_tostring(L, i);
			sprintf(val, "%s", p);
			}
			break;
		case LUA_TTABLE:
			strcpy(type, "table");
			sprintf(val, "%s", "(table)");
			break;
		case LUA_TTHREAD:
			strcpy(type, "thread");
			sprintf(val, "%s", "(thread)");
			break;
		case LUA_TUSERDATA:
			strcpy(type, "userdata");
			sprintf(val, "%s", "(userdata)");
			break;
		}

		printf("stack pos %2d: %s: [%s]\n", i, type, val);
	}
}

int main(int argc, char* argv[]) {

	// new state
	lua_State* L = luaL_newstate();
	printf("created lua_State %p\n", L);
//	int top = lua_gettop(L);
//	printf("top: %d\n", top);
	dump_stack(L);


	// open libs
	luaL_openlibs(L);
	printf("opened lua libs\n");
	dump_stack(L);


//	top = lua_gettop(L);
//	printf("top: %d\n", top);

/*
	// get _G
	lua_getglobal(L, "_G");
	printf("did getglobal() for '_G'\n");
	dump_stack(L);
*/
/*
	lua_pushnumber(L, 5);
	printf("pushed number\n");
	dump_stack(L);
*/
	const char* chunk = "function sq(n) error('barf!'); return n*n end";
	int rc = luaL_loadbuffer(L, chunk, strlen(chunk), "chunk");
	if(rc) {
		if(rc == LUA_ERRSYNTAX) {
			printf("syntax error in chunk\n");
			exit(1);
		}
		else if(rc == LUA_ERRMEM) {
			printf("memory error loading chunk\n");
			exit(1);
		}
		else {
			printf("unknown error loading chunk\n");
			exit(1);
		}
	}
	printf("loaded chunk\n");
	dump_stack(L);

	// define the lua func by executing the chunk
	rc = lua_pcall(L, 0, 0, 0);
	if(rc) {
		printf("error executing chunk: %s\n", lua_tostring(L, -1));
		exit(1);
	}
	printf("executed chunk\n");
	dump_stack(L);

	// call our lua func
	lua_getglobal(L, "sq");
	lua_pushnumber(L, 2);
	printf("put func and arg on stack\n");
	dump_stack(L);

	printf("calling lua func: sq(2)\n");
	rc = lua_pcall(L, 1, 1, 0);
	if(rc) {
		printf("lua_pcall() failed: %s\n", lua_tostring(L, -1));
		exit(1);
	}
	printf("after lua_pcall()\n");
	dump_stack(L);

	float res = lua_tonumber(L, -1);
	lua_pop(L, -1);
	printf("res: %g\n", res);
	dump_stack(L);

	// close
	lua_close(L);
	return 0;
}

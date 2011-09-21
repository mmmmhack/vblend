// lua_util.c
#include <stdio.h>
#include <stdlib.h>

#include "util/sys.h"
#include "lua_util.h"

static int _min_stack = LUA_MINSTACK;

void lu_dump_stack(lua_State* L, const char* label) {
//	printf("--- BEG lu_dump_stack\n");
	printf("%s\n", label);
	int i; 
	int top = lua_gettop(L); 
	printf("top: %d\n", top);
	printf("{");
	for (i = 1; i <= top; i++) { /* repeat for each level */ 
		int t = lua_type(L, i); 
		switch (t) { 
			case LUA_TSTRING: { /* strings */ 
				printf("s:[%s]", lua_tostring(L, i)); 
				break; 
			} 
			case LUA_TBOOLEAN: { /* booleans */ 
				printf("b:[%s]", lua_toboolean(L, i) ? "true" : "false"); 
				break; 
			} 
			case LUA_TNUMBER: { /* numbers */ 
				printf("n: [%g]", lua_tonumber(L, i)); 
				break; 
			} 
			default: { /* other values */ 
				printf("t: [%s]", lua_typename(L, t)); 
				break; 
			} 
		} 
		printf(", "); /* put a separator */ 
	} 
	printf("}\n"); /* end the listing */ 
//	printf("--- END lu_dump_stack\n");
}

void lu_checkstack(lua_State* L) {
	int top = lua_gettop(L);	
//	printf("top: %d\n", top);
	if(top > _min_stack) {
		printf("Error: lua checkstack: top: %d\n", top);
//		sys_err("lua stack");	
		exit(1);
	}
}



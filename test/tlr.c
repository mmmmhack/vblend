// tlr.c	: test_lua_reg C module

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

static int get_coffee(lua_State* L) {
	lua_pushstring(L, "55 cups o' coffee");
	return 1;
}

static const struct luaL_Reg funcs[] = {
	{"get_coffee", get_coffee},
	{NULL, NULL},
};

LUALIB_API int luaopen_tlr(lua_State* L) {
	luaL_register(L, "tlr", funcs);
	return 1;
}


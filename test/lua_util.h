#ifndef test_lua_util_h
#define test_lua_util_h
#include "lua.h"

void lu_dump_stack(lua_State* L, const char* label);
void lu_checkstack(lua_State* L);

#endif

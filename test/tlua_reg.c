// tlua_reg.c : tests luaL_register() call with shared lib file
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "util/sys.h"

#include "lua_util.h"

int main(int argc, char* argv[]) {
	lua_State* L = luaL_newstate();
	luaL_openlibs(L);
	lu_dump_stack(L, "BEF dofile");
	int rc = luaL_dofile(L, "tlr_luacode.lua");
	lu_dump_stack(L, "AFT dofile");
	if(rc)
		printf("dofile failed\n");
  return 0;
}


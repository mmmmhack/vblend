// lua_setKeyCallback.c	:	custom implementation for glfwSetKeyCallback()
#include <string.h>
#include "sys.h"
static char lua_keyCallbackFuncName[256] = "";
static lua_State* LL = NULL;
static void keyCallback(int key, int action) {
	// TODO: add reentrant guard?
	if(!strlen(lua_keyCallbackFuncName)) 
		return;
	lua_getglobal(LL, lua_keyCallbackFuncName);
	lua_pushnumber(LL, key);
	lua_pushnumber(LL, action);
	int rc = lua_pcall(LL, 2, 0, 0);
	if(rc) {
		const char* err = lua_tostring(LL, -1);
		fprintf(stderr, "failed calling lua keydown handler: %s\n", err);
		sys_err("keyCallback");
	}
//	lua_pop(LL, 1);
}
static int lw_setKeyCallback(lua_State* L) {
  const char* cb_name = lua_tostring(L, -1);
	strncpy(lua_keyCallbackFuncName, cb_name, sizeof(lua_keyCallbackFuncName));
	LL = L;
  glfwSetKeyCallback(
		keyCallback
  );
  return 0;
}


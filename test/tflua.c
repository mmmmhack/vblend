// tflua.c	:	 shared lib C module of functions for lua code in tf_edit app
#include <stdio.h>
#include <stdlib.h>

#include "lua.h" 
#include "lauxlib.h" 
#include "lualib.h" 

#include "util/sys.h"
#include "edit/edit.h"
#include "font/tfont.h"

#include "tf_edit.h"

/*
static int _debug = 0;

static int l_set_debug(lua_State* L) {
	_debug  = 1;
	return 0;
}
*/

static int l_edit_set_cursor(lua_State* L) {
	int row = luaL_checknumber(L, 1);
	int col = luaL_checknumber(L, 2);
	edit_set_cursor(row, col);
	return 0;
}

static int l_edit_get_cursor(lua_State* L) {
	int row, col;
	edit_get_cursor(&row, &col);
	lua_pushnumber(L, row);
	lua_pushnumber(L, col);
	return 2;
}

static int l_sys_double_time(lua_State* L) {
	double dtime = sys_double_time();
	lua_pushnumber(L, dtime);
	return 1;
}

static int l_tfont_num_rows(lua_State* L) {
	int n = tfont_num_rows();
	lua_pushnumber(L, n);
	return 1;
}

static int l_tfont_num_cols(lua_State* L) {
	int n = tfont_num_cols();
	lua_pushnumber(L, n);
	return 1;
}

static int l_tfont_set_text_buf(lua_State* L) {
	int r = lua_tonumber(L, 1);
	int c = lua_tonumber(L, 2);
	const char* s = lua_tostring(L, 3);
	tfont_set_text_buf(r, c, s);
	return 0;
}

static int l_quit(lua_State* L) {
	tf_edit_quit();
	return 0;
}

/*
static int l_traceback(lua_State* L) {
	printf("--- BEG l_traceback\n");
	const char* err = lua_tostring(L, -1);
	if(!err)
		return 0;
	fprintf(stderr, "err: %s\n", err);
	lua_getglobal(L, "traceback");
	int rc = lua_pcall(L, 0, 0, 1);
	printf("lua_pcall returned: %d\n", rc);
	exit(0);
	return 0;
}
*/

static const struct luaL_Reg _funcs [] = {
//	{"set_debug", l_set_debug},
	{"set_cursor", l_edit_set_cursor},
	{"get_cursor", l_edit_get_cursor},
	{"get_time", l_sys_double_time},
	{"num_screen_rows", l_tfont_num_rows},
	{"num_screen_cols", l_tfont_num_cols},
	{"set_screen_buf", l_tfont_set_text_buf},
//	{"traceback", l_traceback},
	{"quit", l_quit},
	{NULL, NULL}
};

int luaopen_tflua(lua_State* L) {
	luaL_register(L, "tflua", _funcs);
	return 1;
}


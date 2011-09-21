// tf_edit.c : text display, cursor and scrolling
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "GL/glfw.h"
#include "lua.h" 
#include "lauxlib.h" 
#include "lualib.h" 

#include "util/sys.h"
#include "util/fps.h"
#include "util/win.h"
#include "font/tfont.h"
#include "edit/edit.h"

#include "tf8036_common.h"
#include "lua_util.h"
#include "tf_edit.h"

static const char* APP_TITLE = "tf_edit: text display, cursor and scrolling";
static lua_State *L = NULL;
static const char* LUA_FILE = "lua/tf_edit.lua";
static int _run = 1;
static int _debug = 0;

static int l_set_debug(lua_State* L) {
	_debug  = 1;
	return 0;
}

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
	quit();
	return 0;
}

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

static const struct luaL_Reg _tflua_lib [] = {
	{"set_debug", l_set_debug},
	{"set_cursor", l_edit_set_cursor},
	{"get_cursor", l_edit_get_cursor},
	{"get_time", l_sys_double_time},
	{"num_screen_rows", l_tfont_num_rows},
	{"num_screen_cols", l_tfont_num_cols},
	{"set_screen_buf", l_tfont_set_text_buf},
	{"traceback", l_traceback},
	{"quit", l_quit},
	{NULL, NULL}
};

static void init_lua() {
	L = luaL_newstate(); /* opens Lua */ 
lu_dump_stack(L, "AFT lua_newstate()");

	luaL_openlibs(L); /* opens the standard libraries */ 
lu_dump_stack(L, "AFT lua_openlibs()");

	// reg tfedit lua lib
	luaL_register(L, "tflua", _tflua_lib);
lu_dump_stack(L, "AFT lua_register()");

	// load lua keydown func
	int rc = luaL_dofile(L, LUA_FILE);
	if(rc) {
		const char* err = lua_tostring(L, -1);
		fprintf(stderr, "failed loading lua file %s: %s\n", LUA_FILE, err);
		sys_err("init_lua failed");
	}
lu_dump_stack(L, "AFT lua_dofile()");
}

/*
static void lua_traceback() {
	fprintf(stderr, "--- BEG traceback\n");
	lua_getglobal(L, "traceback");
	int rc = lua_pcall(L, 0, 0, 0);
	if(rc)
		fprintf(stderr, "lua traceback() function failed\n");
	fprintf(stderr, "--- END traceback\n");
}
*/

static void tick() {
//	printf("BEG tick()\n");
	lu_checkstack(L);

	lua_pushcfunction(L, l_traceback);
	lua_getglobal(L, "tick");
	int rc = lua_pcall(L, 0, 0, 1);
	if(rc) {
		const char* err = lua_tostring(L, -1);
		fprintf(stderr, "failed calling lua tick handler: %s\n", err);
//		lua_traceback();
		sys_err("tick()");
	}
	lua_pop(L, 1);

	lu_checkstack(L);
//	printf("END tick()\n");
}

static void lua_draw() {
//	printf("BEG draw()\n");
	lu_checkstack(L);
lu_dump_stack(L, "lua_draw(): BEF push traceback");
	lua_pushcfunction(L, l_traceback);
//printf("lua_draw(): AFT push traceback: top: %d\n", lua_gettop(L));
	lua_getglobal(L, "draw");
if(_debug) {
	printf("_debug flag set\n");
}
	int rc = lua_pcall(L, 0, 0, 1);
lu_dump_stack(L, "lua_draw(): AFT pcall");
	if(rc) {
		const char* err = lua_tostring(L, -1);
		fprintf(stderr, "failed calling lua draw handler: %s\n", err);
//		lua_traceback();
		sys_err("lua_draw()");
	}
	lua_pop(L, 1);

	lu_checkstack(L);
//	printf("END draw()\n");
exit(0);
}

void draw_text() {
	tfont_draw_text_buf();
	edit_draw_cursor();
}

void cb_glfw_key(int key, int state) {
//	printf("BEG cb_glfw_key()\n");
	lu_checkstack(L);
//	printf("key: %d, state: %d\n", key, state);

	// give it to lua
	lua_pushcfunction(L, l_traceback);
	lua_getglobal(L, "key_event");
	lua_pushnumber(L, key);
	lua_pushnumber(L, state);
	int rc = lua_pcall(L, 2, 0, 3);
	if(rc) {
		const char* err = lua_tostring(L, -1);
		fprintf(stderr, "failed calling lua keydown handler: %s\n", err);
//		lua_traceback();
		sys_err("cb_glfw_key");
	}
	lua_pop(L, 1);

	lu_checkstack(L);
//	printf("END cb_glfw_key()\n");
}

void quit() {
	_run = 0;
}

int main(int argc, char* argv[]) {
	init(APP_TITLE);

	const char* ln = test_line(0);
	tfont_set_text_buf(0, 0, ln);

	// setup key input
	glfwSetKeyCallback(cb_glfw_key);

	// setup lua
	init_lua();

  // main loop
  while(_run) {
		// do lua timer tick
		tick();

    glClear(GL_COLOR_BUFFER_BIT);

		lua_draw();

		draw_text();

    report_fps();

    glfwSwapBuffers();

		// error check
		error_check();

		// exit check
//		exit_check(&run);
		if(!glfwGetWindowParam(GLFW_OPENED))
			quit();
 
    fps_inc_frames_drawn();
  }

  glfwTerminate();
  return 0;
}


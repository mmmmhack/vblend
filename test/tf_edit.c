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

static const char* APP_TITLE = "tf_edit: text display, cursor and scrolling";
static lua_State *L = NULL;
static const char* LUA_FILE = "lua/tf_edit.lua";

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

static const struct luaL_Reg _tflua_lib [] = {
	{"set_cursor", l_edit_set_cursor},
	{"get_cursor", l_edit_get_cursor},
	{"get_time", l_sys_double_time},
	{"num_screen_rows", l_tfont_num_rows},
	{"num_screen_cols", l_tfont_num_cols},
	{"set_screen_buf", l_tfont_set_text_buf},
	{NULL, NULL}
};

static void init_lua() {
	L = luaL_newstate(); /* opens Lua */ 
	luaL_openlibs(L); /* opens the standard libraries */ 

	// reg tfedit lua lib
	luaL_register(L, "tflua", _tflua_lib);

	// load lua keydown func
	int rc = luaL_dofile(L, LUA_FILE);
	if(rc) {
		const char* err = lua_tostring(L, -1);
		fprintf(stderr, "failed loading lua file %s: %s\n", LUA_FILE, err);
		sys_err("init_lua failed");
	}
}

static void tick() {
	lua_getglobal(L, "tick");
	int rc = lua_pcall(L, 0, 0, 0);
	if(rc) {
		const char* err = lua_tostring(L, -1);
		fprintf(stderr, "failed calling lua tick handler: %s\n", err);
		sys_err("tick()");
	}
}

void draw_text() {
	tfont_draw_text_buf();
	edit_draw_cursor();
}

void cb_glfw_key(int key, int state) {
//	printf("key: %d, state: %d\n", key, state);

	// give it to lua
	lua_getglobal(L, "key_event");
	lua_pushnumber(L, key);
	lua_pushnumber(L, state);
	int rc = lua_pcall(L, 2, 0, 0);
	if(rc) {
		const char* err = lua_tostring(L, -1);
		fprintf(stderr, "failed calling lua keydown handler: %s\n", err);
		sys_err("cb_glfw_key");
	}
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
	int run = 1;
  while(run) {
		// do lua timer tick
		tick();

    glClear(GL_COLOR_BUFFER_BIT);

		draw_text();

    report_fps();

    glfwSwapBuffers();

		// error check
		error_check();

		// exit check
		exit_check(&run);
 
    fps_inc_frames_drawn();
  }

  glfwTerminate();
  return 0;
}


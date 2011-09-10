// win.c	:	window routines
#include <errno.h>

#include "GL/glfw.h"

#include "sys.h"
#include "win.h"

static int _nc_height = 12; // non-client area height of window
static int _win_width = 640;
static int _win_height = 480;

int win_set_width(int width) {
	_win_width = width;
	return 0;
}
int win_set_height(int height) {
	_win_height = height;
	return 0;
}

int win_width() {return _win_width;}
int win_height() {return _win_height;}
int win_title_height(){return _nc_height;}

int win_new() {
  int rc;
  rc = glfwInit();
  if(!rc)
    sys_err("glfwInit() failed");

  int w = win_width();
  int h = win_height();
  int r = 0;
  int g = 0;
  int b = 0;
  int a = 0;
  int d = 0;
  int s = 0;
  rc = glfwOpenWindow(w, h, r, g, b, a, d, s, GLFW_WINDOW);
  if(!rc) {
    int errn = errno;
    glfwTerminate();
    sys_errno(errn, "glfwOpenWindow() failed");
  }

	return 0;
}


// tf8036_common.c	:	 common code for the tf8036 tests
#include <string.h>
#include <stdio.h>

#include "GL/glfw.h"

#include "util/sys.h"
#include "util/str.h"
#include "util/fps.h"
#include "util/win.h"

#include "tf8036_common.h"

#define MAX_WIN_TITLE 256

static const int WIN_WIDTH = 800;
static const int WIN_HEIGHT = 600;
static const GLfloat BG_COLOR[] = {0.1f, 0.1f, 0.1f, 1.0f};
static char _win_title[MAX_WIN_TITLE] = "";
static const int _fps_len = 16;
static int _report_console_fps = 0;

void init(const char* title) {
  win_set_width(WIN_WIDTH);
  win_set_height(WIN_HEIGHT);
  win_new();
	sstrncpy(_win_title, title, sizeof(_win_title) - _fps_len);
  glfwSetWindowTitle(_win_title);
  glClearColor(BG_COLOR[0], BG_COLOR[1], BG_COLOR[2], BG_COLOR[3]);
  set_projection();
}

void set_projection() {
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  int l = 0;
  int r = win_width();
  int b = 0;
  int t = win_height();
  gluOrtho2D(l, r, b, t);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
}

void report_fps() {
  static float _prev_report_time = -1;
  float now = sys_float_time();
  if(_prev_report_time == -1) 
    _prev_report_time = now;
  if(now - _prev_report_time < 1)
    return;
  _prev_report_time = now;
  
  int fps = fps_calc();
	if(_report_console_fps) 
  	printf("fps: % 3d\n", fps);
	else {
		char title[MAX_WIN_TITLE];
		snprintf(title, sizeof(title), "%s [fps: %d]", _win_title, fps);
  	glfwSetWindowTitle(title);
	}
}

const char* test_line(int line_num) {
	static char ln[81];
	ln[80] = '\0';
	sprintf(ln, "%02d ", line_num);
	int i;
	for(i = 3; i < 80; ++i) {
		char digit[2];		
		sprintf(digit, "%d", i % 10);
		strcat(ln, digit);
	}
	return ln;
}

void error_check() {
	GLenum err;
	while((err = glGetError()) != GL_NO_ERROR) {
		const GLubyte* err_msg = gluErrorString(err);
		fprintf(stderr, "GL Error: %s\n", err_msg);
	}
}

void exit_check(int* run_ret) {
	if(!glfwGetWindowParam(GLFW_OPENED))
		*run_ret = 0;
	int ch = glfwGetKey(GLFW_KEY_ESC);
	if(ch == GLFW_PRESS)
		*run_ret = 0;
} 



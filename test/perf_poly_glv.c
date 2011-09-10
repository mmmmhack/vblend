// perf_poly_glv.c : draws N untextured polys each frame using glVertex

#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

#include "GL/glfw.h"

#include "util/sys.h"
#include "util/fps.h"
#include "util/win.h"
#include "font/font.h"

static const char* APP_TITLE = "perf test: font polys using glVertex";
static const int WIN_WIDTH = 840;
static const int WIN_HEIGHT = 600;

static const int UNIT_RECT_WIDTH = 10;
static const int UNIT_RECT_HEIGHT = 16;

static const int NUM_POLY_COLS = 80;
static const int NUM_POLY_ROWS = 25;

static const int BORDER = 20;

static const GLfloat BG_COLOR[] = {0.3f, 0.3f, 0.3f, 1.0f};
static const GLfloat POLY_COLOR[] = {1.0f, 1.0f, 1.0f, 1.0f};
static int _num_polys_drawn = 0;

static void draw_polys() {
  glColor3f(POLY_COLOR[0], POLY_COLOR[1], POLY_COLOR[2]);

  int x0, x1, x2, x3;
  int y0, y1, y2, y3;
  int i, j;
  int num_rows = NUM_POLY_ROWS;
  int num_cols = NUM_POLY_COLS;
  int pw = UNIT_RECT_WIDTH - 1;
  int ph = UNIT_RECT_HEIGHT - 1;
  
  glBegin(GL_TRIANGLES);
  y0 = y1 = BORDER;
  y2 = y3 = BORDER + ph;
  for(i = 0; i < num_rows; ++i) {
    x2 = x0 = BORDER;
    x1 = x3 = BORDER + pw;
    for(j = 0; j < num_cols; ++j) {
      glVertex2d(x0, y0);
      glVertex2d(x1, y1);
      glVertex2d(x2, y2);

      glVertex2d(x1, y1);
      glVertex2d(x3, y3);
      glVertex2d(x2, y2);

      ++_num_polys_drawn;

      x0 += UNIT_RECT_WIDTH;
      x1 += UNIT_RECT_WIDTH;
      x2 += UNIT_RECT_WIDTH;
      x3 += UNIT_RECT_WIDTH;
    }
    y0 += UNIT_RECT_HEIGHT;
    y1 += UNIT_RECT_HEIGHT;
    y2 += UNIT_RECT_HEIGHT;
    y3 += UNIT_RECT_HEIGHT;
  }
  glEnd();
}

static void set_projection() {
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

static void report_fps() {
  static float _prev_report_time = -1;
  float now = sys_float_time();
  if(_prev_report_time == -1) 
    _prev_report_time = now;
  if(now - _prev_report_time < 1)
    return;
  _prev_report_time = now;
  
  int fps = fps_calc();
  int pps = _num_polys_drawn; 
  printf("fps: % 3d, pps: % 6d\n", fps, pps);

  _num_polys_drawn = 0;
}

int main(int argc, char* argv[]) {
  win_set_width(WIN_WIDTH);
  win_set_height(WIN_HEIGHT);
  win_new();
  glfwSetWindowTitle(APP_TITLE);
  glClearColor(BG_COLOR[0], BG_COLOR[1], BG_COLOR[2], BG_COLOR[3]);

  // main loop
  while(1) {
    glClear(GL_COLOR_BUFFER_BIT);

    set_projection();

    draw_polys();

    report_fps();

    glfwSwapBuffers();

    fps_inc_frames_drawn();

    if(!glfwGetWindowParam(GLFW_OPENED))
      break;
  }

  glfwTerminate();
  return 0;
}


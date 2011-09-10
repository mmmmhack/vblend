// render_font_set.c : draws a complete font set for saving to an image

#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

#include "GL/glfw.h"

#include "util/sys.h"
#include "util/fps.h"
#include "util/win.h"
#include "font/font.h"

/*
  font set is 10x16, 256 chars, so 16x10 = 160 px wide, 16x16 = 256 px high
*/

static const char* APP_TITLE = "render_font_set.c : draws a complete font set for saving to an image";
static const int WIN_WIDTH = 256;
static const int WIN_HEIGHT = 256;
static const GLfloat BG_COLOR[] = {0.3f, 0.3f, 0.3f, 1.0f};
static const GLfloat FONT_COLOR[] = {0.0f, 0.0f, 0.0f, 1.0f};
static const GLfloat POLY_COLOR[] = {1.0f, 1.0f, 1.0f, 1.0f};

//static const int BORDER = 20;
static const int UNIT_RECT_WIDTH = 10;
static const int UNIT_RECT_HEIGHT = 16;

static const int NUM_FONT_COLS = 16;
static const int NUM_FONT_ROWS = 16;

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

static void draw_font_set() {

  int x0, x1, x2, x3;
  int y0, y1, y2, y3;
  int i, j, k;
  int num_rows = NUM_FONT_ROWS;
  int num_cols = NUM_FONT_COLS;
  int pw = UNIT_RECT_WIDTH - 1;
  int ph = UNIT_RECT_HEIGHT - 1;
  
  // draw back polys
  glBegin(GL_TRIANGLES);
  y0 = y1 = win_height() - UNIT_RECT_HEIGHT;
  y2 = y3 = win_height() - UNIT_RECT_HEIGHT + ph;
  k = 0;
  for(i = 0; i < num_rows; ++i) {
    x2 = x0 = 0;
    x1 = x3 = pw;
    for(j = 0; j < num_cols; ++j) {

      glColor3f(POLY_COLOR[0], POLY_COLOR[1], POLY_COLOR[2]);
      glVertex2d(x0, y0);
      glVertex2d(x1, y1);
      glVertex2d(x2, y2);

      glVertex2d(x1, y1);
      glVertex2d(x3, y3);
      glVertex2d(x2, y2);

      x0 += UNIT_RECT_WIDTH;
      x1 += UNIT_RECT_WIDTH;
      x2 += UNIT_RECT_WIDTH;
      x3 += UNIT_RECT_WIDTH;
    }
    y0 -= UNIT_RECT_HEIGHT;
    y1 -= UNIT_RECT_HEIGHT;
    y2 -= UNIT_RECT_HEIGHT;
    y3 -= UNIT_RECT_HEIGHT;
  }
  glEnd();

  // draw font chars
  y0 = y1 = win_height() - UNIT_RECT_HEIGHT;
  y2 = y3 = win_height() - UNIT_RECT_HEIGHT + ph;
  k = 0;
  for(i = 0; i < num_rows; ++i) {
    x2 = x0 = 0;
    x1 = x3 = pw;
    for(j = 0; j < num_cols; ++j) {

      font_set_color(FONT_COLOR[0], FONT_COLOR[1], FONT_COLOR[2], FONT_COLOR[3]);
      char s[2] = "\0\0";
      s[0] = k++;

      // for some reason, font_draw currently crashes drawing chars >= 128
      if(k==128) {
        goto outtahere;
      }  

      font_draw(x0, y0, s);

      x0 += UNIT_RECT_WIDTH;
      x1 += UNIT_RECT_WIDTH;
      x2 += UNIT_RECT_WIDTH;
      x3 += UNIT_RECT_WIDTH;
    }
    y0 -= UNIT_RECT_HEIGHT;
    y1 -= UNIT_RECT_HEIGHT;
    y2 -= UNIT_RECT_HEIGHT;
    y3 -= UNIT_RECT_HEIGHT;
  }
outtahere:
return;

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
  printf("fps: % 3d\n", fps);
}

int main(int argc, char* argv[]) {
  win_set_width(WIN_WIDTH);
  win_set_height(WIN_HEIGHT);
  win_new();
  glfwSetWindowTitle(APP_TITLE);
  glClearColor(BG_COLOR[0], BG_COLOR[1], BG_COLOR[2], BG_COLOR[3]);
  font_set_color(FONT_COLOR[0], FONT_COLOR[1], FONT_COLOR[2], FONT_COLOR[3]);

  // main loop
  while(1) {
    glClear(GL_COLOR_BUFFER_BIT);
    
    set_projection();

    draw_font_set();

    report_fps();

    glfwSwapBuffers();
    if(!glfwGetWindowParam(GLFW_OPENED))
      break;

    fps_inc_frames_drawn();
  }

  glfwTerminate();
  return 0;
}


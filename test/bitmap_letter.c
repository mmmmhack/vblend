// bitmap_letter.c : draws a letter using bitmap data defined in memory and glBitmap()

#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

#include "GL/glfw.h"

#include "util/sys.h"
#include "util/fps.h"
#include "util/win.h"
#include "font/font.h"

void draw_poly() {
  int w25 = win_width() / 4; 
  int w50 = win_width() / 2; 
  int w75 = 3 * win_width() / 4; 
  int h25 = win_height() / 4; 
  int h75 = 3 * win_height() / 4; 
  int x0 = w25, y0 = h25,
      x1 = w75, y1 = h25,
      x2 = w50, y2 = h75;
  glColor3f(0, 1, 0);          
  glBegin(GL_TRIANGLES);
    glVertex2d(x0, y0);
    glVertex2d(x1, y1);
    glVertex2d(x2, y2);
  glEnd();
}

void draw_letter() {
  GLubyte rasters[12*2] = {
    0xc0, 0x00,
    0xc0, 0x00,
    0xc0, 0x00,
    0xc0, 0x00,
    0xc0, 0x00,

    0xff, 0x00,
    0xff, 0x00,

    0xc0, 0x00,
    0xc0, 0x00,
    0xc0, 0x00,

    0xff, 0xc0,
    0xff, 0xc0,
  };
  const GLubyte* rasters2 = font9x15_char_bitmap(70);
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  glRasterPos2i(20, 20);
  GLsizei w = 9;
  GLsizei h = 15;
  GLfloat x0 = 0.0;
  GLfloat y0 = 0.0;
  GLfloat xm = 10.0;
  GLfloat ym = 0.0;
  glBitmap(w, h, x0, y0, xm, ym, rasters2);
  glBitmap(w, h, x0, y0, xm, ym, rasters2);
  glBitmap(w, h, x0, y0, xm, ym, rasters2);
}

int main(int argc, char* argv[]) {
  win_new();

  glfwSetWindowTitle("bitmap_letter");
  font_set_color(1, 1, 1, 0);

  // main loop
  glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
  while(1) {
    glClear(GL_COLOR_BUFFER_BIT);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    int l = 0;
    int r = win_width();
    int b = 0;
    int t = win_height();
    gluOrtho2D(l, r, b, t);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    // draw test poly
    draw_poly();

    // draw bitmap letter
    draw_letter();

    font_draw(100, 100, "bitchin camaro!");

    glfwSwapBuffers();
    if(!glfwGetWindowParam(GLFW_OPENED))
      break;

    fps_inc_frames_drawn();
  }

  glfwTerminate();
  return 0;
}


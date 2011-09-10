// font.c : text drawing in opengl (uses simple glBitmap() and glut bitmap font)

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "GL/glfw.h"

#include "../util/win.h"
#include "font.h"

static GLfloat _bitmap_width = 9;
static GLfloat _bitmap_height = 15;
static float _font_color[4] = {0, 0, 0, 0};

static void font_puts(const char* s) {
  GLfloat w = _bitmap_width;
  GLfloat h = _bitmap_height;
  GLfloat xm = w + 1;
  GLfloat ym = 0.0;

  while(*s != '\0') {
    char ch = *s;
    const GLubyte* char_bitmap = font9x15_char_bitmap(ch);
    glBitmap(w, h, 0, 0, xm, ym, char_bitmap);
    s++ ;
  }
}

void font_set_color(float r, float g, float b, float a) {
  _font_color[0] = r;
  _font_color[1] = g;
  _font_color[2] = b;
  _font_color[3] = a;
}

void font_draw(int x, int y, const char* s)
{
  GLint vp[4];
  int w, h;

  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

  // set projection to ortho
  glGetIntegerv(GL_VIEWPORT, vp);
  w = vp[2];
  h = vp[3];
  glMatrixMode(GL_PROJECTION);
  glPushMatrix();
  glLoadIdentity();
  glOrtho(0, w, 0, h, -1, 1);

  // draw text
  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glColor3f(_font_color[0], _font_color[1], _font_color[2]);

  // set raster pos
  glRasterPos2i(x, y);
  font_puts(s);

  glPopMatrix();

  // restore projection
  glMatrixMode(GL_PROJECTION);
  glPopMatrix();
  glMatrixMode(GL_MODELVIEW);

}// font_draw

int font_char_width() {
  return _bitmap_width + 1;
}

int font_line_height() {
  return _bitmap_height + 1;
}

int font_num_rows() {
  int client_height = win_height() - win_title_height();
  int num_rows = client_height / font_line_height();
  return num_rows;
}


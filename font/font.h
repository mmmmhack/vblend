#ifndef cbots_font_h
#define cbots_font_h

#include "GL/glfw.h"

// font-9x15.c
const GLubyte* font9x15_char_bitmap(int nchar);

// font.c
void font_set_color(float r, float g, float b, float a);
void font_draw(int x, int y, const char* s);
int font_line_height();
int font_char_width();
int font_num_rows();

#endif

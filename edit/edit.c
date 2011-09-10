// edit.c	:	editing routines
#include <stdlib.h>

#include "GL/glfw.h"

#include "util/win.h"
#include "font/tfont.h"
#include "edit.h"

static int _cursor_row = 0;
static int _cursor_col = 0;
static float _cursor_color[4] = {0, 0.75, 0, 0.50};

void edit_set_cursor(int row, int col) {
	_cursor_row = row;
	_cursor_col = col;
}

void edit_get_cursor(int* row_ret, int* col_ret) {
	*row_ret = _cursor_row;
	*col_ret = _cursor_col;
}

void edit_draw_cursor() {
	// get char dim
	int w = tfont_char_width();
	int h = tfont_char_height();
	// draw semi-trans poly at current cursor pos
	float x = _cursor_col * w;
	float y = win_height() - _cursor_row * h;
	static float* cc = _cursor_color;

	glColor4f(cc[0], cc[1], cc[2], cc[3]);
	glBegin(GL_QUADS);
		glVertex2i(x, y - h);
		glVertex2i(x + w, y - h);
		glVertex2i(x + w, y);
		glVertex2i(x, y);
	glEnd();
}

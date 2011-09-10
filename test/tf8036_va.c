// tf8036_va.c : tex font drawing, 80 cols, 36 rows - vertex arrays

#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "GL/glfw.h"

#include "util/sys.h"
#include "util/fps.h"
#include "util/win.h"
#include "font/tfont.h"

#include "tf8036_common.h"

static const char* APP_TITLE = "tex font drawing, 80 cols x 36 rows - vertex arrays";
static const int NCOLS = 80;
static const int NROWS = 36;
// TODO: get font values from tfont funcs
static const int _ch_w = 10;
static const int _ch_h = 16;

static float* _verts = NULL;
static float* _tcoords = NULL;
static unsigned int* _tris = NULL;

static int _num_verts = 0;
static int _num_tcoords = 0;
static int _num_tris = 0;

void draw_text() {
	glDrawElements(GL_TRIANGLES, _num_tris * 3, GL_UNSIGNED_INT, _tris);
	if(0) {
		glBegin(GL_TRIANGLES);
		glArrayElement(0);
		glArrayElement(1);
		glArrayElement(2);
		glEnd();
	}
}
/*
	 2+---3+----+----+
		|    |    |    |
	 0+---1+----+----+
		|    |    |    |
		+----+----+----+
*/
static void create_verts() {
	int num_cols = NCOLS;
	int num_rows = NROWS;
	int num_chars = num_cols * num_rows;
	_num_verts = num_chars * 4;
	int num_floats = _num_verts * 2;
	_verts = (float*) malloc(num_floats * sizeof(float));
	int i, j, k;
	k = 0;
	float x;
	float y = win_height() + _ch_h;
	for(i = 0; i < num_rows; ++i) {
		x = 0;
		y -= _ch_h;
		for(j = 0; j < num_cols; ++j) {
			// v0
			_verts[k++] = x;
			_verts[k++] = y - _ch_h;

			// v1
			_verts[k++] = x + _ch_w;
			_verts[k++] = y - _ch_h;

			// v2
			_verts[k++] = x;
			_verts[k++] = y;

			// v3
			_verts[k++] = x + _ch_w;
			_verts[k++] = y;

			x += _ch_w;
		}
	}
}

/*
	  +----+----+----+
		|    |    |    |
	  +----+----+----+
		|    |    |    |
		+----+----+----+
*/
static void create_tcoords() {
	int num_cols = NCOLS;
	int num_rows = NROWS;
	int num_chars = num_cols * num_rows;
	_num_tcoords = num_chars * 4;
	int num_floats = _num_tcoords * 2;
	_tcoords = (float*) malloc(num_floats * sizeof(float));
	int i, j, k;
	k = 0;
	float x;
	float y = win_height() + _ch_h;
	for(i = 0; i < num_rows; ++i) {
		const char* ln = test_line(i);
		x = 0;
		y -= _ch_h;
		for(j = 0; j < num_cols; ++j) {
			unsigned char ch = ln[j];
			tfont_get_tex_idx(ch, _tcoords+k);
			k += 8;
			x += _ch_w;
		}
	}
}

static void create_tris() {
	int num_cols = NCOLS;
	int num_rows = NROWS;
	int num_chars = num_cols * num_rows;
	_num_tris = num_chars * 2;
	int num_ints = _num_tris * 3;
	_tris = (unsigned int*) malloc(num_ints * sizeof(unsigned int));
	int i, j, k;
	int nch = 0;
	k = 0;
	for(i = 0; i < num_rows; ++i) {
		for(j = 0; j < num_cols; ++j) {
			// tri 0
			_tris[k++] = nch*4 + 0;
			_tris[k++] = nch*4 + 1;
			_tris[k++] = nch*4 + 2;
			// tri 1
			_tris[k++] = nch*4 + 1;
			_tris[k++] = nch*4 + 3;
			_tris[k++] = nch*4 + 2;
			++nch;
		}
	}	
}

static void cleanup() {
	tfont_cleanup();
	free(_tris);
	free(_tcoords);
	free(_verts);
}

int main(int argc, char* argv[]) {
  init(APP_TITLE);
	
	create_verts();
	create_tcoords();
	create_tris();
	tfont_init();

	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);

	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, 0, _verts);
	glTexCoordPointer(2, GL_FLOAT, 0, _tcoords);

  // main loop
	int run = 1;
  while(run) {
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
	cleanup();

  return 0;
}


// tfont.c	:	texture font routines

/*
	Currently uses a fixed 9x15 font bitmap for the texture-mapped text.
	
	Also currently defines a fixed 80 col x 36 row text buffer for efficiently drawing a screenful of text
	using glDrawElements().

*/

#include <stdlib.h>

#include "GL/glfw.h"

#include "util/img.h"
#include "util/sys.h"
//#include "util/win.h"
#include "tfont.h"

static int _tfont_init = 0;
static RgbaImage* _img = NULL;
static const char* _image_file = "res/9x15_font.png";

// these are constants common to all chars
static const int _num_cols = 16;
static const int _num_rows = 16;
static const int _bm_w = 10;
static const int _bm_h = 16;
static const float _img_w = 256;
static const float _img_wtf_h = 256;		// img_h appears to be pre-defined ... some weird macro?
static const float _cell_w = 16;	// width of a cell row, in pixels
static const float _cell_h = 16;	// height of a cell row, in pixels

// tex buf constants
static const int NUM_TEXT_BUF_COLS = 80;
static const int NUM_TEXT_BUF_ROWS = 36;

// tex buf vars
static float* _verts = NULL;
static float* _tcoords = NULL;
static unsigned int* _tris = NULL;
static int _num_verts = 0;
static int _num_tcoords = 0;
static int _num_tris = 0;
static GLuint _tex_id = 0;

static int win_height() {
	int viewport[4];
	glGetIntegerv(GL_VIEWPORT, viewport);
	return viewport[3];
}

static int load_image() {
	_img = img_read_png_rgba(_image_file);	
	if(!_img) 
		sys_err("load_image() failed");
//	printf("loaded image %s: w: %lu, h: %lu\n", image_file, _img->width, _img->height);
	return 1;
}

static void init_texture() {

	// create tex id
	glGenTextures(1, &_tex_id);
	if(_tex_id == 0)
		sys_err("glGenTextures() failed");

	// define texture state for this tex object
	glBindTexture(GL_TEXTURE_2D, _tex_id);

	// define texture parameters
/*
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT); 
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT); 
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, 
                   GL_NEAREST); 
*/
	// only this one appears to be mandatory
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, 
                   GL_NEAREST); 

	// create texture
	GLenum target = GL_TEXTURE_2D;
	GLint level = 0;
	GLint internalFormat = GL_RGBA8;
	GLsizei width = _img->width;
	GLsizei height = _img->height;
	GLint border = 0;
	GLenum format = GL_RGBA;
	GLenum type = GL_UNSIGNED_BYTE;
	const GLvoid* pixels = _img->pixels;
	glTexImage2D(
		target,
		level,
		internalFormat,
		width,
		height,
		border,
		format,
		type,
		pixels
	);
	glEnable(GL_TEXTURE_2D);

	// do we need this? I think so
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
}

/*
	 2+---3+----+----+
		|    |    |    |
	 0+---1+----+----+
		|    |    |    |
		+----+----+----+
*/
static void create_verts() {
	int num_cols = NUM_TEXT_BUF_COLS;
	int num_rows = NUM_TEXT_BUF_ROWS;
	int num_chars = num_cols * num_rows;
	_num_verts = num_chars * 4;
	int num_floats = _num_verts * 2;
	int cb_verts = num_floats * sizeof(float);
	_verts = (float*) malloc(cb_verts);
	int i, j, k;
	k = 0;
	float x;
//	float y = NUM_TEXT_BUF_ROWS * _bm_h + _bm_h;
	float y = win_height() + _bm_h;
	for(i = 0; i < num_rows; ++i) {
		x = 0;
		y -= _bm_h;
		for(j = 0; j < num_cols; ++j) {
			// v0
			_verts[k++] = x;
			_verts[k++] = y - _bm_h;

			// v1
			_verts[k++] = x + _bm_w;
			_verts[k++] = y - _bm_h;

			// v2
			_verts[k++] = x;
			_verts[k++] = y;

			// v3
			_verts[k++] = x + _bm_w;
			_verts[k++] = y;

			x += _bm_w;
		}
	}
	if(k != num_floats)
		sys_err("_verts bounds error");
}

/*
	  +----+----+----+
		|    |    |    |
	  +----+----+----+
		|    |    |    |
		+----+----+----+
*/
static void create_tcoords() {
	int num_cols = NUM_TEXT_BUF_COLS;
	int num_rows = NUM_TEXT_BUF_ROWS;
	int num_chars = num_cols * num_rows;
	_num_tcoords = num_chars * 4;
	int num_floats = _num_tcoords * 2;
	int cb_tcoords = num_floats * sizeof(float);
	_tcoords = (float*) malloc(cb_tcoords);
	int i, j, k;
	k = 0;
	float x;
	unsigned char ch = ' ';
//	float y = NUM_TEXT_BUF_ROWS * _bm_h + _bm_h;
	float y = win_height() + _bm_h;
	for(i = 0; i < num_rows; ++i) {
		x = 0;
		y -= _bm_h;
		for(j = 0; j < num_cols; ++j) {
			tfont_get_tex_idx(ch, _tcoords+k);
			k += 8;
			x += _bm_w;
		}
	}
	if(k != num_floats)
		sys_err("_tcoords bounds error");
}

static void create_tris() {
	int num_cols = NUM_TEXT_BUF_COLS;
	int num_rows = NUM_TEXT_BUF_ROWS;
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
	if(k != num_ints)
		sys_err("_tris bounds error");
}

static void init_text_buf() {
	// create verts and tcoords arrays
	create_verts();
	create_tcoords();
	create_tris();

	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

int tfont_init() {
	if(_tfont_init)
		return 1;

	load_image();
	init_texture();
	init_text_buf();

	_tfont_init = 1;
	return 1;
}

void tfont_get_tex_idx(int ichar, float* tex_ret) {
	// cell: (a cell is the 16x16 block that contains the 9x15 pixels of the char)
	// cell index values, from top-left
	int cell_row = ichar / _num_rows;
	int cell_col = ichar % _num_rows;

	// cell dims: distance in pixels from bottom-right of image
	float cell_top = (_num_rows - cell_row) * _cell_h;
	float cell_left = cell_col * _cell_w;
	float cell_bot = cell_top - _bm_h;
	float cell_right = cell_left + _bm_w;

	int i = 0;
	tex_ret[i++] = cell_left / _img_w;  // x0
	tex_ret[i++] = cell_bot / _img_wtf_h;   // y0
	tex_ret[i++] = cell_right / _img_w; // x1
	tex_ret[i++] = cell_bot / _img_wtf_h;   // y1
	tex_ret[i++] = cell_left / _img_w;	// x2
	tex_ret[i++] = cell_top / _img_wtf_h;		// y2
	tex_ret[i++] = cell_right / _img_w; // x3
	tex_ret[i++] = cell_top / _img_wtf_h;		// y3
}

static void draw_char(int font_char) {
	int w = _bm_w;
	int h = _bm_h;
	int b = 0;
  int x0 = b, y0 = b,
      x1 = b+w, y1 = b,
      x2 = b, y2 = b+h,
      x3 = b+w, y3 = b+h;
	float tex[8];
	tfont_get_tex_idx(font_char, tex);

  glBegin(GL_TRIANGLES);
		glTexCoord2f(tex[0], tex[1]);
    glVertex2d(x0, y0);

		glTexCoord2f(tex[2], tex[3]);
    glVertex2d(x1, y1);

		glTexCoord2f(tex[4], tex[5]);
    glVertex2d(x2, y2);

		glTexCoord2f(tex[2], tex[3]);
    glVertex2d(x1, y1);

		glTexCoord2f(tex[4], tex[5]);
    glVertex2d(x2, y2);

		glTexCoord2f(tex[6], tex[7]);
    glVertex2d(x3, y3);
  glEnd();
}

void tfont_draw_string(const char* s) {
	if(!tfont_init())
		sys_err("tfont not initialized");
	while(*s) {
		unsigned char ch = (unsigned char) *s++;
		draw_char(ch);
		glTranslatef(_bm_w, 0, 0);
	}
}

// text buf routines
int tfont_num_rows() {return NUM_TEXT_BUF_ROWS;}
int tfont_num_cols() {return NUM_TEXT_BUF_COLS;}
int tfont_char_width(){return _bm_w;}
int tfont_char_height(){return _bm_h;}

void tfont_set_text_buf(int start_row, int start_col, const char* txt) {
	if(!tfont_init())
		sys_err("tfont not initialized");
	if(start_col < 0 || start_col >= tfont_num_cols())
		sys_err("invalid col");
	if(start_row < 0 || start_row >= tfont_num_rows())
		sys_err("invalid row");
	if(!txt)
		sys_err("NULL string");
	int coords_per_col = 8;
	int coords_per_row = coords_per_col * tfont_num_cols();
	int k = start_row * coords_per_row + start_col * coords_per_col;
	const char* s = txt;
	int col = start_col;
	while(*s) {
		if(col >= tfont_num_cols())
			break;
		unsigned char ch = *s++;
		tfont_get_tex_idx(ch, _tcoords+k);
		k += coords_per_col;
		++col;
	}
}

void tfont_draw_text_buf() {
	if(!tfont_init())
		sys_err("tfont not initialized");
	// TODO: change to push/pop gl attribs as needed

	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, _tex_id);

	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);

	glVertexPointer(2, GL_FLOAT, 0, _verts);
	glTexCoordPointer(2, GL_FLOAT, 0, _tcoords);
	glDrawElements(GL_TRIANGLES, _num_tris * 3, GL_UNSIGNED_INT, _tris);

	glDisable(GL_TEXTURE_2D);
}

void tfont_cleanup() {

	glDeleteTextures(1, &_tex_id);

	if(_img) {
		free(_img->pixels);
		free(_img);
	}
	free(_tris);
	free(_tcoords);
	free(_verts);
}


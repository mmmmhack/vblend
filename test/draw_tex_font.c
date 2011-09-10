// draw_tex_font.c : simple app to draw a font set using texture-mapping

#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

#include "GL/glfw.h"

#include "util/sys.h"
#include "util/fps.h"
#include "util/img.h"
#include "util/win.h"
#include "font/font.h"

static const char* APP_TITLE = "draw_tex_font.c : simple app to draw a font set using texture-mapping";
static const int WIN_WIDTH = 840;
static const int WIN_HEIGHT = 600;
static const GLfloat BG_COLOR[] = {0.3f, 0.3f, 0.3f, 1.0f};
static const GLfloat POLY_COLOR[] = {1.0f, 1.0f, 1.0f, 1.0f};

static const char* image_file = "res/9x15_font.png";
static RgbaImage* _img = NULL;
static GLuint _tex_id = 0;

static void get_tex_idx(int ichar, float* tex_ret) {
	// these are constants common to all chars
	int num_cols = 16;
	int num_rows = 16;
	int bm_w = 9;
	int bm_h = 15;
	float img_w = 256;
	float img_wtf_h = 256;		// img_h appears to be pre-defined ... some weird macro?
	float cell_w = img_w / num_cols;	// width of a cell row, in pixels
	float cell_h = img_wtf_h / num_rows;	// height of a cell row, in pixels

	// cell: (a cell is the 16x16 block that contains the 9x15 pixels of the char)
	// cell index values, from top-left
	int cell_row = ichar / num_rows;
	int cell_col = ichar % num_rows;

	// cell dims: distance in pixels from bottom-right of image
	float cell_top = (num_rows - cell_row) * cell_h;
	float cell_left = cell_col * cell_w;
	float cell_bot = cell_top - bm_h;
	float cell_right = cell_left + bm_w;

	int i = 0;
	tex_ret[i++] = cell_left / img_w;  // x0
	tex_ret[i++] = cell_bot / img_wtf_h;   // y0
	tex_ret[i++] = cell_right / img_w; // x1
	tex_ret[i++] = cell_bot / img_wtf_h;   // y1
	tex_ret[i++] = cell_left / img_w;	// x2
	tex_ret[i++] = cell_top / img_wtf_h;		// y2
	tex_ret[i++] = cell_right / img_w; // x3
	tex_ret[i++] = cell_top / img_wtf_h;		// y3
}

static void draw_poly(int font_char) {
	int w = 9;
	int h = 15;
	int b = 0;
  int x0 = b, y0 = b,
      x1 = b+w, y1 = b,
      x2 = b, y2 = b+h,
      x3 = b+w, y3 = b+h;
	float tex[8];
	get_tex_idx(font_char, tex);

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

void draw_pixels() {
	glRasterPos2i(450, 50);
	glDrawPixels(256, 256, GL_RGBA, GL_UNSIGNED_BYTE, _img->pixels);
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
  printf("fps: % 3d\n", fps);
}

void load_image() {
	_img = img_read_png_rgba(image_file);	
	if(!_img) {
	  char msg[256];
		sprintf(msg, "load_image() failed for file %s", image_file);
		sys_err(msg);
	}
	printf("loaded image %s: w: %lu, h: %lu\n", image_file, _img->width, _img->height);
}

void init_texture() {
/*
	// create tex id
	glGenTextures(1, &_tex_id);
	if(_tex_id == 0)
		sys_err("glGenTextures() failed");
*/
	// define texture parameters
/*
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT); 
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT); 
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, 
                   GL_NEAREST); 
*/
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

	// do we need this?
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
}

void cleanup() {
/*
	glDeleteTextures(1, &_tex_id);
*/
	if(_img) {
		free(_img->pixels);
		free(_img);
	}
}

int main(int argc, char* argv[]) {
  win_set_width(WIN_WIDTH);
  win_set_height(WIN_HEIGHT);
  win_new();
  glfwSetWindowTitle(APP_TITLE);
  glClearColor(BG_COLOR[0], BG_COLOR[1], BG_COLOR[2], BG_COLOR[3]);

	// load image
	load_image();
//glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
	init_texture();
  // main loop
  while(1) {
    glClear(GL_COLOR_BUFFER_BIT);
    set_projection();

		float x = 0;
		float y = 256;
		int i, j, k = 0;
		for(i = 0; i < 16; ++i) {
			x = 0;
			y -= 16;
			for(j = 0; j < 16; ++j) {
				glPushMatrix();
				glTranslatef(x, y, 0);
				draw_poly(k++);
				glPopMatrix();
				x += 16;
			}
		}

    report_fps();

    if(!glfwGetWindowParam(GLFW_OPENED))
      break;
		int ch = glfwGetKey(GLFW_KEY_ESC);
		if(ch == GLFW_PRESS)
			break;

    glfwSwapBuffers();
    fps_inc_frames_drawn();
  }

	cleanup();
  glfwTerminate();
  return 0;
}


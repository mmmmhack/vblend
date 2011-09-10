// font_perf.c : does performance timing of font code

#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

#include "GL/glfw.h"

#include "util/sys.h"
#include "util/fps.h"
#include "util/win.h"
#include "util/perf.h"
//#include "font/font.h"

void draw_letter() {
  perf_mark_beg("raster_def");
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
  perf_mark_end("raster_def");

//  const GLubyte* rasters2 = font9x15_char_bitmap(70);
  perf_mark_beg("pix_store");
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  perf_mark_end("pix_store");

  perf_mark_beg("raster_pos");
	glRasterPos2i(20, 20);
  perf_mark_end("raster_pos");

  GLsizei w = 10;
  GLsizei h = 12;
  GLfloat x0 = 0.0;
  GLfloat y0 = 0.0;
  GLfloat xm = 11.0;
  GLfloat ym = 0.0;

  perf_mark_beg("glBitmap");
  glBitmap(w, h, x0, y0, xm, ym, rasters);
  perf_mark_end("glBitmap");

//  glBitmap(w, h, x0, y0, xm, ym, rasters);
//  glBitmap(w, h, x0, y0, xm, ym, rasters2);
//  glBitmap(w, h, x0, y0, xm, ym, rasters2);
}

int main(int argc, char* argv[]) {
  win_new();

  glfwSetWindowTitle("font_perf");
//  font_set_color(1, 1, 1, 0);

	perf_init();

  // main loop
  glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
  while(1) {
		perf_mark_beg("glClear");
    glClear(GL_COLOR_BUFFER_BIT);
		perf_mark_end("glClear");

		perf_mark_beg("ortho");
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    int l = 0;
    int r = win_width();
    int b = 0;
    int t = win_height();
    gluOrtho2D(l, r, b, t);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
		perf_mark_end("ortho");


     // draw bitmap letter
//		perf_mark_beg("draw_letter");
//		int i;
//		for(i = 0; i < 50; ++i) {
    	draw_letter();
//		}
//		perf_mark_end("draw_letter");

//    font_draw(100, 100, "bitchin camaro!");

		perf_mark_beg("swap");
    glfwSwapBuffers();
		perf_mark_end("swap");
    if(!glfwGetWindowParam(GLFW_OPENED))
      break;

//    fps_inc_frames_drawn();
	  perf_report();
  }

	perf_terminate();
  glfwTerminate();
  return 0;
}


// tf8036_bl.c : tex font drawing, 80 cols, 36 rows - baseline implementation
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

static const char* APP_TITLE = "tex font drawing, 80 cols, 36 rows - baseline implementation";

void draw_text() {
	int ch_rows = 36;
	int ch_h = 16;
	float x = 0;
	float y = win_height();
	int i;
	for(i = 0; i < ch_rows; ++i) {
		x = 0;
		y -= ch_h;
		glPushMatrix();
		glTranslatef(x, y, 0);
		const char* ln = test_line(i);
		tfont_draw_string(ln);
		glPopMatrix();
	}
}

int main(int argc, char* argv[]) {
	init(APP_TITLE);

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
  return 0;
}


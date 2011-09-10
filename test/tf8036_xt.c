// tf8036_xt.c : tex font drawing, 80 cols, 36 rows - external texture (via tfont module)
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

static const char* APP_TITLE = "tf8036xt: tex font drawing, 80 cols, 36 rows - external texture (via tfont module)";

void set_text() {
	int col = 0;
	int num_rows = tfont_num_rows();
	int row;
	for(row = 0; row < num_rows; ++row) {
		const char* ln = test_line(row);
		tfont_set_text_buf(row, col, ln);
	}
}

int main(int argc, char* argv[]) {
	init(APP_TITLE);

	set_text();

  // main loop
	int run = 1;
  while(run) {
    glClear(GL_COLOR_BUFFER_BIT);

		tfont_draw_text_buf();

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


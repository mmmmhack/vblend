// font_lines.c : draws a bunch of lines of text for font performance testing

#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

#include "GL/glfw.h"

#include "util/sys.h"
#include "util/fps.h"
#include "util/win.h"
#include "font/font.h"

int main(int argc, char* argv[]) {
  win_new();

  glfwSetWindowTitle("font lines test");

  font_set_color(1, 1, 1, 0);

  int num_rows = font_num_rows();
  printf("num_rows: %d\n", num_rows);

  // main loop
  glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
  while(1) {
    glClear(GL_COLOR_BUFFER_BIT);

    int b = 10;
    int x = b;
    int y = win_height() - b - win_title_height();
    char txt[256];
    int fps = fps_calc();
    sprintf(txt, "fps: % 3d", fps);

    font_draw(x, y, txt);
    int i;
    for(i = 0; i < num_rows; ++i) {
      y -= font_line_height();
      sprintf(txt, "line %02d", i);
      font_draw(x, y, txt);
    }

    glfwSwapBuffers();
    if(!glfwGetWindowParam(GLFW_OPENED))
      break;

    fps_inc_frames_drawn();
  }

  glfwTerminate();
  return 0;
}


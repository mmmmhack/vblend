// font_map.c : draws full ascii char set

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

  // main loop
  glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
  while(1) {
    glClear(GL_COLOR_BUFFER_BIT);

    int b = 10;
    int x = b;
    int y = win_height() - b - win_title_height();
    char txt[256];
    txt[1] = 0;
//    int fps = fps_calc();
//    sprintf(txt, "fps: % 3d", fps);
//    font_draw(x, y, txt);
    int num_rows = 16;
    int num_cols = 16;
    int i, j;
    int k = 0;
    for(i = 0; i < num_rows; ++i) {
      x = b;
      for(j = 0; j < num_cols; ++j) {
        txt[0] = k++;
        font_draw(x, y, txt);
        x += font_char_width();
      }
      y -= font_line_height();
    }

    glfwSwapBuffers();
    if(!glfwGetWindowParam(GLFW_OPENED))
      break;

    fps_inc_frames_drawn();
  }

  glfwTerminate();
  return 0;
}


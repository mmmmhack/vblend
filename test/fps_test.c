#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "GL/glfw.h"

#include "font/font.h"
#include "util/sys.h"
#include "util/fps.h"
#include "util/win.h"

int main(int argc, char* argv[]) {
  win_new();
  glfwSetWindowTitle("fps test");
  font_set_color(1, 1, 1, 0);

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

    glfwSwapBuffers();
    if(!glfwGetWindowParam(GLFW_OPENED))
      break;

    fps_inc_frames_drawn();
  }

  glfwTerminate();
  return 0;
}


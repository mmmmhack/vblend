#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "GL/glfw.h"

#include "util/sys.h"
#include "font/font.h"

int main(int argc, char* argv[]) {
  int rc;
  rc = glfwInit();
  if(!rc)
    sys_err("glfwInit() failed");

  int w = 640;
  int h = 480;
  int r = 0;
  int g = 0;
  int b = 0;
  int a = 0;
  int d = 0;
  int s = 0;
  rc = glfwOpenWindow(w, h, r, g, b, a, d, s, GLFW_WINDOW);
  if(!rc) {
    int errn = errno;
    glfwTerminate();
    sys_errno(errn, "glfwOpenWindow() failed");
  }

  font_set_color(1, 1, 1, 0);

  glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
  while(1) {
    glClear(GL_COLOR_BUFFER_BIT);

    int x = 50;
    int y = 50;
    const char* txt = "howdy";
    font_draw(x, y, txt);

    glfwSwapBuffers();
    if(!glfwGetWindowParam(GLFW_OPENED))
      break;
  }

  glfwTerminate();
  return 0;
}


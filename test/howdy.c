#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "GL/glfw.h"

void sys_err(const char* msg) {
  perror(msg);
  exit(1);
}

void sys_errno(int errn, const char* msg) {
  errno = errn;
  perror(msg);
  exit(1);
}

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

  glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
  while(1) {
    glClear(GL_COLOR_BUFFER_BIT);

    glfwSwapBuffers();
    if(!glfwGetWindowParam(GLFW_OPENED))
      break;
  }

  glfwTerminate();
  return 0;
}


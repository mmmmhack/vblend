#include <stdio.h>
#include <stdlib.h>
#include "GL/glfw.h"

int main(int argc, char* argv[]) {
  int rc;

  rc = glfwInit();
  if( rc != GL_TRUE ) {
    fprintf(stderr, "glfwInit() failed\n");
    exit(1);
  }
  
  int w = 640;
  int h = 480;
  int r = 0;
  int g = 0;
  int b = 0;
  int a = 0;
  int d = 0;
  int s = 0;
  int m = GLFW_WINDOW;

  rc = glfwOpenWindow( w, h, r, g, b, a, d, s, m);
  if( rc != GL_TRUE ) {
    fprintf(stderr, "glfwOpenWindow() failed\n");
    exit(1);
  }
  glfwTerminate();
  return 0;
}

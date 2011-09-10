// cl_fps.c : null app with just command-line output of frames-per-second

#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

#include "GL/glfw.h"

#include "util/sys.h"
#include "util/fps.h"
#include "util/perf.h"
#include "util/win.h"
#include "font/font.h"

int main(int argc, char* argv[]) {
  win_new();

  glfwSetWindowTitle("cl_fps");

  // init one-time render
  glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT);
  glfwSwapBuffers();

  perf_init();

  float prev_fps_output_time = -1;

  // main loop
  float beg_time = sys_float_time();
  int prev_fps = -1;
  int run = 1;
  while(run) {
    // glClear timestamp
    if(1) {
      perf_mark_beg("glClear");
      glClear(GL_COLOR_BUFFER_BIT);
      perf_mark_end("glClear");
    }
/*
    perf_mark_beg("empty1");
    perf_mark_end("empty1");

    perf_mark_beg("empty2");
    perf_mark_end("empty2");

    perf_mark_beg("empty3");
    perf_mark_end("empty3");
*/

    // fps calc
    char txt[256] = "";
    if(1) {
      perf_mark_beg("fps_calc");
      int fps = fps_calc();
      fps_inc_frames_drawn();
      sprintf(txt, "fps: % 3d", fps);
      perf_mark_end("fps_calc");
    }

    // font draw
    if(1) {
      perf_mark_beg("font_draw");
      int b = 10;
      int x = b;
      int y = win_height() - b - win_title_height();
      font_draw(x, y, txt);
      perf_mark_end("font_draw");
    }

    // buffer-swap timestamp
    if(1) {
      perf_mark_beg("glfwSwapBuffers");
      glfwSwapBuffers();
      perf_mark_end("glfwSwapBuffers");
    }
/*
    perf_mark_beg("empty4");
    perf_mark_end("empty4");
    perf_mark_beg("empty5");
    perf_mark_end("empty5");
*/

    // fps timestamp
    if(0) {
      perf_mark_beg("fps_calc");
      float cur_time = sys_float_time();
      int fps = fps_calc();
      float app_time = cur_time - beg_time;
      size_t num_frames = fps_num_frames_drawn();
      if(prev_fps_output_time < 1)
        prev_fps_output_time = cur_time;
      float delta_time = cur_time - prev_fps_output_time;
      if(delta_time >= 1.0) {
        printf("%12.6f secs: frame: %06lu, fps: % 4d\n", app_time, num_frames, fps);
        prev_fps_output_time = cur_time;
      }
      fps_inc_frames_drawn();
      prev_fps = fps;
      perf_mark_end("fps_calc");
    }

    // check key input for exit
    if(1) {
      perf_mark_beg("glfwGetKey");
      int key = glfwGetKey(GLFW_KEY_ESC);
      perf_mark_end("glfwGetKey");
      if(key == GLFW_PRESS)
        run = 0;
    }
    
    // report at bottom-of-loop
    perf_report();
  }

  perf_terminate();
  glfwTerminate();
  return 0;
}


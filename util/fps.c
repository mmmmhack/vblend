// fps.c
#include <stdlib.h>

#include "sys.h"
#include "fps.h"

static size_t _num_frames_drawn = 0;
static size_t _prev_fps_frame = 0;
static float _prev_fps_time = 0;
static size_t _fps_frame_interval = 60;

static int _fps = -1;

int fps_calc() {
  double cur_time = sys_float_time();
  if(_num_frames_drawn == 0) {
    _prev_fps_frame = 0;
    _prev_fps_time = sys_float_time();
    return _fps;
  }
  size_t delta_frames = _num_frames_drawn - _prev_fps_frame;
  if(delta_frames < _fps_frame_interval)
    return _fps;
  float delta_time = cur_time - _prev_fps_time;
  if(delta_time <= 0)
    return _fps;

  // calc new fps
  _prev_fps_time = cur_time;
  _prev_fps_frame = _num_frames_drawn;
  _fps = (int) (((float)delta_frames) / delta_time);
  return _fps;
}

void fps_inc_frames_drawn() {
  ++_num_frames_drawn;
}

size_t fps_num_frames_drawn() {
  return _num_frames_drawn;
}


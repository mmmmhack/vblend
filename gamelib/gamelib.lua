-- gamelib.lua  :  provides high-level functions for games using gl and glfw libs
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

require('gl')
require('lua_glfw')
_G['glfw'] = _G['lua_glfw'] -- rename to more convenient prefix, the shared lib was made as 'lua_glfw' to avoid conflict 
                            -- with the C glfw lib
require('sys')

-- game window defaults
M.win_title = "Game"
M.win_width = 800
M.win_height = 600
M.win_open = false
M.win_bg_color = {[0]=0.2, [1]=0.2, [2]=0.2, [3]=0}

-- fps
M._num_frames_drawn = 0;
M._prev_fps_frame = 0;
M._prev_fps_time = 0;
M._fps_frame_interval = 60;
M._fps = -1;

-- functions

-- opens a new window for a gamelib ap
-- defaults:
--  * 800x600 window size
--  * ortho projection
--  * color depth: ?
M.open_window = function()
	local rc = lua_glfw.init()
  if rc ~= gl.GL_TRUE then
    error(string.format("lua_glfw.init() failed, rc: %d", rc))
  end

	local w = M.win_width
	local h = M.win_height
	local r = 0
	local g = 0
	local b = 0
	local a = 0
	local d = 0
	local s = 0
	local mode = lua_glfw.GLFW_WINDOW
	rc = lua_glfw.openWindow(
		w, h, r, g, b, a, d, s, mode
	)
  if rc ~= gl.GL_TRUE then
    error(string.format("lua_glfw.openWindow() failed, rc: %d", rc))
  end
  M.win_open = true

  -- set default ortho project
	gl.matrixMode(gl.GL_PROJECTION)
	gl.loadIdentity()
	gl.ortho(0, w, 0, h, -1, 1)
	gl.matrixMode(gl.GL_MODELVIEW)
	gl.loadIdentity()

  local cc = M.win_bg_color
  gl.clearColor(cc[0], cc[1], cc[2], cc[3])
end

M.draw_rect = function (x, y, w, h)
  gl.Begin(gl.GL_QUADS)
    gl.vertex2f(x, y)
    gl.vertex2f(x + w, y)
    gl.vertex2f(x + w, y + h)
    gl.vertex2f(x, y + h)
  gl.End()
end

M.calc_fps = function ()
  if M._num_frames_drawn == 0 then
    M._prev_fps_frame = 0
    M._prev_fps_time = sys.double_time()
    return M._fps;
  end
  local delta_frames = M._num_frames_drawn - M._prev_fps_frame
  if delta_frames < M._fps_frame_interval then
    return M._fps
  end
  local cur_time = sys.double_time()
  local delta_time = cur_time - M._prev_fps_time
  if delta_time <= 0 then
    return M._fps
  end

  -- calc new fps
  M._prev_fps_time = cur_time;
  M._prev_fps_frame = M._num_frames_drawn;
  M._fps = math.floor(delta_frames / delta_time)
  return M._fps;
end

-- Performs internal gamelib updates, should be called at the end of every game loop.
-- Specifically, the following is done:
--  * updates the screen with the opengl graphics buffer
--  * updates glfw input buffers (keyboard and mouse)
--  * clears the opengl graphics buffer
--  * calculates fps
M.update = function ()
	lua_glfw.swapBuffers()
  M.win_open = lua_glfw.getWindowParam(lua_glfw.GLFW_OPENED)
  gl.clear(gl.GL_COLOR_BUFFER_BIT)

  -- calc fps and update window title
  M._num_frames_drawn = M._num_frames_drawn + 1
  local fps = M.calc_fps()
  local title = string.format("%s - fps: %3d", M.win_title, fps)
  lua_glfw.setWindowTitle(title)
end

M.window_closed = function()
  return M.win_open ~= gl.GL_TRUE
end


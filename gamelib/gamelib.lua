-- gamelib.lua  :  provides high-level functions for games using gl and glfw libs
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

require('strict')
require('lua_gl')
require('lua_glu')
require('lua_glfw')
require('lua_sys')

M.NUM_CIRCLE_SLICES = 32

-- game window defaults
M.win_defaults = {
  title = "Game",
  width = 800,
  height = 600,
  bg_color = {[0]=0.2, [1]=0.2, [2]=0.2, [3]=0},
}

-- game window properties
M.win_open = false

-- fps
M._num_frames_drawn = 0;
M._prev_fps_frame = 0;
M._prev_fps_time = 0;
M._fps_frame_interval = 60;
M._fps = -1;

-- functions

--[[
	descrip:
		Calculates and returns frame rate.
]]
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

--[[
	descrip:
		Draws a filled circle at param position with param radius.
	
	params:
		x0:	type: number, descrip: x coord of circle center
		y0:	type: number, descrip: y coord of circle center
		radius: type: number, descrip: radius of circle

	notes:
		The circle orientation is facing the +z direction

]]
M.draw_circle = function (x0, y0, radius)
  gl.Begin(gl.GL_TRIANGLE_FAN)
    gl.vertex2f(x0, y0)
		local nslices = M.NUM_CIRCLE_SLICES
		local theta = 0
		local delta_theta = 2*math.pi / nslices
		local i
		for i = 0, nslices do
			local x = x0 + radius * math.cos(theta)
			local y = y0 + radius * math.sin(theta)
			theta = theta + delta_theta
			gl.vertex2f(x, y)
		end
  gl.End()
end

--[[
	descrip:
		Draws a wireframe circle outline at param position with param radius.
	
	params:
		x0:	type: number, descrip: x coord of circle center
		y0:	type: number, descrip: y coord of circle center
		radius: type: number, descrip: radius of circle

	notes:
		The circle orientation is facing the +z direction

]]
M.draw_circle_wireframe = function (x0, y0, radius)
  gl.Begin(gl.GL_LINE_LOOP)
--    gl.vertex2f(x0, y0)
		local nslices = M.NUM_CIRCLE_SLICES
		local theta = 0
		local delta_theta = 2*math.pi / nslices
		local i
		for i = 0, nslices do
			local x = x0 + radius * math.cos(theta)
			local y = y0 + radius * math.sin(theta)
			theta = theta + delta_theta
			gl.vertex2f(x, y)
		end
  gl.End()
end


--[[
	descrip:
		Draws a filled rectangle at param position and size.
]]
M.draw_rect = function (x, y, w, h)
  gl.Begin(gl.GL_QUADS)
    gl.vertex2f(x, y)
    gl.vertex2f(x + w, y)
    gl.vertex2f(x + w, y + h)
    gl.vertex2f(x, y + h)
  gl.End()
end

--[[
	descrip:
		Helper function to run main loop at constant frame rate, used with frame_start().
]]
M.frame_end = function()
	-- sleep
	local end_time = sys.double_time()
	local work_time = end_time - M.frame_beg_time
	local sleep_time = M.frame_period - work_time
	sleep_time = math.max(0, sleep_time)
	sys.usleep(sleep_time * 1e6)
end

--[[
	descrip:
		Helper function to run main loop at constant frame rate, used with frame_end().
	
	params:
		[fps]: type: number, descrip: frames per second (default = 60)
]]
M.frame_start = function(fps)
	fps = fps or 60
	M.frame_period = 1/60
	M.frame_beg_time = sys.double_time()
end

--[[
	descrip:
		Opens a new window for a gamelib application.
			defaults:
			. 800x600 window size
			. ortho projection
			. color depth: 16
]]
M.open_window = function(title)
	local rc = glfw.init()
  if rc ~= gl.GL_TRUE then
    error(string.format("glfw.init() failed, rc: %d", rc))
  end

	local w = M.win_defaults.width
	local h = M.win_defaults.height
	local r = 0
	local g = 0
	local b = 0
	local a = 0
	local d = 16 
	local s = 0
	local mode = glfw.GLFW_WINDOW
	rc = glfw.openWindow(
		w, h, r, g, b, a, d, s, mode
	)
  if rc ~= gl.GL_TRUE then
    error(string.format("glfw.openWindow() failed, rc: %d", rc))
  end
  M.win_open = gl.GL_TRUE

  if title ~= nil then
	M.win_defaults.title = title
  end

  -- set default ortho projection
	M.set_ortho()
	gl.loadIdentity()

  local cc = M.win_defaults.bg_color
  gl.clearColor(cc[0], cc[1], cc[2], cc[3])
end

--[[
	descrip:
		Sets orthographic projection in OpenGL projection matrix, 
		leaving matrix mode in GL_MODELVIEW.
]]
M.set_ortho = function ()
	local w = gamelib.win_defaults.width
	local h = gamelib.win_defaults.height
	gl.matrixMode(gl.GL_PROJECTION)
	gl.loadIdentity()
	gl.ortho(0, w, 0, h, -1, 1)
	gl.matrixMode(gl.GL_MODELVIEW)
end

--[[
	descrip:
		Sets perspective projection in OpenGL projection matrix,
		leaving matrix mode in GL_MODELVIEW.
]]
M.set_perspective = function ()
	gl.matrixMode(gl.GL_PROJECTION)
	gl.loadIdentity()
	local w = gamelib.win_width()
	local h = gamelib.win_height()
	local l = -w/2
	local r = w/2
	local b = -h/2
	local t =  h/2
	local n = 0.1
	local f = 1000
	glu.perspective(60, w/h, n, f)
	gl.matrixMode(gl.GL_MODELVIEW)
end

--[[
	descrip:
		Performs internal gamelib updates, should be called at the end of every game loop.
		Specifically, the following is done:
			. updates the screen with the opengl graphics buffer
			. updates glfw input buffers (keyboard and mouse)
			. clears the opengl graphics buffer
			. calculates fps
]]
M.update = function ()
	glfw.swapBuffers()
  M.win_open = glfw.getWindowParam(glfw.GLFW_OPENED)
  gl.clear(gl.GL_COLOR_BUFFER_BIT)

  -- calc fps and update window title
  M._num_frames_drawn = M._num_frames_drawn + 1
  local fps = M.calc_fps()
  local title = string.format("%s - fps: %3d", M.win_defaults.title, fps)
  glfw.setWindowTitle(title)
end

--[[
	descrip:
		Returns width of main window, in pixels.
]]
M.win_width = function()
  local width, height = glfw.getWindowSize()
  return width
end

--[[
	descrip:
		Returns width of main window, in pixels.
]]
M.win_height = function()
  local width, height = glfw.getWindowSize()
  return height
end

--[[
	descrip:
		Returns true if main window (opened with gamelib.open_window()) has been closed.

	notes:
		This requires gamelib.update() to be called in order to detect the closed state.
]]
M.window_closed = function()
  return M.win_open ~= gl.GL_TRUE
end



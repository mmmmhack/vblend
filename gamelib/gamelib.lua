-- gamelib.lua  :  provides high-level functions for games using gl and glfw libs
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

require('gl')
require('glfw')

-- game window defaults
M.win_width = 800
M.win_height = 600
M.win_open = false
M.win_bg_color = {[0]=0.2, [1]=0.2, [2]=0.2, [3]=0}

M.open_window = function()
	local rc = glfw.init()
  if rc ~= gl.GL_TRUE then
    error(string.format("glfw.init() failed, rc: %d", rc))
  end

	local w = M.win_width
	local h = M.win_height
	local r = 0
	local g = 0
	local b = 0
	local a = 0
	local d = 0
	local s = 0
	local mode = glfw.GLFW_WINDOW
	rc = glfw.openWindow(
		w, h, r, g, b, a, d, s, mode
	)
  if rc ~= gl.GL_TRUE then
    error(string.format("glfw.openWindow() failed, rc: %d", rc))
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

M.update = function()
	glfw.swapBuffers()
  M.win_open = glfw.getWindowParam(glfw.GLFW_OPENED)
  gl.clear(gl.GL_COLOR_BUFFER_BIT)
end

M.window_closed = function()
  return M.win_open ~= gl.GL_TRUE
end


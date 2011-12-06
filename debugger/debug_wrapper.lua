-- debug_wrapper.lua	:	 lua script to support debugging glfw wrapper functions in gdb

-- this script is called from C code
-- lua_glfw module is previously loaded from C code

-- convenience definitions to avoid requiring the gl module
--[[
local gl = {
	GL_TRUE = 1,
}
--]]
require('lua_gl')

function open_window()
	local rc = glfw.init()
  if rc ~= gl.GL_TRUE then
    error(string.format("glfw.init() failed, rc: %d", rc))
  end

	local w = 800
	local h = 600
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

end

function key_cb(key, action)
	print("beg key_cb()")
	print("end key_cb()")
end


function main()
	print("BEG debug_wrapper.lua main()")

	print("BEF glfw.init()")
	local rc = glfw.init()
	print(string.format("rc: %s", tostring(rc)))
	print("AFT glfw.init()")

	print("BEF open_window()")
	open_window()
	print("AFT open_window()")

	local w, h = glfw.getWindowSize()
	print(string.format("win w: [%s], win h: [%s]", tostring(w), tostring(h)))

  local cc = {[0]=0.2, [1]=0.2, [2]=0.2, [3]=0}
  gl.clearColor(cc[0], cc[1], cc[2], cc[3])


	print("BEF setKeyCallback()")
--	glfw.setKeyCallback(key_cb)
	glfw.setKeyCallback("key_cb")
	print("AFT setKeyCallback()")

	while true do

  	gl.clear(gl.GL_COLOR_BUFFER_BIT)
		glfw.swapBuffers()
	
  	local win_open = glfw.getWindowParam(glfw.GLFW_OPENED)
--		print(string.format("win_open: [%s]", tostring(win_open)))
		if win_open ~= gl.GL_TRUE then
			print(string.format("win_open: [%s]", tostring(win_open)))
			break
		end
	end

	print("END debug_wrapper.lua main()")
end

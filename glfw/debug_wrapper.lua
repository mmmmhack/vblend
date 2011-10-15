-- debug_wrapper.lua	:	 lua script to support debugging glfw wrapper functions in gdb

-- this script is called from C code
-- lua_glfw module is previously loaded from C code

-- convenience definitions to avoid requiring the gl module
local gl = {
	GL_TRUE = 1,
}

function open_window()
	local rc = lua_glfw.init()
  if rc ~= gl.GL_TRUE then
    error(string.format("lua_glfw.init() failed, rc: %d", rc))
  end

	local w = 800
	local h = 600
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

end

function main()
	print("BEG debug_wrapper.lua main()")

	print("BEF lua_glfw.init()")
	local rc = lua_glfw.init()
	print(string.format("rc: %s", tostring(rc)))
	print("AFT lua_glfw.init()")

	print("BEF open_window()")
	open_window()
	print("AFT open_window()")

	local w, h = lua_glfw.getWindowSize()
	print(string.format("win w: [%s], win h: [%s]", tostring(w), tostring(h)))

	while false do

		lua_glfw.swapBuffers()
	
  	local win_open = lua_glfw.getWindowParam(lua_glfw.GLFW_OPENED)
		print(string.format("win_open: [%s]", tostring(win_open)))
		if win_open ~= gl.GL_TRUE then
			break
		end
	end

	print("END debug_wrapper.lua main()")
end

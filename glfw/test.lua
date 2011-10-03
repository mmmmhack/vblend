--package.path=package.path .. ";../gl/?.so"
require('gl')
require('glfw')

function dbg(m)
end

function main()
	dbg("bef init")
	glfw.init()
	dbg("aft init")

local is_open = glfw.getWindowParam(glfw.GLFW_OPENED)
print(string.format("bef openWindow: is_open: [%s]", tostring(is_open)))

	local w = 800
	local h = 600
	local r = 0
	local g = 0
	local b = 0
	local a = 0
	local d = 0
	local s = 0
	local mode = glfw.GLFW_WINDOW
	dbg("bef openWindow()")
	local rc = glfw.openWindow(
		w, h, r, g, b, a, d, s, mode
	)
	print(string.format("aft openWindow(): rc: %d", rc))
	dbg("aft openWindow")

	gl.clearColor(0.2, 0.2, 0.2, 0)
	gl.matrixMode(gl.GL_PROJECTION)
	gl.loadIdentity()
	gl.ortho(0, 800, 0, 600, -1, 1)
	gl.matrixMode(gl.GL_MODELVIEW)
	gl.loadIdentity()

	while not done do
		gl.clear(gl.GL_COLOR_BUFFER_BIT)

		gl.color3f(0, 0.5, 0)
		gl.Begin(gl.GL_TRIANGLES)
			gl.vertex2f(100, 50)
			gl.vertex2f(300, 50)
			gl.vertex2f(200, 150)
		gl.End()

		dbg("bef swapBuffers")
		glfw.swapBuffers()
		dbg("aft swapBuffers")

		dbg("bef getWindowParam")
		local is_open = glfw.getWindowParam(glfw.GLFW_OPENED)
--		print(string.format("aft getWindowParam: open: [%s]", tostring(is_open)))

		if is_open == 0 then
			print("quitting")
			break
		end

	end
	dbg("terminating")
	glfw.terminate()
	dbg("end main()")
end

main()
dbg("aft main()")

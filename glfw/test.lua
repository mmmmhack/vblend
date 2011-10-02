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

	while not done do
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

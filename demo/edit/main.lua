-- main.lua	:	main window of test editor application

require "editor"

local fps = 60
local frame_time = 1/fps

-- create a line for testing
local _init_line = string.rep("0123456789", 7) .. "012345678"

--[[
	descrip: program entry function
]]
function main()
--	M.init()
	editor.init()
--debug_console()
	buffer.set(editor._active_buf, _init_line)
	gamelib.open_window("test editor")

	glfw.setKeyCallback('key_event')

	local run = true
	while run do
		-- beg frame
		local beg_time = sys.double_time()

		editor.tick()
		editor.draw()

		-- end frame
		gamelib.update()
		if gamelib.window_closed() then
			run = false
		end
		local end_time = sys.double_time()
		local wrk_time = end_time - beg_time
		local slp_time = frame_time - wrk_time
		slp_time = math.max(0, slp_time)
		sys.usleep(slp_time * 1e6)
	end
end

function quit()
	os.exit(0)
end

main()


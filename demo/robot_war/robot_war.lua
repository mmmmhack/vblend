-- robot_war.lua	:	combat between robo tanks, driven by lua scripts

require('gamelib')
require('world')
require('api')

local progname = "robot_war"
local frm_time = 1/60

function main()
	-- start game
	gamelib.open_window('robot_war')

	-- read robot scripts
	if #arg < 2 then
		print(string.format("usage: %s ROBOT_FILE1 ROBOT_FILE2", progname))
		os.exit(1)
	end
	local botfile1 = arg[1]
	local botfile2 = arg[2]
	local bot_files = {botfile1, botfile2}
	world.init(bot_files, gamelib.win_width(), gamelib.win_height())

--	local robot1 = dofile(botfile1)
--	local robot2 = dofile(botfile2)

	-- game main loop
	local done=false
	while not done do
		local beg_time = sys.double_time()

		-- do user bot update
--	 	robot1.update()
--	 	robot2.update()

		-- update world
		local dt = frm_time
		world.update(dt)

		-- check for quit
		gamelib.update()
		local quit_key = glfw.getKey(glfw.GLFW_KEY_ESC) == glfw.GLFW_PRESS
		if gamelib.window_closed() or quit_key then
			done = true
		end

		-- sleep
		local end_time = sys.double_time()
		local wrk_time = end_time - beg_time
		local slp_time = frm_time - wrk_time
		if slp_time > 0 then
			sys.usleep(slp_time * 1000000)
		end
	end
end

main()

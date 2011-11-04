-- paddle.lua	:	tests pong paddle drawing and movement
require('gamelib')

local fps = 60
local frm_time = 1.0 / fps

local paddle_accel = 20
local paddel_vel = 0
local rect = {
	x = 600,
	y = 400,
	w = 40,
	h = 100,
}

function draw_paddle()
	gamelib.draw_rect(rect.x, rect.y, rect.w, rect.h)
end

function do_input()
	paddel_vel = 0
	-- down key
	local dn = glfw.getKey(glfw.GLFW_KEY_DOWN) == glfw.GLFW_PRESS
	if dn then
		paddel_vel = -paddle_accel
	end
	-- up key
	local up = glfw.getKey(glfw.GLFW_KEY_UP) == glfw.GLFW_PRESS
	if up then
		paddel_vel = paddle_accel
	end
end

function move_paddle()
	rect.y = rect.y + paddel_vel
	-- clamp to boundary
	if rect.y < 0 then
		rect.y = 0
	end
	if rect.y + rect.h > gamelib.win_height() then
		rect.y = gamelib.win_height() - rect.h
	end
end

function main()
	gamelib.open_window()

	-- game main loop
	local done=false
	while not done do
		local beg_time = sys.double_time()

		-- draw paddle
		draw_paddle()

		-- handle input
		do_input()

		-- update paddle pos
		move_paddle()

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

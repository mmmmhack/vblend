-- pong.lua	:	demo pong game
require('gamelib')
require('geom')

local update_enabled = true
local fps = 60
local frm_time = 1.0 / fps

local paddle = {
	accel = 20,
	vel = 0,
	pos = {
		x = 600,
		y = 400,
	},
	w = 40,
	h = 100,
	color = {1.0, 1.0, 1.0}
}

local ball = {
	pos = { 
		x=50, 
		y=50,
	}, 
	w=30, 
	h=30,
	xdir = 1,
	ydir = 1,
	speed = 10,
	color = {1.0, 1.0, 0}
}

function draw_paddle()
  gl.color3f(paddle.color[1], paddle.color[2], paddle.color[3])
	gamelib.draw_rect(paddle.pos.x, paddle.pos.y, paddle.w, paddle.h)
end

function draw_ball()
  gl.color3f(ball.color[1], ball.color[2], ball.color[3])
  gamelib.draw_rect(ball.pos.x, ball.pos.y, ball.w, ball.h)
end

function draw()
	draw_paddle()
	draw_ball()
end

function do_input()
	paddle.vel = 0
	-- down key
	local dn = glfw.getKey(glfw.GLFW_KEY_DOWN) == glfw.GLFW_PRESS
	if dn then
		paddle.vel = -paddle.accel
	end
	-- up key
	local up = glfw.getKey(glfw.GLFW_KEY_UP) == glfw.GLFW_PRESS
	if up then
		paddle.vel = paddle.accel
	end
end

function update_paddle()
	paddle.pos.y = paddle.pos.y + paddle.vel
	-- clamp to boundary
	if paddle.pos.y < 0 then
		paddle.pos.y = 0
	end
	if paddle.pos.y + paddle.h > gamelib.win_height() then
		paddle.pos.y = gamelib.win_height() - paddle.h
	end
end

function dump_intersects()
	local bbi = geom.get_boundary_intersects(ball, paddle)
	local bei = geom.get_edge_intersects(ball, paddle)
	print(string.format("  ball geom: %d, %d, %d, %d", ball.pos.x, ball.pos.y, ball.w, ball.h))
	print(string.format("paddle geom: %d, %d, %d, %d", paddle.pos.x, paddle.pos.y, paddle.w, paddle.h))
	print("--- ball boundary intersects:")
	print(string.format("  x1: %d, x2: %d\n", bbi[1][1], bbi[1][2]))
	print(string.format("  y1: %d, y2: %d\n", bbi[2][1], bbi[2][2]))
	print("--- ball edge intersects:")
	print(string.format("  x1: %d, x2: %d\n", bei[1][1], bei[1][2]))
	print(string.format("  y1: %d, y2: %d\n", bei[2][1], bei[2][2]))
end

function update_ball()
  local win_w = gamelib.win_width()
  local win_h = gamelib.win_height()

  ball.pos.x = ball.pos.x + ball.xdir * ball.speed
  ball.pos.y = ball.pos.y + ball.ydir * ball.speed

	-- wall collision
  if (ball.pos.x + ball.w >= win_w) or (ball.pos.x < 0) then
    ball.xdir = -ball.xdir
  end
  if (ball.pos.y + ball.h >= win_h) or (ball.pos.y < 0) then
    ball.ydir = -ball.ydir
  end

	-- paddle collision
	local bei = geom.get_edge_intersects(ball, paddle)
	local ic = geom.get_edge_intersect_counts(bei)

	if 		 ic.x == 1 then
--dump_intersects()		
--update_enabled = false
    ball.xdir = -ball.xdir
		if ic.y == 1 then
    	ball.ydir = -ball.ydir
		end
	elseif ic.y == 1 then
    ball.ydir = -ball.ydir
	end

end

function main()
	gamelib.open_window()

	-- game main loop
	local done=false
	while not done do
		local beg_time = sys.double_time()

		-- draw paddle
		draw()

		-- handle input
		do_input()

		-- update paddle pos
		if update_enabled then
			update_paddle()

			-- update ball
			update_ball()
		end

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

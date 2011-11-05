-- pong.lua	:	demo pong game
require('gamelib')

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

function get_boundary_intersects(r1, r2)
	local isc = {
		[1] = {
			[1] = 0,
			[2] = 0,
		},
		[2] = {
			[1] = 0,
			[2] = 0,
		},
	}
	local r1x1 = r1.pos.x
	local r1x2 = r1.pos.x + r1.w
	local r2x1 = r2.pos.x
	local r2x2 = r2.pos.x + r2.w
	if r1x1 < r2x1 then
		isc[1][1] = -1
	elseif r1x1 > r2x2 then
		isc[1][1] =  1
	end
	if r1x2 < r2x1 then
		isc[1][2] = -1
	elseif r1x2 > r2x2 then
		isc[1][2] =  1
	end
	local r1y1 = r1.pos.y
	local r1y2 = r1.pos.y + r1.h
	local r2y1 = r2.pos.y
	local r2y2 = r2.pos.y + r2.h
	if r1y1 < r2y1 then
		isc[2][1] = -1
	elseif r1y1 > r2y2 then
		isc[2][1] =  1
	end
	if r1y2 < r2y1 then
		isc[2][2] = -1
	elseif r1y2 > r2y2 then
		isc[2][2] =  1
	end
	return isc
end

function get_edge_intersects(r1, r2)
	local intersects = {
		[1] = {
			[1] = 0,
			[2] = 0,
		},
		[2] = {
			[1] = 0,
			[2] = 0,
		},
	}
	local bi = get_boundary_intersects(r1, r2)
	for dim = 1, 2 do
		local other_dim = dim == 1 and 2 or 1
		for edge = 1, 2 do
			-- first condition: edge 'boundary' must intersect other rect edge boundaries
			if bi[dim][edge] == 1 then
				-- second condition: other-dim boundaries:
				--		(lower boundary intersect OR upper boundary intersect) OR
				if (bi[other_dim][1] ==  1  or bi[other_dim][2] == 1) or
				--    (lower boundary below AND upper boundary above)
					 (bi[other_dim][1] == -1 and bi[other_dim][2] == 1)
					then
						intersects[dim][edge] = 1
				end
			end
		end
	end
	return intersects
end

function get_edge_intersect_counts(edge_intersects)
	local counts = {
		x = 0,
		y = 0,
	}
	for dim = 1, 2 do
		for edge = 1, 2 do
			local isc = edge_intersects[dim][edge]
			if isc == 1 then
				if dim == 1 then
					counts.x = counts.x + 1
				else
					counts.y = counts.y + 1
				end
			end
		end
	end
	return counts
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
	local bei = get_edge_intersects(ball, paddle)
	local ic = get_edge_intersect_counts(bei)

	if 		 ic.x == 1 then
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
		update_paddle()

		-- update ball
		update_ball()

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

-- grid3d.lua	:	demonstrates rendering and view transformation in 3D space

require('gamelib')

local cam_z = 0
local cam_rate = 0.1

function draw_grid()
	gl.color3f(0, 1, 0)
	gl.Begin(gl.GL_LINES)
		local y = -10

		local zb = -200
		local ze = -10

		local xb = -100
		local xe = 100

		local dx = 10
		local dz = 10
		-- columns
if true then
		for x = xb, xe, dx do
			gl.vertex3f(x, y, zb)
			gl.vertex3f(x, y, ze)
		end
end
		-- rows
if true then
		for z = zb, ze, dz do
			gl.vertex3f(xb, y, z)
			gl.vertex3f(xe, y, z)
		end
end
--gl.vertex3f(-500, -10, -1)	
--gl.vertex3f( 500, -10, -1)	
	gl.End()
end

function set_projection()
	gl.matrixMode(gl.GL_PROJECTION)
	gl.loadIdentity()
	local w = gamelib.win_width()
	local h = gamelib.win_height()
	local l = -w/2
	local r = w/2
	local b = -h/2
	local t =  h/2
	local n = 0.1
	local f = 1000
--gl.frustum(l, r, b, t, n, f)
	glu.perspective(60, w/h, n, f)
	gl.matrixMode(gl.GL_MODELVIEW)
end

function check_input()
	local forward = glfw.getKey(glfw.GLFW_KEY_UP) == glfw.GLFW_PRESS
	if forward then
		cam_z = cam_z + cam_rate
	end
	local back = glfw.getKey(glfw.GLFW_KEY_DOWN) == glfw.GLFW_PRESS
	if back then
		cam_z = cam_z - cam_rate
	end
end

function main()
	gamelib.open_window()

	-- set frustum projection
	set_projection()

	local done = false
	while not done do
		gl.loadIdentity()
		gl.translatef(0, 0, cam_z)

		draw_grid()
		gamelib.update()

		-- get navigation input
	  check_input()


		-- check for exit
		local esc_key_hit = glfw.getKey(glfw.GLFW_KEY_ESC) == glfw.GLFW_PRESS
		done = gamelib.window_closed() or esc_key_hit
	end
end

main()

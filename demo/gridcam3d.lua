-- gridcam3d.lua	:	demonstrates rendering and view transformation in 3D space

require('gamelib')
require('cam_control')

require('debugger')

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
		for x = xb, xe, dx do
			gl.vertex3f(x, y, zb)
			gl.vertex3f(x, y, ze)
		end
		-- rows
		for z = zb, ze, dz do
			gl.vertex3f(xb, y, z)
			gl.vertex3f(xe, y, z)
		end
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
	glu.perspective(60, w/h, n, f)
	gl.matrixMode(gl.GL_MODELVIEW)
end

function apply_inputs(dt, cam)
	cam_control.update(dt, cam)
end

function main()
	gamelib.open_window()

	-- set frustum projection
	set_projection()

	local frame_time = 1/60
	local cam = camera.new()
	local done = false
	while not done do
		local beg_time = sys.double_time()

		gl.loadIdentity()

--debug_print(eye_pos, cen_pos, up_dir, look_dir)
		local eye_pos = cam.center
		local cen_pos = vector3.add(eye_pos, cam.look_dir)
		local up_dir = cam.up_dir
		glu.lookAt(eye_pos.x, eye_pos.y, eye_pos.z, cen_pos.x, cen_pos.y, cen_pos.z, up_dir.x, up_dir.y, up_dir.z)

		draw_grid()
		gamelib.update()

		-- get navigation input
	  apply_inputs(frame_time, cam)

		-- check for exit
		local esc_key_hit = glfw.getKey(glfw.GLFW_KEY_ESC) == glfw.GLFW_PRESS
		done = gamelib.window_closed() or esc_key_hit

		local end_time = sys.double_time()
		local work_time = end_time - beg_time
		local sleep_time = frame_time - work_time
		sleep_time = math.max(0, sleep_time)
		sys.usleep(sleep_time * 1e6)
	end
end

main()

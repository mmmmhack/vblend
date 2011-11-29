-- grid3d.lua	:	demonstrates rendering and view transformation in 3D space

require('gamelib')
require('vector3')

require('debugger')

local cam_y_rot = 0			-- rotation about cam y axis, in degrees
--local cam_z = 0			  -- translation along cam z axis
--local cam_trans = {x = 0, y = 0, z = 0};
local cam_trans_rate = 0.1
local cam_rot_rate = 10

local init_look_dir = {x = 0, y = 0, z = -1}
local look_dir = {x = 0, y = 0, z = -1}
--local look_dir = {x = 0, y = 0, z = -1}
local eye_pos = {x = 0, y = 0, z = 0}
local cen_pos = {x = 0, y = 0, z = 0}
local up_dir = {x = 0, y = 1, z = 0}

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
--gl.frustum(l, r, b, t, n, f)
	glu.perspective(60, w/h, n, f)
	gl.matrixMode(gl.GL_MODELVIEW)
end

function deg2rad(deg)
	return deg * math.pi / 180
end

-- rotates param vector about the y axis by param degrees
function rotate_y(v, angle_deg)
--	return vector3.copy(v)
	local vn = vector3.normalized(v)
	local theta = deg2rad(angle_deg)
	local x = vn.x * math.sin(theta)
	local y = vn.y
	local z = vn.z * math.cos(theta)
	local vr = {x = x, y = y, z = z}
	return vr
end

function apply_inputs()
	-- y rotation
	local right = glfw.getKey(glfw.GLFW_KEY_RIGHT) == glfw.GLFW_PRESS
	if right then
		cam_y_rot = cam_y_rot + cam_rot_rate
	end
	local left = glfw.getKey(glfw.GLFW_KEY_LEFT) == glfw.GLFW_PRESS
	if left then
--debug_console()
		cam_y_rot = cam_y_rot - cam_rot_rate
	end

	-- update look dir after y rotation
	-- rotate init look dir in -z dir about y axis by y rotation angle
look_dir = rotate_y(init_look_dir, cam_y_rot)

	-- update eye pos translation: translate along look dir
	local cam_trans = {x=0, y=0, z=0}
	local forward = glfw.getKey(glfw.GLFW_KEY_UP) == glfw.GLFW_PRESS
	if forward then
		cam_trans.z = cam_trans.z + cam_trans_rate
	end
	local back = glfw.getKey(glfw.GLFW_KEY_DOWN) == glfw.GLFW_PRESS
	if back then
		cam_trans.z = cam_trans.z - cam_trans_rate
	end
--	eye_pos.z = cam_trans.z
	local eye_trans = vector3.mul(look_dir, cam_trans.z)
	eye_pos = vector3.add(eye_pos, eye_trans)

	-- update look center after eye position change
	cen_pos = vector3.add(eye_pos, look_dir)

end

local prev_eye_pos = {x=0,y=0,z=0}
local prev_cen_pos = {x=0,y=0,z=0}
local prev_up_dir = {x=0,y=0,z=0}
local prev_look_dir = {x=0,y=0,z=0}
function debug_print(eye_pos, cen_pos, up_dir, look_dir)
	if 
		vector3.equal(prev_eye_pos, eye_pos) and
		vector3.equal(prev_cen_pos, cen_pos) and
		vector3.equal(prev_up_dir, up_dir) and
		vector3.equal(prev_look_dir, look_dir) 
		then
		return
	end
	prev_eye_pos = vector3.copy(eye_pos)
	prev_cen_pos = vector3.copy(cen_pos)
	prev_up_dir = vector3.copy(up_dir)
	prev_look_dir = vector3.copy(look_dir)

	print(string.format("eye_pos: %s", vector3.tostring(eye_pos)))
	print(string.format("cen_pos: %s", vector3.tostring(cen_pos)))
	print(string.format("up_dir: %s", vector3.tostring(up_dir)))
	print(string.format("look_dir: %s", vector3.tostring(look_dir)))
	print("")
end

function main()
	gamelib.open_window()

	-- set frustum projection
	set_projection()

	local done = false
	while not done do
		gl.loadIdentity()

debug_print(eye_pos, cen_pos, up_dir, look_dir)
		glu.lookAt(eye_pos.x, eye_pos.y, eye_pos.z, cen_pos.x, cen_pos.y, cen_pos.z, up_dir.x, up_dir.y, up_dir.z)

		draw_grid()
		gamelib.update()

		-- get navigation input
	  apply_inputs()

		-- check for exit
		local esc_key_hit = glfw.getKey(glfw.GLFW_KEY_ESC) == glfw.GLFW_PRESS
		done = gamelib.window_closed() or esc_key_hit
	end
end

main()

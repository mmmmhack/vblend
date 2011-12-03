-- camera.lua	:	changes the viewing frame in 3D space
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

require('vector3')
require('matrix3')
require('geom')

M.new = function()
	local cam = {
		trans_rate = 30,
		rot_rate = 60,

		-- camera states: these are rates of translation or rotation along frame axes
		-- rate values: 0: no change, -N: change in negative axis dir, N: change in positive axis dir
		state = {
			['trans_x'] = 0,
			['trans_y'] = 0,
			['trans_z'] = 0,
			['rot_x'] = 0,
			['rot_y'] = 0,
			['rot_z'] = 0,
		},

		--M.basis = matrix3.identity()
		center = vector3.new(0, 0, 0),
		look_dir = vector3.new(0, 0, -1),
		up_dir = vector3.new(0, 1, 0),
	}
	return cam
end

-- returns a matrix representing param camera rotation
M.basis = function(cam)
	local vx = vector3.cross(cam.look_dir, cam.up_dir)
	local vy = cam.up_dir
	local vz = vector3.mul(cam.look_dir, -1)
	local Mb = matrix3.new(vx, vy, vz)	
	return Mb
end

-- returns matrix representing param cam rotation where cam up dir is projected onto alignment with world y axis,
-- or nil if cam up dir is perpedicular to world y axis
M.get_projected_frame = function(cam)
	-- convert translation to adjusted camera frame, where adjustment is projection of look_dir onto xz plane,
	-- up_dir is aligned with world y axis
	local proj_look_dir = vector3.copy(cam.look_dir)
	proj_look_dir.y = 0
	proj_look_dir = vector3.normalized(proj_look_dir) 
	if vector3.magnitude(proj_look_dir) == 0 then
		return nil
	end
	local vy = vector3.new(0, 1, 0)
	local vx = vector3.cross(proj_look_dir, vy)
	local vz = vector3.mul(proj_look_dir, -1)
	local Mr = matrix3.new(vx, vy, vz)
	return Mr
end

-- updates camera frame by applying translations and rotations for param time interval
M.update = function(cam, dt)
	-- TODO: transform trans vector from world frame to cam frame
--[[
	cam.center.x = cam.center.x + cam.state['trans_x'] * cam.trans_rate * dt
	cam.center.y = cam.center.y + cam.state['trans_y'] * cam.trans_rate * dt
	cam.center.z = cam.center.z + cam.state['trans_z'] * cam.trans_rate * dt
--]]
	local vtrans = vector3.new()
	vtrans.x = cam.state['trans_x'] * cam.trans_rate * dt
	vtrans.y = cam.state['trans_y'] * cam.trans_rate * dt
	vtrans.z = cam.state['trans_z'] * cam.trans_rate * dt
	if not vector3.equal(vtrans, vector3.zero()) then
--debug_console()		
		local Mr = M.get_projected_frame(cam) 
		if Mr then
			vtrans = vector3.mul(vtrans, Mr)
			cam.center = vector3.add(cam.center, vtrans)
		end
	end

	local rotated = false
	if cam.state['rot_x'] ~= 0 then
		local theta = cam.state['rot_x'] * cam.rot_rate * dt
		local vrot = vector3.cross(cam.look_dir, cam.up_dir)
		local Mr = geom.create_rot_matrix(vrot, theta)
		cam.look_dir = vector3.mul(cam.look_dir, Mr)
		cam.up_dir = vector3.cross(vrot, cam.look_dir)
		rotated = true
	end
	if cam.state['rot_y'] ~= 0 then
		local theta = cam.state['rot_y'] * cam.rot_rate * dt
		-- project both look_dir and up dir rotations onto world y axis
		local vy = vector3.new(0, 1, 0)
		local Mr = geom.create_rot_matrix(vy, theta)
		cam.look_dir = vector3.mul(cam.look_dir, Mr)
		cam.up_dir = vector3.mul(cam.up_dir, Mr)
		rotated = true
	end
	if cam.state['rot_z'] ~= 0 then
		local theta = cam.state['rot_z'] * cam.rot_rate * dt
		local Mr = geom.create_rot_matrix(cam.look_dir, theta)
		cam.up_dir = vector3.mul(cam.up_dir, Mr)
		rotated = true
	end

	-- error correction
	if rotated then
		local vperp = vector3.cross(cam.look_dir, cam.up_dir)
		cam.up_dir = vector3.cross(vperp, cam.look_dir)
		cam.look_dir = vector3.normalized(cam.look_dir)
		cam.up_dir = vector3.normalized(cam.up_dir)
	end
end


-- matrix3.lua	:	3x3 matrix
require('geom')

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.new = function(v0, v1, v2)
	local m = {
		[0] = { [0] = v0.x, [1] = v0.y, [2] = v0.z, },
		[1] = { [0] = v1.x, [1] = v1.y, [2] = v1.z, },
		[2] = { [0] = v2.x, [1] = v2.y, [2] = v2.z, },
	}
	return m
end

M.identity = function()
	local m = {
		[0] = { [0] = 1, [1] = 0, [2] = 0, },
		[1] = { [0] = 0, [1] = 1, [2] = 0, },
		[2] = { [0] = 0, [1] = 0, [2] = 1, },
	}
	return m
end

M.transpose = function(m)
	local mr = {
		[0] = { [0] = m[0][0], [1] = m[1][0], [2] = m[2][0], },
		[1] = { [0] = m[0][1], [1] = m[1][1], [2] = m[2][1], },
		[2] = { [0] = m[0][2], [1] = m[1][2], [2] = m[2][2], },
	}
	return mr
end

M.rotx = function(angle_deg)
	local theta = geom.deg2rad(angle_deg)
	local m = {
		[0] = { [0] = 1, [1] = 0, [2] = 0, },
		[1] = { [0] = 0, [1] = math.cos(theta), [2] = math.sin(theta), },
		[2] = { [0] = 0, [1] = -math.sin(theta), [2] = math.cos(theta), },
	}
	return m
end

M.roty = function(angle_deg)
	local theta = geom.deg2rad(angle_deg)
	local m = {
		[0] = { [0] = math.cos(theta), [1] = 0, [2] = -math.sin(theta), },
		[1] = { [0] = 0, [1] = 1, [2] = 0, },
		[2] = { [0] = math.sin(theta), [1] = 0, [2] = math.cos(theta), },
	}
	return m
end

M.rotz = function(angle_deg)
	local theta = geom.deg2rad(angle_deg)
	local m = {
		[0] = { [0] = math.cos(theta), [1] = math.sin(theta), [2] = 0, },
		[1] = { [0] = -math.sin(theta), [1] = math.cos(theta), [2] = 0, },
		[2] = { [0] = 0, [1] = 0, [2] = 1, },
	}
	return m
end

M.mul = function(ma, mb)
	local m = {
		[0] = {[0]=ma[0][0]*mb[0][0]+ma[0][1]*mb[1][0]+ma[0][2]*mb[2][0], [1]=ma[0][0]*mb[0][1]+ma[0][1]*mb[1][1]+ma[0][2]*mb[2][1], [2]=ma[0][0]*mb[0][2]+ma[0][1]*mb[1][2]+ma[0][2]*mb[2][2]},
		[1] = {[0]=ma[1][0]*mb[0][0]+ma[1][1]*mb[1][0]+ma[1][2]*mb[2][0], [1]=ma[1][0]*mb[0][1]+ma[1][1]*mb[1][1]+ma[1][2]*mb[2][1], [2]=ma[1][0]*mb[0][2]+ma[1][1]*mb[1][2]+ma[1][2]*mb[2][2]},
		[2] = {[0]=ma[2][0]*mb[0][0]+ma[2][1]*mb[1][0]+ma[2][2]*mb[2][0], [1]=ma[2][0]*mb[0][1]+ma[2][1]*mb[1][1]+ma[2][2]*mb[2][1], [2]=ma[2][0]*mb[0][2]+ma[2][1]*mb[1][2]+ma[2][2]*mb[2][2]},
	}
	return m
end

M.tostring = function(m)
	local s = ""
	for i = 0, 2 do
		s = s .. string.format("%9.4f %9.4f %9.4f\n", m[i][0],  m[i][1],  m[i][2])
	end
	return s
end


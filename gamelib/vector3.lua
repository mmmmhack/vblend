-- vector3.lua
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.new = function(x, y, z)
	x = x or 0
	y = y or 0
	z = z or 0
	return {x = x, y = y, z = z}
end

M.zero = function()
	return {x = 0, y = 0, z = 0}
end

M.copy = function(v)
  local vr = {x = v.x, y = v.y, z = v.z}
  return vr
end

M.add = function(va, vb)
  local vr = {x = va.x + vb.x, y = va.y + vb.y, z = va.z + vb.z}
  return vr
end

M.mul_scalar = function(v, scalar)
  local vr = {x = v.x * scalar, y = v.y * scalar, z = v.z * scalar}
  return vr
end

M.magnitude = function(v)
  local m = math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  return m
end

M.normalized = function(v)
  local mag = M.magnitude(v)
  if mag == 0 then
    return {0, 0, 0}
  end
  local vr = {x = v.x / mag, y = v.y / mag, z = v.z / mag}
  return vr
end

M.equal = function(va, vb)
  return va.x == vb.x and va.y == vb.y and va.z == vb.z
end

M.tostring = function(v)
  return string.format("%f, %f, %f", v.x, v.y, v.z)
end

M.dot = function(va, vb)
	local s = va.x * vb.x + va.y * vb.y + va.z * vb.z
	return s
end

M.cross = function(va, vb)
	local vr = {
		x = va.y * vb.z - va.z * vb.y,
		y = va.z * vb.x - va.x * vb.z,
		z = va.x * vb.y - va.y * vb.x,
	}
	return vr
end

M.mul_matrix = function(v, m)
	local vr = {
		x = v.x*m[0][0] + v.y*m[1][0] + v.z*m[2][0],
		y = v.x*m[0][1] + v.y*m[1][1] + v.z*m[2][1],
		z = v.x*m[0][2] + v.y*m[1][2] + v.z*m[2][2],
	}
	return vr
end

M.mul = function(v, o)
	if type(o) == 'table' then
		return M.mul_matrix(v, o)
	else
		return M.mul_scalar(v, o)
	end
end


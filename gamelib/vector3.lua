-- vector3.lua
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.copy = function(v)
  local vr = {x = v.x, y = v.y, z = v.z}
  return vr
end

M.add = function(va, vb)
  local vr = {x = va.x + vb.x, y = va.y + vb.y, z = va.z + vb.z}
  return vr
end

M.mul = function(v, scalar)
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


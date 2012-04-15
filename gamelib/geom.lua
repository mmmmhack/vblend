-- geom.lua	:	geometry routines
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

--[[
Returns boundary intersects of rect r1 with rect r2.
Params:
	r1	type: table, descrip: rectangle with attributes x, y, w, h (left, bottom, width, height)
	r2	type: table, descrip: rectangle with attributes x, y, w, h (left, bottom, width, height)
Returns:
	bound_intersects	
			type: table
			descrip: flags for r1 vertical (bound[1][1] and bound[1][2]) and horizontal (bound[2][1] and bound[2][2]) 
			    boundary intersects with r2 boundaries
				  flags: -1: r1 bound < r2 lower bound
				          0: r2 lower bound <= r1 bound <= r2 upper bound
								  1: r2 upper bound < r1 bound
]]
M.get_boundary_intersects = function (r1, r2)
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

--[[
  descrip:
    Returns flags for intersection of edges of rect r1 with rect r2.
  params:
    r1	type: table, descrip: rectangle with attributes x, y, w, h (left, bottom, width, height)
    r2	type: table, descrip: rectangle with attributes x, y, w, h (left, bottom, width, height)
  returns:
    edge_intersects	
        type: table
        descrip: flags for r1 vertical edge intersects (edge_intersects[1][1] and edge_intersects[1][2]) and 
            horizontal edge interscts (edge_intersects[2][1] and edge_intersects[2][2]) 
            with r2
            flags: 0: no intersect, 1: intersect
]]
M.get_edge_intersects = function (r1, r2)
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
	local bi = M.get_boundary_intersects(r1, r2)
	for dim = 1, 2 do
		local other_dim = dim == 1 and 2 or 1
		for edge = 1, 2 do
			-- first condition: edge 'boundary' must intersect other rect edge boundaries
			if bi[dim][edge] == 0 then
				-- second condition: other-dim boundaries:
				--		(lower boundary intersect OR upper boundary intersect) OR
				if (bi[other_dim][1] ==  0  or bi[other_dim][2] == 0) or
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

--[[
  descrip:
    Returns counts of vertical and horizontal edge intersects in param edge intersects table.
  params:
	  edge_intersects	type: table, descrip: table returned by get_edge_intersects() 
  returns:
	  counts		type: table, descrip: x: count of vertical edge intersects, y: count of horizontal edge intersects
]]
M.get_edge_intersect_counts = function (edge_intersects)
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

M.deg2rad = function(deg)
	return deg * math.pi / 180
end

M.rad2deg = function(rad)
	return rad * 180 / math.pi
end

--[[
  descrip:
    Returns a matrix with rotation about vector vrot by angle angle_deg
]]
M.create_rot_matrix = function(vrot, angle_deg)
	-- implementation:
	-- create M<sup>T</sup> * R<sub>x</sub> * M where: 
	--		M is cartesian basis transformed to (vrot, vrot_perp, vrot x vrot_perp)
	--		R<sub>x</sub> is rotation matrix about cartesian x axis
	local epsilon = 0.0000001
	if vector3.magnitude(vrot) < epsilon then
		return nil
	end
	local vr = vector3.normalized(vrot)
	local vc = {x = 1, y = 0, z = 0}
	local vperp = vector3.cross(vr, vc)
	if vector3.magnitude(vperp) < epsilon then
		vc = {x = 0, y = 1, z = 0}
		vperp = vector3.cross(vr, vc)
	end
	vperp = vector3.normalized(vperp)
	local vperp2 = vector3.cross(vr, vperp)
	vperp2 = vector3.normalized(vperp2)
	local M = {
		[0] = {[0] = vr.x, [1] = vr.y, [2] = vr.z},
		[1] = {[0] = vperp.x, [1] = vperp.y, [2] = vperp.z},
		[2] = {[0] = vperp2.x, [1] = vperp2.y, [2] = vperp2.z},
	}
	local Rx = matrix3.rotx(angle_deg)
	local Mi = matrix3.mul(Rx, M)
	local Mt = matrix3.transpose(M)
	local Mr = matrix3.mul(Mt, Mi)
	return Mr
end

--[[
  descrip:
    Returns normal calculated from param table of 3 vertices

  params:
    verts: type: table, descrip: table with 0-based array of 3 vector3d vertices

  returns:
    normal: type: table, descrip: vector3
]]
M.calc_normal = function(verts)
  local v01 = vector3.sub(verts[1], verts[0])  
  local v02 = vector3.sub(verts[2], verts[0])  
  local vcross = vector3.cross(v01, v02)
  return vector3.normalized(vcross)
end


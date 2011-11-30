-- create_rot_matrix.lua	:	creates a matrix representation rotation about an arbitrary vector
require('vector3')
require('matrix3')

-- returns a matrix with rotation about vector vrot by angle angle_deg
function get_rot_matrix(vrot, angle_deg)
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

function main()
	print("--- create rotation matrix")
	io.write("enter a rotation vector (x y z): ")
	local s = io.read()
	local vrot = {x=1, y=0, z=0}
	local angle = 90
	print(string.format("creating a matrix with rotation of %d degrees about vector %s", angle, vector3.tostring(vrot)))
end

main()

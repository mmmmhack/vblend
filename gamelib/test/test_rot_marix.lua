-- create_rot_matrix.lua	:	creates a matrix representation rotation about an arbitrary vector
require('util')
require('vector3')
require('matrix3')
require('geom')

--require('debugger')

function main()
	print("--- create rotation matrix")
	local vrot = {x=1, y=0, z=0}
	io.write(string.format("enter a rotation vector [%d %d %d]: ", vrot.x, vrot.y, vrot.z))
	local s = io.read()
	if #s > 0 then
		local toks = util.split(s, " ")
		vrot = {x=tonumber(toks[1]), y=tonumber(toks[2]), z=tonumber(toks[3]),} 
	end
	local angle = 90
	io.write(string.format("enter a rotation angle in degrees [%d]: ", angle))
	s = io.read()
	if #s > 0 then
		angle = tonumber(s)
	end
	print(string.format("creating a matrix with rotation of %d degrees about vector %s", angle, vector3.tostring(vrot)))
	local m = geom.create_rot_matrix(vrot, angle)
	print(string.format("%s", matrix3.tostring(m)))

	print("--- test the matrix")
	local vtest = {x=0, y=0, z=1}
	io.write(string.format("enter a test vector to be rotated [%d %d %d]: ", vtest.x, vtest.y, vtest.z))
	local s = io.read()
	if #s > 0 then
		local toks = util.split(s, " ")
		vtest = {x=tonumber(toks[1]), y=tonumber(toks[2]), z=tonumber(toks[3]),} 
	end
	local vres = vector3.mul(vtest, m)
	print(string.format("result vector: %s", vector3.tostring(vres)))
end

main()

-- editor3d.lua	:	3D graphics editor
local modname = ...
local M = {}
_G[modname] = M
package.loaded[modname] = M

local app = vblend
local grid_color = 0.3
local cursor_alpha = 1.0
--[[
	descrip:
		Draws a wireframe grid in the x-z plane, centered at the origin.
]]
M.draw_grid = function ()
	local c = grid_color
	gl.color3f(c, c, c)
	gl.Begin(gl.GL_LINES)
		local y = 0

		local zb = -100
		local ze = 100

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

--[[
	descrip:
		Draws a 3d cursor.
]]
M.draw_cursor3d = function()
--[[
	gl.pushMatrix()
		gl.rotatef(90, 0, 1, 0)
		gamelib.draw_circle_wireframe(0, 0, 1.0)
	gl.popMatrix()

	gl.pushMatrix()
		gl.rotatef(90, -1, 0, 0)
		gamelib.draw_circle_wireframe(0, 0, 1.0)
	gl.popMatrix()

	gl.pushMatrix()
		gamelib.draw_circle_wireframe(0, 0, 1.0)
	gl.popMatrix()
]]
	local verts = {
		-1, 0, 0,
		0, -1, 0,
		0, 0, -1,
		1, 0, 0,
		0, 1, 0,
		0, 0, 1,
	}
	local tris = {
		0, 2, 1,
		0, 1, 5,
		1, 3, 5,
		1, 2, 3,
		0, 4, 2,
		0, 5, 4,
		3, 4, 5,
		3, 2, 4,
	}
	local c = grid_color
	gl.color4f(c, c, c, cursor_alpha)
--	gl.color3f(1, 0, 0)
	graphics.draw_tris(verts, tris)

	-- draw axes
	local draw_axes = false
	if draw_axes then
		gl.Begin(gl.GL_LINES)
		for i = 0, 2 do
			local x = i==0 and 1 or 0
			local y = i==1 and 1 or 0
			local z = i==2 and 1 or 0
			local s = 1.2
			local vb = vector3.new(-s*x, -s*y, -s*z)
			local ve = vector3.new(s*x, s*y, s*z)
	--debug_console()
			gl.color3f(x, y, z)
			gl.vertex3f(vb.x, vb.y, vb.z)
			gl.vertex3f(ve.x, ve.y, ve.z)
	--print(string.format("axis%d:x:%f,y:%f,z:%f,vb[1]:%f,vb[2]:%f,vb[3]:%f,ve[1]:%f,ve[2]:%f,ve[3]:%f",
	--i, x, y, z, vb[1], vb[2], vb[3], ve[1], ve[2], ve[3]))
		end
		gl.End()
	end
end

M.tick = function()
--	app.status_out(string.format("frame count: %d", app.frame_count))
	app.status_out(string.format("cam center: %s", vector3.tostring(app.cam.center)))
end

M.draw = function ()
	M.draw_grid()
	M.draw_cursor3d()
end


-- graphics.lua	: graphic util

local modname = ...
local M = {}
_G[modname] = M
package.loaded[modname] = M

--[[
	descrip:
		Draws param mesh of triangles.

	params:
		verts: type: table, descrip: 1-based array of 3d vertex coordinates
		tris:	type: table, descrip: 1-based array of 0-based indices into verts array
]]
M.draw_tris = function(verts, tris)
	gl.Begin(gl.GL_TRIANGLES)
		local k = 1
		local num_tris = #tris / 3
		for tri = 1, num_tris do
      local tri_verts = {}  -- for normal calc
			for j = 0, 2 do
				local vi = tris[k + j]
	--print(string.format("tri %d: i: %d, j: %d, ix: %d, iy: %d, iz: %d", i, i, j, ix, iy, iz))
				local vo = vi * 3 + 1
				local x = verts[vo + 0]
				local y = verts[vo + 1]
				local z = verts[vo + 2]
--print(string.format("tri %d: vert %d: vi: %d, vo: %d, (%d, %d, %d)", tri, j, vi, vo, x, y, z))
				gl.vertex3f(x, y, z)
        tri_verts[j] = vector3.new(x, y, z)
			end
      -- define normal for tri
      local normal = geom.calc_normal(tri_verts)
      gl.normal3f(normal.x, normal.y, normal.z)
--print(string.format("  normal: %f, %f, %f", normal.x, normal.y, normal.z))

			k = k + 3
		end
	gl.End()
end

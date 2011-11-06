-- test_geom.lua	:	unit tests for geom.lua
require('unittest')
require('geom')

local assert_equal = unittest.assert_equal
local tests = {}

tests['get_boundary_intersects.r1_ol_r2.m1x_0y'] = function()
	local r1 = { pos={x=0, y=0}, w=1, h=1}
	local r2 = { pos={x=2, y=0}, w=1, h=1}
	local b = geom.get_boundary_intersects(r1, r2) 
	assert_equal(b[1][1], -1)
	assert_equal(b[1][2], -1)
	assert_equal(b[2][1],  0)
	assert_equal(b[2][2],  0)
end

tests['get_boundary_intersects.r1_il_r2.m1x_0y'] = function()
	local r1 = { pos={x=0, y=0}, w=2.5, h=1}
	local r2 = { pos={x=2, y=0}, w=1, h=1}
	local b = geom.get_boundary_intersects(r1, r2) 
	assert_equal(b[1][1], -1)
	assert_equal(b[1][2],  0)
	assert_equal(b[2][1],  0)
	assert_equal(b[2][2],  0)
end

tests['get_boundary_intersects.r1_oa_r2.0x_1y'] = function()
	local r1 = { pos={x=0, y=2}, w=1, h=1}
	local r2 = { pos={x=0, y=0}, w=1, h=1}
	local b = geom.get_boundary_intersects(r1, r2) 
	assert_equal(b[1][1], 0)
	assert_equal(b[1][2], 0)
	assert_equal(b[2][1], 1)
	assert_equal(b[2][2], 1)
end

tests['get_boundary_intersects.r1_gtc_r2.0x_0y'] = function()
	local r1 = { pos={x=620, y=520}, w=30, h=30}
	local r2 = { pos={x=600, y=400}, w=40, h=100}
	local b = geom.get_edge_intersects(r1, r2) 
	assert_equal(b[1][1], 0)
	assert_equal(b[1][2], 1)
	assert_equal(b[2][1], 1)
	assert_equal(b[2][2], 1)
end


tests['get_edge_intersects.r1_oa_r2.0x_0y'] = function()
	local r1 = { pos={x=0, y=2}, w=1, h=1}
	local r2 = { pos={x=0, y=0}, w=1, h=1}
	local b = geom.get_edge_intersects(r1, r2) 
	assert_equal(b[1][1], 0)
	assert_equal(b[1][2], 0)
	assert_equal(b[2][1], 0)
	assert_equal(b[2][2], 0)
end

tests['get_edge_intersects.r1_gtc_r2.0x_0y'] = function()
	local r1 = { pos={x=620, y=520}, w=30, h=30}
	local r2 = { pos={x=600, y=400}, w=40, h=100}
	local b = geom.get_edge_intersects(r1, r2) 
	assert_equal(b[1][1], 0)
	assert_equal(b[1][2], 0)
	assert_equal(b[2][1], 0)
	assert_equal(b[2][2], 0)
end

tests['get_edge_intersect_counts.r1_above_r2.0x_0y'] = function()
	local r1 = { pos={x=0, y=2}, w=1, h=1}
	local r2 = { pos={x=0, y=0}, w=1, h=1}
	local ei = geom.get_edge_intersects(r1, r2) 
	local counts = geom.get_edge_intersect_counts(ei)
	assert_equal(counts.x, 0)
	assert_equal(counts.y, 0)
end

unittest.run_tests(tests)


-- cam_control.lua	:	translates input to camera transform

require('camera')
require('gamelib')

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

-- key mappings (multiple keys can map to the same cam state)
M.keymap = {
	[string.byte('F')] = {state='trans_x', val=-1},
	[string.byte('G')] = {state='trans_x', val=1},
	[string.byte('E')] = {state='trans_z', val=-1},
	[string.byte('D')] = {state='trans_z', val=1},
	[string.byte('H')] = {state='rot_y', val= 1},
	[string.byte('J')] = {state='rot_y', val=-1},
	[string.byte('I')] = {state='rot_x', val= 1},
	[string.byte('K')] = {state='rot_x', val=-1},
}

M.zero_cam_states = function(cam)
	cam.state['trans_x'] = 0
	cam.state['trans_y'] = 0
	cam.state['trans_z'] = 0
	cam.state['rot_x'] = 0
	cam.state['rot_y'] = 0
	cam.state['rot_z'] = 0
end

M.update = function(dt, cam)
--print("beg cam_control.update()")
	-- clear all cam states
	M.zero_cam_states(cam)

	-- for all key mappings, get state, update cam state
	for k, v in pairs(M.keymap) do
		local down = glfw.getKey(k) == glfw.GLFW_PRESS
--print(string.format("checking keydown for %s key, state=%s", k, tostring(glfw.getKey(k))))
		if down then
--print(string.format("got keydown for %s key, v.state: %s, v.val: %s", k, tostring(v.state), tostring(v.val)))
			cam.state[v.state] = v.val
		end
	end

	-- update cam
	camera.update(cam, dt)
end


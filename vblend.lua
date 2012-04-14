-- vblend.lua	:	a love child of vim and blender

-- global debug var
g_debug_state = ""

local modname = "vblend"
local M = {}
_G[modname] = M
package.loaded[modname] = M

require('gamelib')
require('graphics')
require('cam_control')
require('editor')
require('editor3d')
require('debugger')

--[[
	descrip:
		Applies keyboard inputs to camera movement.
]]
M.apply_inputs = function (dt, cam)
	cam_control.update(dt, cam)
end

--[[
	descrip:
		Shows help text for vblend app in editor.
]]
M.show_help = function ()
	-- load lines into help buffer
	edit_util.buf_load(M.help_buf, M.help_file)
	editor.set_active_buf(M.help_buf)
	M.showing_help = true
end

--[[
	descrip:
		Closes help text, returns to main view.
]]
M.close_help = function()
	M.showing_help = false
	editor.set_active_buf(M.status_buf)
end

--[[
	descrip:
		Draws a semi-transparent rectangle behind the editor text, for better visibility
		against the 3d background.

	notes:
		Currently, the background is sized to match the width and height of lines in the active 
		text buffer.
]]
M.draw_edit_bg = function()
	local win_w = gamelib.win_width()
  local win_h = gamelib.win_height()

	local b = editor.active_buf()
	local num_lines = buffer.count_lines(b)	
	local line_h = tfont.char_height()
	local txt_h = num_lines * line_h

  local b = 0
  local d = -0.1
  local s = 0.6
  local c = 0.3

	local x = 0
	local y = win_h - txt_h
	local w = win_w
	local h = txt_h
  gl.color4f(c, c, c, s)
  gl.Begin(gl.GL_QUADS)
    gl.vertex3f(x, y, d)
    gl.vertex3f(x + w, y, d)
    gl.vertex3f(x + w, y + h, d)
    gl.vertex3f(x, y + h, d)
  gl.End()
end

M.dump_active_buf = function()
	local b = editor.active_buf()
	print(buffer.tostring(b))
end

--[[
	descrip:
		Displays general-purpose status text in an editor window.
]]
M.status_out = function (txt)
	buffer.set(M.status_buf, txt, 0)
end

--[[
	descrip:
		Sets up lighting in opengl.
]]
function init_lighting()
	gl.enable(gl.GL_LIGHTING)
	gl.enable(gl.GL_LIGHT0)
	gl.enable(gl.GL_COLOR_MATERIAL)
--	gl.shadeModel(gl.GL_SMOOTH)
--	gl.shadeModel(gl.GL_FLAT)
end

--[[
	descrip:
		Program entry point, shows a 3D view with 2D text overlay.
]]
function main()
	gamelib.open_window()

	init_lighting()
	gl.enable(gl.GL_DEPTH_TEST)
  gl.enable(gl.GL_BLEND)
  gl.blendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)
	gl.enable(gl.GL_CULL_FACE)

	-- create help buffer
	M.help_file = "../docsrc/vblend.txt"
	local win_pos = {[0]=0, [1]=0}
	local win_size = {[0]=tfont.num_cols(), [1]=tfont.num_rows()-1}
	M.help_buf = buffer.new('help',  win_pos, win_size)

	-- create status buffer
	M.status_buf = buffer.new('status',  win_pos, win_size)

	editor.init()
	editor.options["tilde-display-lines"] = false
	editor.options['read-only'] = true
--	editor.options['draw-cursor'] = false
	cmd_mode.add_handler("h", M.show_help)
	cmd_mode.add_handler("clo", M.close_help)
	cmd_mode.add_handler("dump active_buf", M.dump_active_buf)
	glfw.setKeyCallback('key_event')
	editor.set_active_buf(M.status_buf)

	M.frame_count = 0

	local frame_time = 1/60
	M.cam = camera.new()
	M.cam.center = vector3.new(0, 10, 30)

	local done = false
	while not done do
		M.frame_count = M.frame_count + 1

		local beg_time = sys.double_time()

		-- update gamelib
		gamelib.update()

		-- update editor
		editor.tick()

		-- update 3d editor
		editor3d.tick()

		-- determine input state
		editor.options['draw-cursor'] = false
		local editor_has_keyboard = false
		if editor.get_mode() == "command" or M.showing_help then
			editor_has_keyboard = true
			editor.options['draw-cursor'] = true
		end

		-- get navigation input
		if not editor_has_keyboard then
	  	M.apply_inputs(frame_time, M.cam)
		end

		-- status update
--		M.status_out(string.format("frame count: %d", frame_count))

		-- render at end of game loop

		-- draw 3d
		gamelib.set_perspective()
		gl.loadIdentity()
		gl.clear(gl.GL_COLOR_BUFFER_BIT)
		gl.clear(gl.GL_DEPTH_BUFFER_BIT)

		-- set camera
		local eye_pos = M.cam.center
		local cen_pos = vector3.add(eye_pos, M.cam.look_dir)
		local up_dir = M.cam.up_dir
		glu.lookAt(eye_pos.x, eye_pos.y, eye_pos.z, cen_pos.x, cen_pos.y, cen_pos.z, up_dir.x, up_dir.y, up_dir.z)
--		M.draw_grid()
--		M.draw_cursor3d()
		editor3d.draw()

		-- ortho drawing
		gamelib.set_ortho()
		gl.loadIdentity()

		-- draw editor
		M.draw_edit_bg() -- draw semi-transparent background behind edit text
		editor.draw()

		-- check for gl errors
		local err = gl.getError()
		if err ~= gl.GL_NO_ERROR then
			print(string.format("GL error: %s", glu.errorString(err)))
		end

		-- sleep
		local end_time = sys.double_time()
		local work_time = end_time - beg_time
		local sleep_time = frame_time - work_time
		sleep_time = math.max(0, sleep_time)
		sys.usleep(sleep_time * 1e6)
	end
end

function quit()
	os.exit(0)
end

main()

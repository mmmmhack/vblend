-- vblend.lua	:	a love child of vim and blender

g_debug_state = ""

local M = {}

require('gamelib')
require('cam_control')
require('editor')
require('debugger')

--local _init_line = string.rep("0123456789", 7) .. "012345678"

--[[
	descrip:
		Draws a wireframe grid in the x-z plane, centered at the origin.
]]
M.draw_grid = function ()
	local c = 0.3
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
		Applies keyboard inputs to camera movement.
]]
M.apply_inputs = function (dt, cam)
	cam_control.update(dt, cam)
end

M.show_help = function ()
--	cmd_mode.set_text("")

--[[
	-- read lines into active buffer
	local b = editor.active_buf()
	buffer.remove_all(b)
	local i = 0
	for line in io.lines(M.help_file) do
		-- convert tabs to spaces
		local ln = string.gsub(line, "\t", "    ")
		buffer.insert_line(b, ln, i)
		i = i + 1
	end
--]]
	-- load lines into help buffer
	edit_util.buf_load(M.help_buf, M.help_file)
	editor.set_active_buf(M.help_buf)
	M.showing_help = true
end

M.close_help = function()
--[[
	local b = editor.active_buf()
	buffer.remove_all(b)
	buffer.insert_line(b, "", 0)
--]]
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
		Draws a 3d cursor.
]]
M.draw_cursor3d = function()
	gl.pushMatrix()
		gl.rotatef(90, 0, 1, 0)
		gl.color3f(1, 0, 0)
		gamelib.draw_circle_wireframe(0, 0, 1.0)
	gl.popMatrix()

	gl.pushMatrix()
		gl.rotatef(90, -1, 0, 0)
		gl.color3f(0, 1, 0)
		gamelib.draw_circle_wireframe(0, 0, 1.0)
	gl.popMatrix()

	gl.pushMatrix()
		gl.color3f(0, 0, 1)
		gamelib.draw_circle_wireframe(0, 0, 1.0)
	gl.popMatrix()
end

--[[
	descrip:
		Displays general-purpose status text in an editor window.
]]
M.status_out = function (txt)
--	local b = editor.active_buf()	
	buffer.set(M.status_buf, txt, 0)
end

--[[
	descrip:
		Program entry point, shows a 3D view with 2D text overlay.
]]
function main()
	gamelib.open_window()

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

  gl.enable(gl.GL_BLEND)
  gl.blendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)

	local frame_count = 0
	local frame_time = 1/60
	local cam = camera.new()
	cam.center = vector3.new(0, 10, 30)

	local done = false
	while not done do
		frame_count = frame_count + 1
		local beg_time = sys.double_time()

		-- update gamelib
		gamelib.update()

		-- update editor inputs
		editor.tick()

		--[[
		-- TODO: determine whether status or help buffer should be shown
		local editor_has_keyboard = false
		local scrollable_text = false 
		local num_lines = buffer.count_lines(editor.active_buf())
		if num_lines > tfont.num_rows() then
			scrollable_text = true
		end
		-- TODO: check for longest line
		if editor.get_mode() == "command" or scrollable_text then
			editor_has_keyboard = true
			editor.options['draw-cursor'] = true
		else
			editor.options['draw-cursor'] = false
		end
		--]]

		-- set editor state
		editor.options['draw-cursor'] = false
		local editor_has_keyboard = false
		if editor.get_mode() == "command" or M.showing_help then
			editor_has_keyboard = true
			editor.options['draw-cursor'] = true
		end

		-- get navigation input
		if not editor_has_keyboard then
	  	M.apply_inputs(frame_time, cam)
		end

		-- status update
		M.status_out(string.format("frame count: %d", frame_count))

		-- render at end of game loop

		-- draw 3d
		gamelib.set_perspective()
		gl.loadIdentity()

		local eye_pos = cam.center
		local cen_pos = vector3.add(eye_pos, cam.look_dir)
		local up_dir = cam.up_dir
		glu.lookAt(eye_pos.x, eye_pos.y, eye_pos.z, cen_pos.x, cen_pos.y, cen_pos.z, up_dir.x, up_dir.y, up_dir.z)
		M.draw_grid()
		M.draw_cursor3d()

		-- ortho drawing
		gamelib.set_ortho()
		gl.loadIdentity()

		-- draw semi-transparent background behind edit text
		M.draw_edit_bg()

		-- draw editor
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

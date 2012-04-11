-- vblend.lua	:	a love child of vim and blender

local M = {}

require('gamelib')
require('cam_control')
require('editor')
require('debugger')

local _init_line = string.rep("0123456789", 7) .. "012345678"

M.draw_grid = function ()
	gl.color3f(0, 1, 0)
	gl.Begin(gl.GL_LINES)
		local y = -10

		local zb = -200
		local ze = -10

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

M.set_ortho = function ()
	local w = gamelib.win_defaults.width
	local h = gamelib.win_defaults.height
  -- set default ortho project
	gl.matrixMode(gl.GL_PROJECTION)
	gl.loadIdentity()
	gl.ortho(0, w, 0, h, -1, 1)
	gl.matrixMode(gl.GL_MODELVIEW)
	gl.loadIdentity()
end

M.set_perspective = function ()
	gl.matrixMode(gl.GL_PROJECTION)
	gl.loadIdentity()
	local w = gamelib.win_width()
	local h = gamelib.win_height()
	local l = -w/2
	local r = w/2
	local b = -h/2
	local t =  h/2
	local n = 0.1
	local f = 1000
	glu.perspective(60, w/h, n, f)
	gl.matrixMode(gl.GL_MODELVIEW)
end

M.apply_inputs = function (dt, cam)
	cam_control.update(dt, cam)
end

M.show_help = function ()
	cmd_mode.set_text("")

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
--editor.debug_state = "buffer.draw"
end

M.close_help = function()
	local b = editor.active_buf()
	buffer.remove_all(b)
	buffer.insert_line(b, "", 0)
--editor.debug_state = "help closed"
end

function draw_edit_bg()
  local w = gamelib.win_width()
  local h = gamelib.win_height()
  local b = 0
  local d = -0.1
  local s = 0.6
  local c = 0.3
  gl.color4f(c, c, c, s)
  gl.Begin(gl.GL_QUADS)
    gl.vertex3f(0, 0, d)
    gl.vertex3f( w, 0, d)
    gl.vertex3f( w,  h, d)
    gl.vertex3f( 0,  h, d)
  gl.End()
end

function main()
	gamelib.open_window()

	M.help_file = "../docsrc/vblend.txt"

	editor.init()
	editor.options["tilde-display-lines"] = false
	editor.options['read-only'] = true
--	editor.options['draw-cursor'] = false
	cmd_mode.add_handler("h", M.show_help)
	cmd_mode.add_handler("clo", M.close_help)
	glfw.setKeyCallback('key_event')

  gl.enable(gl.GL_BLEND)
  gl.blendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)

	local frame_time = 1/60
	local cam = camera.new()
	local done = false
	while not done do
		local beg_time = sys.double_time()

		gl.loadIdentity()

		-- draw 3d
		local eye_pos = cam.center
		local cen_pos = vector3.add(eye_pos, cam.look_dir)
		local up_dir = cam.up_dir
		glu.lookAt(eye_pos.x, eye_pos.y, eye_pos.z, cen_pos.x, cen_pos.y, cen_pos.z, up_dir.x, up_dir.y, up_dir.z)

		M.set_perspective()
		M.draw_grid()

		-- get editor draw state
		local editor_active = false
		local editor_text = buffer.count_chars(editor.active_buf()) > 0
		if editor.get_mode() == "command" or editor_text then
			editor_active = true
		end

		-- draw semi-transparent background behind edit text
		M.set_ortho()
		if editor_text then
			draw_edit_bg()
		end

		-- draw editor
		editor.draw()

		-- update gamelib
		gamelib.update()

		-- update editor inputs
		editor.tick()

		-- get navigation input
		editor.options['draw-cursor'] = editor_active
		if not editor_active then
	  	M.apply_inputs(frame_time, cam)
		end

		-- check for exit
--		local esc_key_hit = glfw.getKey(glfw.GLFW_KEY_ESC) == glfw.GLFW_PRESS
--		done = gamelib.window_closed() or esc_key_hit

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

-- editor.lua	:	test editor application
local M = {}
local modname = 'editor'
_G[modname] = M
package.loaded[modname] = M

-- gamelib
require "gamelib"
require "lua_tfont"
require "lua_edit"
require "util"

-- editor modules
require "keycodes"
require "cursor"
require "win"
require "buffer"
require "normal_mode"
require "insert_mode"
require "cmd_mode"

require "debugger"

local fps = 60
local frame_time = 1/fps
local keydown_time = nil
local keydown_key = nil
local key_autorepeat_first_delay = 1 / 2
local key_autorepeat_rate = 1 / 10
local key_autorepeat_interval = key_autorepeat_first_delay

local modes = {'normal', 'insert', 'command'}
local mode = 'normal'

local lshift_key_down = false
local rshift_key_down = false

--local _active_buf = nil
--local _cmd_buf = nil
local _editor = nil

-- TODO: modularize this file
local _init_line = string.rep("0123456789", 7) .. "012345678"

M.set_mode = function(m)
	mode = m
end

M.set_active_buf = function(b)
	M.editor._active_buf = b
end

M.active_buf = function()
	return M.editor._active_buf
end

-- called at module load
M.init = function()
	local w = tfont.num_cols()
	local h = tfont.num_rows()
	M.editor = {}

	-- create first buffer
	M.editor._active_buf = buffer.new("active", {[0]=0, [1]=0}, {[0]=w, [1]=h-1})
	
	buffer.set(M.editor._active_buf, _init_line)

	-- create cmd-line buffer
	M.editor._cmd_buf = buffer.new("cmd", {[0]=0, [1]=h-1}, {[0]=w, [1]=1})
	cmd_mode.buf = M.editor._cmd_buf

end

-- called periodically by the app
-- maps the glfw keycode in shift state to the ascii code
M.tick = function()
--	print("lua tick!")
	if keydown_time == nil then
		return
	end
	-- do key autorepeat
	local cur_time = sys.double_time()
	local diff_time = cur_time - keydown_time
	if diff_time > key_autorepeat_interval then
	  key_autorepeat_interval = key_autorepeat_rate
		keydown_time = cur_time

		local ch = M.glfw_key_toascii(keydown_key)
		M.char_pressed(ch)
	end
end

M.shift_key_event = function(k, state)
	local b = state == GLFW_PRESS and true or false
	if k == GLFW_KEY_LSHIFT then
		lshift_key_down = b
	elseif k == GLFW_KEY_RSHIFT then
		rshift_key_down = b
	else
		return false
	end
	return true
end

M.is_shift_key_down = function()
	return lshift_key_down or rshift_key_down
end

-- combine glfw key code + current shift state to produce ascii value of param key
M.glfw_key_toascii = function(k)

--print("k: " .. k)
	-- 'printable' keycodes are mapped with string keys
	local kc
	if k < 256 then
		kc = string.char(k)
	-- the rest are mapped with numeric keys
	else
		kc = k
	end

	-- get ascii char from keycode and shift state
	local ascii_ch
	if M.is_shift_key_down() then
		ascii_ch = shifted_keycode[kc]
		-- some ascii chars (bs, tab, ret, etc.) only have unshifted mapping
		if ascii_ch == nil then
			ascii_ch = unshifted_keycode[kc]
		end
	else
		ascii_ch = unshifted_keycode[kc]
	end

	-- debug
	if false then
		s = string.format("k: %d, shift: %s, char(k): %s", 
			k, 
			tostring(M.is_shift_key_down()),
			string.char(k)
		)
		print(s)
		print("trans(k): " .. transcode)
	end

	return ascii_ch
end

-- called from the app on key input event
-- wknight 2011-12-07: currently this function needs to be global, because of 
-- requirements/limitations in glfw.setKeyCallback()
key_event = function(k, state)
--print(string.format("key_event(): k: [%s], state: [%s]", tostring(k), tostring(state)))
	
	-- record shift key state
	if M.shift_key_event(k, state) then
		return
	end

	local ch = M.glfw_key_toascii(k)

	if state == GLFW_RELEASE then
		-- if current keydown key was released, clear keydown key
		if k == keydown_key then
			keydown_key = nil
			keydown_time = nil
		  key_autorepeat_interval = key_autorepeat_first_delay
		end
		return
	end

	-- set new keydown key for autorepat
	keydown_key = k
	keydown_time = sys.double_time()
  key_autorepeat_interval = key_autorepeat_first_delay

	-- handle keydown action
	if ch ~= nil then
		M.char_pressed(ch)
	end
end

-- char code: just returns param ch for now
M.cc = function(ch)
	return ch
end

M.char_pressed = function(ch)
	-- ch = keymap(ch)
	if 		 mode == 'normal' then
		normal_mode.char_pressed(ch)
	elseif mode == 'command' then
		cmd_mode.char_pressed(ch)
	elseif mode == 'insert' then
		insert_mode.char_pressed(ch)
	else
	  print("unknown mode: " .. tostring(mode))	
	end
end

M.draw = function()
--print("BEG tf_edit.lua draw()")
--traceback()
--debug_console()
	if M.editor._active_buf.redraw then
		buffer.draw(M.editor._active_buf)
	end
	if M.editor._cmd_buf.redraw then
		buffer.draw(M.editor._cmd_buf)
	end
	tfont.draw_text_buf()
	edit.draw_cursor()
--print("END tf_edit.lua draw()")
end

M.main = function()
	M.init()
	gamelib.open_window("test editor")
	glfw.setKeyCallback('key_event')

	local run = true
	while run do
		-- beg frame
		local beg_time = sys.double_time()

		M.tick()
		M.draw()

		-- end frame
		gamelib.update()
		if gamelib.window_closed() then
			run = false
		end
		local end_time = sys.double_time()
		local wrk_time = end_time - beg_time
		local slp_time = frame_time - wrk_time
		slp_time = math.max(0, slp_time)
		sys.usleep(slp_time * 1e6)
	end
end

M.quit = function()
	os.exit(0)
end

--debug_console()
M.main()


-- editor.lua	:	test editor application
local M = {}
local modname = ...
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
require "edit_util"

require "debugger"

local keydown_time = nil
local keydown_key = nil
local key_autorepeat_first_delay = 1 / 2
local key_autorepeat_rate = 1 / 10
local key_autorepeat_interval = key_autorepeat_first_delay

local modes = {'normal', 'insert', 'command'}
local mode = 'normal'

local lshift_key_down = false
local rshift_key_down = false

M.set_mode = function(m)
	mode = m
end

M.get_mode = function(m)
	return mode
end

M.set_active_buf = function(b)
	M._active_buf = b
end

M.active_buf = function()
	return M._active_buf
end

-- called at module load
M.init = function()
	
	M.debug_state = ""	-- global debug var
	M.key_count = 0			-- tracks number of input chars, for triggering debug conditions

	local w = tfont.num_cols()
	local h = tfont.num_rows()

	-- create first buffer
	M._active_buf = buffer.new("active", {[0]=0, [1]=0}, {[0]=w, [1]=h-1})

	-- create cmd-line buffer
	M._cmd_buf = buffer.new("cmd", {[0]=0, [1]=h-1}, {[0]=w, [1]=1})
	cmd_mode.buf = M._cmd_buf

	M.options = {
		["tilde-display-lines"] = true,
		["read-only"] = false,	-- sets flag disabling editing actions for active buffer
		["draw-cursor"] = true,	-- enables display of cursor
	}
end

--[[
	descrip:
		Heartbeat function, called periodically by the app. Currently just used for
		key input stuff:
			- key autorepeat
			- maps the glfw keycode in shift state to the ascii code
			- calls main key handler: char_pressed()
]]
M.tick = function()
	-- 
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

--[[
	descrip: main key input handler
]]
M.char_pressed = function(ch)
	-- update debug helper var
	M.key_count = M.key_count + 1

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
	if M._active_buf.redraw then
		buffer.draw(M._active_buf)
	end
	if M._cmd_buf.redraw then
		buffer.draw(M._cmd_buf)
	end
	tfont.draw_text_buf()
	if M.options['draw-cursor'] then
		edit.draw_cursor()
	end
--print("END tf_edit.lua draw()")
end



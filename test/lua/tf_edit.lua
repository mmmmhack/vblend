require "tflua"

package.path = package.path .. ';./lua/?.lua'
require "util"
require "keycodes"
--require "line_buf"
require "cursor"
require "win"
require "buffer"
require "normal_mode"
require "insert_mode"
require "cmd_mode"

local keydown_time = nil
local keydown_key = nil
local key_autorepeat_first_delay = 1 / 2
local key_autorepeat_rate = 1 / 10
local key_autorepeat_interval = key_autorepeat_first_delay

local modes = {'normal', 'insert', 'command'}
local mode = 'normal'

local lshift_key_down = false
local rshift_key_down = false

local _active_buf = nil
local _cmd_buf = nil

function set_mode(m)
	mode = m
end

function set_active_buf(b)
	_active_buf = b
end

function active_buf()
	return _active_buf
end

-- called at module load
function init()
	local w = tflua.num_screen_cols()
	local h = tflua.num_screen_rows()

	-- create first buffer
	_active_buf = buffer.new({[0]=0, [1]=0}, {[0]=w, [1]=h-1})
	
	local ln = string.rep("0123456789", 7) .. "012345"
	buffer.set(_active_buf, ln)
--	line_buf.set(ln)

	-- create cmd-line buffer
	_cmd_buf = buffer.new({[0]=0, [1]=h-1}, {[0]=w, [1]=1})
	cmd_mode.buf = _cmd_buf
end

-- called periodically by the app
-- maps the glfw keycode in shift state to the ascii code
function tick()
--	print("lua tick!")
	if keydown_time == nil then
		return
	end
	-- do key autorepeat
	local cur_time = tflua.get_time()
	local diff_time = cur_time - keydown_time
	if diff_time > key_autorepeat_interval then
	  key_autorepeat_interval = key_autorepeat_rate
		keydown_time = cur_time

		local ch = glfw_key_toascii(keydown_key)
		char_pressed(ch)
	end
end

function shift_key_event(k, state)
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

function is_shift_key_down()
	return lshift_key_down or rshift_key_down
end

-- combine glfw key code + current shift state to produce ascii value of param key
function glfw_key_toascii(k)

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
	if is_shift_key_down() then
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
			tostring(is_shift_key_down()),
			string.char(k)
		)
		print(s)
		print("trans(k): " .. transcode)
	end

	return ascii_ch
end

-- called from the app on key input event
function key_event(k, state)
--print(string.format("key_event(): k: [%s], state: [%s]", tostring(k), tostring(state)))
	
	-- record shift key state
	if shift_key_event(k, state) then
		return
	end

	local ch = glfw_key_toascii(k)

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
	keydown_time = tflua.get_time()
  key_autorepeat_interval = key_autorepeat_first_delay

	-- handle keydown action
	if ch ~= nil then
		char_pressed(ch)
	end
end

-- char code: just returns param ch for now
function cc(ch)
	return ch
end

function char_pressed(ch)
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

function draw()
	if _active_buf.redraw then
		buffer.draw(_active_buf)
	end
	if _cmd_buf.redraw then
		buffer.draw(_cmd_buf)
	end
end

init()


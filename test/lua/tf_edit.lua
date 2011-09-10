require "tflua"

--package.path = package.path .. ';./lua/?.lua'
require "lua.keycodes"
require "lua.cmd_line"
require "lua.cursor"

keydown_time = nil
keydown_key = nil
key_autorepeat_first_delay = 1 / 2
key_autorepeat_rate = 1 / 10
key_autorepeat_interval = key_autorepeat_first_delay

modes = {'normal', 'insert', 'command'}
mode = 'normal'

lshift_key_down = false
rshift_key_down = false

-- called periodically by the app
-- maps the glfw keycode in shift state to the ascii code
function tick()
--	print("lua tick!")
	if keydown_time == nil then
		return
	end
	-- do key autorepeat
	cur_time = tflua.get_time()
	diff_time = cur_time - keydown_time
	if diff_time > key_autorepeat_interval then
	  key_autorepeat_interval = key_autorepeat_rate
		keydown_time = cur_time

		ch = glfw_key_toascii(keydown_key)
		char_pressed(ch)
	end
end

function shift_key_event(k, state)
	b = state == GLFW_PRESS  and true or false
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
	if k < 256 then
		kc = string.char(k)
	-- the rest are mapped with numeric keys
	else
		kc = k
	end

	-- get ascii char from keycode and shift state
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
--print("k: " .. k .. ", state: " .. state)
	
	-- record shift key state
	if shift_key_event(k, state) then
		return
	end

	ch = glfw_key_toascii(k)

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
	char_pressed(ch)
end

--function kc(s)
--	return string.byte(s,1)
--end

-- char code: just returns param ch for now
function cc(ch)
	return ch
end

function char_pressed_normal(ch)
	-- movement
	if ch == cc('h') then
		dir = -1
	elseif ch == cc('l') then
		dir = 1
	-- command mode
	elseif ch == cc(':') then
		mode = 'command'
		-- show command prompt
--		bot_row = tflua.num_screen_rows() - 1
		row = cmd_line_row()
		tflua.set_screen_buf(row, 0, ': ')
		tflua.set_cursor(row, 1)
		return
	-- undefined
	else
		print("normal mode: undefined ch: " .. ch)
		return
	end
--	row, col = tflua.get_cursor();
--	tflua.set_cursor(row, col + dir);
	cursor.inc(dir)
end

function char_pressed_insert(ch)
end

function char_pressed(ch)
	-- ch = keymap(ch)
	if 		 mode == 'normal' then
		char_pressed_normal(ch)
	elseif mode == 'command' then
		char_pressed_command(ch)
	elseif mode == 'insert' then
		char_pressed_insert(ch)
	else
	  print("unknown mode")	
	end
end


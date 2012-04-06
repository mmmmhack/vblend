-- insert_mode.lua
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

local debug_count = 0

-- position in line buf where insertion started (limit of backspacing)
M.insert_beg_pos = nil

-- begin insert-mode
M.begin = function (mode_ch)

	-- inc cursor
	if mode_ch == editor.cc('a') then
		M.inc_cursor(1)
	-- insert line
	elseif mode_ch == editor.cc('o') then
		M.open_line()
	end

	-- get insert pos
	M.insert_beg_pos = M.insert_pos()

	-- set insert status on cmd-line
	cmd_mode.set_text("-- INSERT --")
end

-- returns pos in line_buf under cursor
M.insert_pos = function()
	local pos = editor.active_buf().cursor_pos
	return {[0]=pos[0], [1]=pos[1]}
end

-- increments cursor in horiz dir by one char
M.inc_cursor = function(n)
	buffer.inc_cursor(editor.active_buf(), n)
end

M.open_line = function(n)
--	buffer.inc_cursor(editor.active_buf(), n)

  local cursor_pos = buffer.get_cursor(editor.active_buf())
	buffer.insert_line(editor.active_buf(), "", cursor_pos[1] + 1)

	-- update cursor
	cursor_pos[0] = 0
	cursor_pos[1] = cursor_pos[1] + 1
	buffer.set_cursor(editor.active_buf(), cursor_pos)

--local b = editor.active_buf()	
--print(string.format("  at end insert_mode.open_line(): buffer.tostring(b):\n%s", buffer.tostring(b)))
--print(string.format("end insert_mode.open_line()"))
end

M.get_line = function()
	local ln = buffer.get(editor.active_buf()).text
	return ln
end

M.set_line = function(ln)
	buffer.set(editor.active_buf(), ln)
end

M.char_pressed = function(ch)

local b = editor.active_buf()	
--if buffer.count_lines(b) > 1 then
--print(string.format("beg insert_mode.char_pressed(): b: %s", buffer.tostring(b)))
--	editor.debug_state = "blines > 1, char_pressed"
--end

--tflua.set_debug()
local fname = string.format("insert_mode.char_pressed-beg-%s-%d.buffer-dump.txt", ch, debug_count)
--debug_count = debug_count + 1
--buffer.dump(active_buf(), fname)

	-- exit mode
	if ch == ASC_ESC then
		-- cmd-line 'insert' status
		cmd_mode.set_text("")
		M.inc_cursor(-1)
		editor.set_mode("normal")
	-- erase prev input text char, up to insertion pos 
	elseif ch == ASC_BS then
		-- dec cursor
	-- append ch
	elseif util.isprintable(ch) then
		-- insert char into line buf at cursor pos
		local ins_pos = M.insert_pos()
		local ins_col = ins_pos[0]
		local ln = M.get_line()
		local ln_pre = string.sub(ln, 1, ins_col)
		local ln_pst = string.sub(ln, ins_col + 1)
--print(string.format("cusor_pos: %s, ins_pos: %d, ln: [%s], ln_pre: [%s], ch: [%s], ln_pst: [%s]", cursor_pos, ins_pos, lni, ln_pre, ch, ln_pst)
		local new_ln = ln_pre .. ch .. ln_pst
		M.set_line(new_ln)
		-- inc cursor
		M.inc_cursor(1)
	-- unknown input
	else
	end
--buffer.draw(active_buf())
--local fname = string.format("insert_mode.char_pressed-end-%s-%d.buffer-dump.txt", ch, debug_count)
--debug_count = debug_count + 1
--buffer.dump(active_buf(), fname)

end




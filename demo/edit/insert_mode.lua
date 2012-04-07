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
	M.insert_beg_pos = M.get_cursor()

	-- set insert status on cmd-line
	cmd_mode.set_text("-- INSERT --")
end

-- returns pos in line_buf under cursor
M.get_cursor = function()
--	local pos = editor.active_buf().cursor_pos
	local pos = buffer.get_cursor(editor.active_buf())
	return {[0]=pos[0], [1]=pos[1]}
end

M.set_cursor = function(pos)
	buffer.set_cursor(editor.active_buf(),pos)
end

-- increments cursor in horiz dir by one char
M.inc_cursor = function(n)
	buffer.inc_cursor(editor.active_buf(), n)
end

-- increments cursor in horiz dir by one char
M.inc_cursor_y = function(n)
	buffer.inc_cursor_y(editor.active_buf(), n)
end

-- appends a new line in text buffer just below current line
M.open_line = function(n)

  local cursor_pos = M.get_cursor()
	buffer.insert_line(editor.active_buf(), "", cursor_pos[1] + 1)

	-- update cursor
	cursor_pos[0] = 0
	cursor_pos[1] = cursor_pos[1] + 1
	buffer.set_cursor(editor.active_buf(), cursor_pos)

end

M.get_line = function()
	local ln = buffer.get(editor.active_buf()).text
	return ln
end

M.set_line = function(ln)
	buffer.set(editor.active_buf(), ln)
end

-- splits line at param pos into 3 pieces and returns them: (line_pre, ch, line_post)
M.split_line = function(pos)
	local ln = M.get_line(pos[1])
--[[
	local ln_pre = string.sub(ln, 1, pos[0]-1 + 1) -- convert from 0-based to 1-based
	local ch = string.sub(ln, pos[0] + 1, pos[0] + 1)
	local ln_pst = string.sub(ln, pos[0] + 1 + 1)
	return ln_pre, ch, ln_pst
]]
	return edit_util.split_line(ln, pos[0])
end

M.char_pressed = function(ch)
	-- exit mode
	if ch == ASC_ESC then
		-- cmd-line 'insert' status
		cmd_mode.set_text("")
		M.inc_cursor(-1)
		editor.set_mode("normal")
	-- erase prev input text char, up to insertion pos 
	elseif ch == ASC_BS then
		-- delete prev char if any, dec cursor

		-- remove char before cursor pos, if any
		local rm_pos = M.get_cursor()
		local rm_col = rm_pos[0] - 1
		if rm_col >= 0 then
			local ln = M.get_line()
			local ln_pre = string.sub(ln, 1, rm_col-1 + 1) -- convert from 0-based to 1-based
			local ln_pst = string.sub(ln, rm_col + 1 + 1)
	--print(string.format("cusor_pos: %s, ins_pos: %d, ln: [%s], ln_pre: [%s], ch: [%s], ln_pst: [%s]", cursor_pos, ins_pos, lni, ln_pre, ch, ln_pst)
			local new_ln = ln_pre .. ln_pst
			M.set_line(new_ln)
			-- dec cursor
			M.inc_cursor(-1)
		end
	elseif ch == ASC_RET then
--		local ln_pre = string.sub(ln, 1, rm_col-1 + 1) -- convert from 0-based to 1-based
--		M.open_line()

		-- split line at cursor
		local cursor_pos = M.get_cursor()
		local ln_pre, ch, ln_pst = M.split_line(cursor_pos)
		M.set_line(ln_pre)

		-- insert rest of line below cursor
		buffer.insert_line(editor.active_buf(), ch .. ln_pst, cursor_pos[1] + 1)

		-- move cursor to beginning of next line
		M.set_cursor({[0]=0, [1]=cursor_pos[1]+1})

	-- append ch
	elseif util.isprintable(ch) then
		-- insert char into line buf at cursor pos
		local ins_pos = M.get_cursor()
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
end




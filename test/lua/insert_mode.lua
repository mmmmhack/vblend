-- insert_mode.lua
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

-- position in line buf where insertion started (limit of backspacing)
M.insert_beg_pos = nil

-- begin insert-mode
M.begin = function (mode_ch)

	-- inc cursor
	if mode_ch == cc('a') then
		M.inc_cursor(1)
	end

	-- get insert pos
	M.insert_beg_pos = M.insert_pos()

	-- set insert status on cmd-line
	cmd_mode.set_text("-- INSERT --")
end

-- returns pos in line_buf under cursor
M.insert_pos = function()
--[[
	local cursor_pos = cursor.get_pos()
--print("M.insert_pos() BEG")
--util.ptable(cursor_pos)
	scroll_pos = win.scroll_pos()
	hscroll = scroll_pos[2]
	col = cursor_pos[2] + hscroll
	return col
--]]
	local pos = active_buf().cursor_pos
	return {[0]=pos[0], [1]=pos[1]}
end

M.inc_cursor = function(n)
	buffer.inc_cursor(active_buf(), n)
end

M.get_line = function()
	local ln = buffer.get(active_buf())
	return ln
end

M.set_line = function(ln)
	buffer.set(active_buf(), ln)
end

M.char_pressed = function(ch)
tflua.set_debug()
	-- exit mode
	if ch == ASC_ESC then
		-- cmd-line 'insert' status
		cmd_mode.set_text("")
		M.inc_cursor(-1)
		set_mode("normal")
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
end




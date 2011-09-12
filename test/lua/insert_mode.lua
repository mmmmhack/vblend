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
		cursor.inc(1)
	end

	-- get insert pos
	M.insert_beg_pos = M.insert_pos()

	-- set insert status on cmd-line
	cmd_mode.set_text("-- INSERT --")
end

-- returns pos in line_buf under cursor
M.insert_pos = function()
	cursor_pos = cursor.get_pos()
--print("M.insert_pos() BEG")
--util.ptable(cursor_pos)
	scroll_pos = win.scroll_pos()
	hscroll = scroll_pos[2]
	col = cursor_pos[2] + hscroll
	return col
end

M.char_pressed = function(ch)
	-- exit mode
	if ch == ASC_ESC then
		cmd_mode.erase_cmd_line()
		cursor.inc(-1)
		set_mode("normal")
	elseif ch == ASC_BS then
		-- erase prev input text char, up to insertion pos 
		-- dec cursor
		-- scroll if needed
	elseif util.isprintable(ch) then
		-- insert char into line buf at cursor pos
		ins_pos = M.insert_pos()
		ln = line_buf.get()
		ln_pre = string.sub(ln, 1, ins_pos)
		ln_pst = string.sub(ln, ins_pos+1)
--print(string.format("cusor_pos: %s, ins_pos: %d, ln: [%s], ln_pre: [%s], ch: [%s], ln_pst: [%s]", cursor_pos, ins_pos, lni, ln_pre, ch, ln_pst)
		new_ln = ln_pre .. ch .. ln_pst
		line_buf.set(new_ln)
		-- inc cursor
		cursor.inc(1)
		-- scroll if needed
	else
	end
end




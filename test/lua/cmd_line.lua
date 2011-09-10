-- cmd_line.lua	: editor command-line routines

cmd_line_buf = ''

function cmd_line_row()
	bot_row = tflua.num_screen_rows() - 1
	return bot_row
end

function cmd_line_update_scr()
	row = cmd_line_row()
	tflua.set_screen_buf(row, 0, ':' .. cmd_line_buf)
end

function char_pressed_command(ch)
--print("cmd_line: char_pressed_command(): ch: [" .. ch .. "]")

	if 		  ch == cc(ASC_BS) then
		if #cmd_line_buf == 0 then
			do return end
		end
		cmd_line_buf = string.sub(cmd_line_buf, 1, #cmd_line_buf - 1) .. " "
		cmd_line_update_scr()
		cmd_line_buf = string.sub(cmd_line_buf, 1, #cmd_line_buf - 1)
		cmd_line_update_scr()
		cursor.inc(-1)

	elseif ch == cc(ASC_RET) then
		-- clear cmd-line
		cmd = cmd_line
		cmd_line = ""
		cmd_line_update_scr()
		-- move cursor back to prev pos
		-- TODO: save cursor pos in mode-switch
		cursor.set_pos(cursor.saved_pos)
		-- TODO: erase cmd-line
		-- TODO: process command
		
		-- TODO: call set-new-mode function
		mode = "normal"
	else
		-- append ch to cmd-line
		cmd_line_buf = cmd_line_buf .. ch
		-- update screen
--		row = cmd_line_row()
--		tflua.set_screen_buf(row, 0, ':' .. cmd_line_buf)
		cmd_line_update_scr()
		-- update cursor
		cursor.inc(1)
	end

end



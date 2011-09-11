-- cmd_mode.lua	: command-line mode routines
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.cmd_line_buf = ''
M.cmd_handler = {
}

-- returns screen row of cmd line
M.cmd_line_row  = function ()
	bot_row = tflua.num_screen_rows() - 1
	return bot_row
end

-- begin command-mode
M.begin = function ()
	-- save current cursor pos
	cursor.saved_pos = cursor.get_pos()

	-- show command prompt
	M.erase_cmd_line()
	M.cmd_line_buf = ":"
	M.update_scr()
	tflua.set_cursor(row, 1)
end

-- updates cmd_line row in screen buffer with current contents of cmd_line_buf
M.update_scr = function ()
	row = M.cmd_line_row()
	tflua.set_screen_buf(row, 0, M.cmd_line_buf)
end

-- erases current cmd line on screen
M.erase_cmd_line = function()
	M.cmd_line_buf = string.rep(" ", #M.cmd_line_buf)
	M.update_scr()
	M.cmd_line_buf = ""
end

-- shows err msg for invalid cmd
M.not_a_cmd = function(cmd)
	M.cmd_line_buf = "Error: not a command: " .. cmd
	M.update_scr()
end

-- handles cmd entered from cmd-line
M.do_cmd = function(cmd)
	if #cmd == 0 then
		do return end
	end
	h = M.cmd_handler[cmd]
	if h == nil then
		M.not_a_cmd(cmd)	
	end
end

-- handles keyboard character input during command-line mode
M.char_pressed = function (ch)
--print("cmd_line: char_pressed_command(): ch: [" .. ch .. "]")

	-- backspace
	if 		  ch == cc(ASC_BS) then
		if #M.cmd_line_buf <= 1 then
			do return end
		end
		M.cmd_line_buf = string.sub(M.cmd_line_buf, 1, #M.cmd_line_buf - 1) .. " "
		M.update_scr()
		M.cmd_line_buf = string.sub(M.cmd_line_buf, 1, #M.cmd_line_buf - 1)
		M.update_scr()
		cursor.inc(-1)

	-- enter
	elseif ch == cc(ASC_RET) then
		-- get cmd
		cmd = string.sub(M.cmd_line_buf, 2) 

		-- erase cmd-line
		M.erase_cmd_line()

		-- move cursor back to prev pos
		cursor.set_pos(cursor.saved_pos)

		-- process command
		M.do_cmd(cmd) 
		
		set_mode("normal")
	else
		-- append ch to cmd-line
		M.cmd_line_buf = M.cmd_line_buf .. ch
		-- update screen
		M.update_scr()

		-- update cursor
		cursor.inc(1)
	end

end -- char_pressed



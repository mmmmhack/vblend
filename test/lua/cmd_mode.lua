-- cmd_mode.lua	: command-line mode routines
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

--M.cmd_line_buf = ''
M.buf = nil 	-- TODO: replace with better init
M.saved_buf = nil

-- cmd handlers
M.quit = function()
	tflua.quit()
end

M.cmd_handler = {
	['quit'] = M.quit,
}

--[[
-- returns screen row of cmd line
M.cmd_line_row  = function ()
	bot_row = tflua.num_screen_rows() - 1
	return bot_row
end
--]]

-- begin command-mode
M.begin = function ()
--	M.saved_buf = active_buf()
	-- save current cursor pos
--	cursor.saved_pos = M.buf.cursor_pos()

	-- show command prompt
--	M.erase_cmd_line()
	buffer.set(M.buf, ":")
--	M.update_scr()
--	tflua.set_cursor(row, 1)
	local col = 1
	local row = 0
	buffer.set_cursor(M.buf, {[0]=col, [1]=row})
end

--[[
-- updates cmd_line row in screen buffer with current contents of cmd_line_buf
M.update_scr = function ()
	row = M.cmd_line_row()
	tflua.set_screen_buf(row, 0, M.cmd_line_buf)
end
--]]

-- erases current cmd line on screen
--[[
M.erase_cmd_line = function()
	blank_ln = string.rep(" ", #M.cmd_line_buf)
--	M.update_scr()
	M.cmd_line_buf = ""
end
--]]

-- shows err msg for invalid cmd
M.not_a_cmd = function(cmd)
	M.buf.set("Error: not a command: " .. cmd)
--	M.update_scr()
end

-- public function to set cmd-line text, for when it's used as a status line
M.set_text = function(s)
--	M.erase_cmd_line()
	M.buf.set(s, 0)
--	M.update_scr()
end

-- handles cmd entered from cmd-line
M.do_cmd = function(cmd)
	if #cmd == 0 then
		do return end
	end
	local h = M.cmd_handler[cmd]
	if h == nil then
		M.not_a_cmd(cmd)	
	end
	h(cmd)
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
		M.buf.inc_cursor(-1)

	-- enter
	elseif ch == cc(ASC_RET) then
		-- get cmd
		local cmd = string.sub(M.cmd_line_buf, 2) 

		-- erase cmd-line
--		M.erase_cmd_line()

		-- move cursor back to prev pos
		M.buf.set_cursor(cursor.saved_pos)

		-- process command
		M.do_cmd(cmd) 
		
		set_mode("normal")
	else
		-- append ch to cmd-line
		M.buf.set(M.buf.get() .. ch)

		-- update cursor
		M.buf.inc_cursor(1)
	end

end -- char_pressed



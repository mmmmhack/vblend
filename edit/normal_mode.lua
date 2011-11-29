-- normal_mode.lua	:	normal mode editing routines
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.op_count_buf = ""
M.op_count_max = 10
M.op_count_col = tflua.num_screen_cols() - M.op_count_max
--M.buf = nil -- TODO: replace with better init

--[[
M.update_scr = function()
	row = cmd_mode.cmd_line_row()
	col = M.op_count_col
	tflua.set_screen_buf(row, col, M.op_count_buf)
end
--]]

M.clear_op_count = function()
	M.op_count_buf = string.rep(" ", #M.op_count_buf)
	M.op_count_buf = ""
	cmd_mode.set_text(M.op_count_buf) 
end

-- returns current op count value
M.op_count = function()
	if #M.op_count_buf == 0 then
		do return 1 end
	end
	return tonumber(M.op_count_buf)
end

-- adds param digit to op_count
M.update_op_count = function(ch)
	if #M.op_count_buf == M.op_count_max then
		do return end
	end
	M.op_count_buf = M.op_count_buf .. ch
	-- set cmd-line text starting at op_count column
	local ln = string.rep(" ", M.op_count_col) .. M.op_count_buf
	cmd_mode.set_text(ln) 
end

-- does cursor movement
M.move_horiz = function(dir)
	local b = active_buf()

	n = dir * M.op_count()
	-- clamp to line
	ln = buffer.get(b)
	final_col = math.max(0, #ln - 1)
	cur_pos = b.cursor_pos
	cur_col = cur_pos[0]
	cur_row = cur_pos[1]
	new_col = cur_col + n
	new_col = math.min(final_col, new_col)
	new_col = math.max(0, new_col)
--print(string.format("normal_mode.move_horiz(): n: %d, cur_col: %d, new_col: %d", n, cur_col, new_col))
	new_pos = { [0]=new_col, [1]=cur_row}
	buffer.set_cursor(b, new_pos)
	M.clear_op_count()
end

-- handles key input for normal mode
M.char_pressed = function (ch)
	local b = active_buf()
	local ln = buffer.get(b)
	-- movement
	if ch == cc('h') then
		M.move_horiz(-1)
	elseif ch == cc('l') then
		M.move_horiz(1)
	elseif ch == cc('$') then
		M.move_horiz(#ln)
	-- count
	elseif util.isdigit(ch) then
		M.update_op_count(ch)
	-- insert mode
	elseif ch == cc('i') or ch == cc('a') then
		set_mode('insert')
		insert_mode.begin(ch)
	-- command mode
	elseif ch == cc(':') then
		set_mode('command')
		cmd_mode.begin()
		return
	-- undefined
	else
--		print("normal mode: undefined ch: " .. ch)
	end
end



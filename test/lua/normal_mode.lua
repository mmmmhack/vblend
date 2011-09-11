-- normal_mode.lua	:	normal mode editing routines
local M = {}
modname = ...
_G[modname] = M
package.loaded[modname] = M

M.op_count_buf = ""
M.op_count_max = 10
M.op_count_col = tflua.num_screen_cols() - M.op_count_max

M.update_scr = function()
	row = cmd_mode.cmd_line_row()
	col = M.op_count_col
	tflua.set_screen_buf(row, col, M.op_count_buf)
end

M.clear_op_count = function()
	M.op_count_buf = string.rep(" ", #M.op_count_buf)
	M.update_scr()
	M.op_count_buf = ""
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
	M.update_scr()
end

-- does cursor movement
M.move_horiz = function(dir)
	n = dir * M.op_count()
	-- clamp to line
	ln = line_buf.get()
	final_col = math.max(0, #ln - 1)
	cur_pos = cursor.get_pos()
	cur_row = cur_pos[1]
	cur_col = cur_pos[2]
	new_col = cur_col + n
	new_col = math.min(final_col, new_col)
	new_col = math.max(0, new_col)
--print(string.format("normal_mode.move_horiz(): n: %d, cur_col: %d, new_col: %d", n, cur_col, new_col))
	cursor.set_pos({cur_row, new_col})
	M.clear_op_count()
end

-- handles key input for normal mode
M.char_pressed = function (ch)
	-- movement
	if ch == cc('h') then
		M.move_horiz(-1)
	elseif ch == cc('l') then
		M.move_horiz(1)
	-- count
	elseif isdigit(ch) then
		M.update_op_count(ch)
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



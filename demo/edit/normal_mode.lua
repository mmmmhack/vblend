-- normal_mode.lua	:	normal mode editing routines
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.op_count_buf = ""
M.op_count_max = 10
M.op_count_col = tfont.num_cols() - M.op_count_max

M.clear_op = function()
	M.op_count_buf = string.rep(" ", #M.op_count_buf)
	M.op_count_buf = ""
	M.pending_op = ""
	cmd_mode.set_text("")
end

M.pending_op = ""

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
	M.update_pending_op()
end

M.update_pending_op = function()
	-- set cmd-line text starting at op_count column
	local ln = string.rep(" ", M.op_count_col) .. M.pending_op .. M.op_count_buf
	cmd_mode.set_text(ln) 
end

-- does horizontal cursor movement
M.move_horiz = function(count)
	local b = editor.active_buf()

	-- clamp to line
	local ln = buffer.get(b).text
	local final_col = math.max(0, #ln - 1)
	local cur_pos = buffer.get_cursor(b)
	local cur_col = cur_pos[0]
	local cur_row = cur_pos[1]
	local new_col = cur_col + count
	new_col = math.min(final_col, new_col)
	new_col = math.max(0, new_col)
--print(string.format("normal_mode.move_horiz(): count: %d, cur_col: %d, new_col: %d", count, cur_col, new_col))
	local new_pos = { [0]=new_col, [1]=cur_row}
	buffer.set_cursor(b, new_pos)
--print(string.format("normal_mode.move_horiz(): set new cursor pos: %d, %d", new_pos[0], new_pos[1]))
	M.clear_op()
end

-- does vertical cursor movement
-- TODO: add 'at-end-of-line' flag
M.move_vert = function(count)
	local b = editor.active_buf()

	-- clamp to buffer
	local num_rows = buffer.count_lines(b)
	local final_row = math.max(0, num_rows - 1)
	local cur_pos = buffer.get_cursor(b)
	local cur_col = cur_pos[0]
	local cur_row = cur_pos[1]
	local new_row = cur_row + count
	new_row = math.min(final_row, new_row)
	new_row = math.max(0, new_row)
	-- must also clamp col to col that is min(cur_line_col, next_line_max_col)
	local new_col = cur_col
	local new_ln = buffer.get(b, new_row).text
	local final_col = math.max(0, #new_ln - 1)
	new_col = math.min(final_col, new_col)
	new_col = math.max(0, new_col)
	local new_pos = { [0]=new_col, [1]=new_row}
	buffer.set_cursor(b, new_pos)
	M.clear_op()
end

M.delete_lines = function()
	local b = editor.active_buf()
	local cur_pos = buffer.get_cursor(b)
	local cur_row = cur_pos[1]
	local num_remove = math.min(M.op_count(), buffer.count_lines(b) - cur_row)
	for i = 0, num_remove - 1 do
		buffer.remove_line(b, cur_row)
	end
	-- if no lines remain, insert a new empty line
	if buffer.count_lines(b) == 0 then
		buffer.insert_line(b, "", 0)
	end
	-- if cur_row no longer valid, adjust cursor
	if cur_row >= buffer.count_lines(b) then
		local new_cur_row = math.max(cur_row - 1, 0)
		buffer.set_cursor(b, edit_util.new_pos(0, new_cur_row)) 
	end
	M.clear_op()
end

-- handles key input for normal mode
M.char_pressed = function (ch)
--print(string.format("beg normal_mode.char_pressed(): ch: [%s]", tostring(ch)))
	local b = editor.active_buf()
	local line_buf = buffer.get(b)
if line_buf == nil then
debug_console()
end
	local ln = line_buf.text
	-- movement
	if ch == nil then
				-- holding down the 'command' key in osx can produce this, so just ignore it		
	-- clear pending ops
	elseif ch == ASC_ESC then
		M.clear_op()
	-- movement
	elseif ch == editor.cc('h') or ch == ASC_BS then
		M.move_horiz(-1 * M.op_count())
	elseif ch == editor.cc('l') then
		M.move_horiz(1 * M.op_count())
	elseif ch == editor.cc('$') then
		M.move_horiz(#ln)
	elseif ch == editor.cc('k') then
		M.move_vert(-1 * M.op_count())
	elseif ch == editor.cc('j') or ch == ASC_RET then
		M.move_vert(1 * M.op_count())
	-- count: add to op count _unless_ this is the first digit and 0, in which case move cursor to beg of line
	elseif util.isdigit(ch) then
		if #M.op_count_buf  == 0 and ch=='0' then
			M.move_horiz(- #ln)
		else
			M.update_op_count(ch)
		end
	-- insert mode
	elseif ch == editor.cc('i') or ch == editor.cc('a') or ch == editor.cc('o') then
		if not editor.options['read-only'] then
			editor.set_mode('insert')
			insert_mode.begin(ch)
		end
	-- command mode
	elseif ch == editor.cc(':') then
		editor.set_mode('command')
		cmd_mode.begin()
		return
	-- delete chars
	elseif ch == editor.cc('x') then
			M.delete_chars()
	-- delete lines
	elseif ch == editor.cc('d') then
		if M.pending_op == 'd' then
			M.delete_lines()
		else
			M.pending_op = "d"
			M.update_pending_op()
		end
	-- undefined
	else
--		print("normal mode: undefined ch: " .. ch)
	end
end



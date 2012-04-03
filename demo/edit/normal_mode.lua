-- normal_mode.lua	:	normal mode editing routines
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.op_count_buf = ""
M.op_count_max = 10
M.op_count_col = tfont.num_cols() - M.op_count_max

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
--M.move_horiz = function(dir)
M.move_horiz = function(count)
	local b = editor.active_buf()

--	local n = dir * M.op_count()
	-- clamp to line
	local ln = buffer.get(b)
	local final_col = math.max(0, #ln - 1)
	local cur_pos = b.cursor_pos
	local cur_col = cur_pos[0]
	local cur_row = cur_pos[1]
	local new_col = cur_col + count
	new_col = math.min(final_col, new_col)
	new_col = math.max(0, new_col)
--print(string.format("normal_mode.move_horiz(): n: %d, cur_col: %d, new_col: %d", n, cur_col, new_col))
	local new_pos = { [0]=new_col, [1]=cur_row}
	buffer.set_cursor(b, new_pos)
--print(string.format("normal_mode.move_horiz(): set new cursor pos: %d, %d", new_pos[0], new_pos[1]))
	M.clear_op_count()
end

-- handles key input for normal mode
M.char_pressed = function (ch)
	local b = editor.active_buf()
	local ln = buffer.get(b)
	-- movement
	if ch == nil then
		-- holding down the 'command' key in osx can produce this, so just ignore it		
	elseif ch == editor.cc('h') then
		M.move_horiz(-1 * M.op_count())
	elseif ch == editor.cc('l') then
		M.move_horiz(1 * M.op_count())
	elseif ch == editor.cc('$') then
		M.move_horiz(#ln)
	-- count: add to op count _unless_ this is the first digit and 0, in which case move cursor to beg of line
	elseif util.isdigit(ch) then
		if #M.op_count_buf  == 0 and ch=='0' then
			M.move_horiz(- #ln)
		else
			M.update_op_count(ch)
		end
	-- insert mode
	elseif ch == editor.cc('i') or ch == editor.cc('a') then
		editor.set_mode('insert')
		insert_mode.begin(ch)
	-- command mode
	elseif ch == editor.cc(':') then
		editor.set_mode('command')
		cmd_mode.begin()
		return
	-- undefined
	else
--		print("normal mode: undefined ch: " .. ch)
	end
end



-- buffer_insert_line.lua	:	tests buffer.insert_line()

require("buffer")
require("debugger")

edit = {
	set_cursor = function(x, y) 
	end,
}

function draw(b, descrip)
	buffer.update_display_lines(b)
	print(string.format("=========== %s:", descrip))
	local num_lines = buffer.count_lines(b) 
	for i = 0, num_lines - 1 do
		print(string.format("     line %d: [%s]", i, buffer.get(b, i).text))
	end
	for i = 0, num_lines - 1 do
		print(string.format("disp_line %d: [%s]", i, b.display_lines[i]))
	end
	print(string.format("cursor_pos: %s", edit_util.pos2str(b.cursor_pos)))
	print("\n")
end

function main()
	local win_pos = {[0] = 0, [1] = 0}
	local win_size = {[0] = 10, [1] = 10}
	local b = buffer.new('test', win_pos, win_size)
	buffer.set(b, '0123456789')
	draw(b, "init")

	-- insert line
	buffer.insert_line(b, "", 1)
  local cursor_pos = buffer.get_cursor(b)
	cursor_pos[0] = 0
	cursor_pos[1] = cursor_pos[1] + 1
	buffer.set_cursor(b, cursor_pos)
--debug_console()
	draw(b, "aft insert_line()")

	-- append char
--	local ins_pos = M.insert_pos()
	local ins_pos = cursor_pos
	local ins_col = ins_pos[0]
--	local ln = M.get_line()
	local ch = 'a'
	local ln = buffer.get(b).text
	local ln_pre = string.sub(ln, 1, ins_col)
	local ln_pst = string.sub(ln, ins_col + 1)
	local new_ln = ln_pre .. ch .. ln_pst
--	M.set_line(new_ln)
	buffer.set(b, new_ln)
	buffer.inc_cursor(b, 1)
	draw(b, "aft append char")

end

main()

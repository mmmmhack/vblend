-- buffer_insert_newline.lua	:	tests buffer

--[[
repro bug observed in insert mode when ASC_RET is hit:

  1. create buffer with line '012345689'
	2. move cursor to '1'
	3. split line into (ln_pre, ch, ln_pst)
	4. set_line(ln_pre)
	5. insert_line(ch .. ln_pst, y+1)
	6. set_cursor(0, y+1)

]]
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
	-- create buffer
	local win_pos = {[0] = 0, [1] = 0}
	local win_size = {[0] = 10, [1] = 10}
	local b = buffer.new('test', win_pos, win_size)
	buffer.set(b, '0123456789')
	draw(b, "init")

	-- move cursor
	local pos = edit_util.new_pos(1, 0)
	buffer.set_cursor(b, pos)
	draw(b, "set_cursor to col 1, line 0")

	-- split line
--debug_console()
	local ln = buffer.get(b).text
	local ln_pre, ch, ln_pst = edit_util.split_line(ln, pos[0])

	-- set line
	buffer.set(b, ln_pre)
	draw(b, "set line")

	-- insert line
	buffer.insert_line(b, ch .. ln_pst, pos[1] + 1)
	draw(b, "insert line")

	-- set cursor
	local new_pos = edit_util.new_pos(0, pos[1]+1)
	buffer.set_cursor(b, new_pos)
	draw(b, "set cursor")

end

main()

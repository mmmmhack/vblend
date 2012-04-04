-- buffer_scroll_test.lua	:	scroll tests for edit/buffer.lua

require('buffer')

edit = {
	set_cursor = function(x, y) 
	end,
}

function draw(b, descrip)
	buffer.update_display_lines(b)
	print(string.format("=========== %s:", descrip))
	print(string.format("     line: '%s'", b.lines[0]))
	print(string.format("           +----------+"))
	print(string.format("disp_line: '%s',  scroll_pos: %d", b.display_lines[0], b.scroll_pos[0]))
--	print(string.format("   cursor: +c---------+"))
	local win_size = 10
	local pre = ""
	local mid = string.rep('-', win_size)
	local pst = ""
	local cpos = b.cursor_pos[0]
	if cpos < 0 then
		pre = 'c' .. string.rep(' ', (0 - cpos)-1)
	elseif cpos >= 0 and cpos <= win_size - 1 then
		mid = string.rep('-', cpos) .. 'c' .. string.rep('-', win_size - cpos - 1)
	else
		pst = string.rep(' ', cpos - win_size) .. 'c'
	end
	local crep = pre .. "+" .. mid .. "+" .. pst
	
	print(string.format("   cursor: %s", crep))
	print("\n")
end

function scroll_test()
	local win_pos = {[0] = 0, [1] = 0}
	local win_size = {[0] = 10, [1] = 1}
	local b = buffer.new('test', win_pos, win_size)
	buffer.set(b, '0123456789')
	draw(b, "init")

	-- move cursor to end
	local pos = {[0] = 9, [1] = 0}
	buffer.set_cursor(b, pos)
	draw(b, "aft set cursor at end")

	-- append char
	local line = buffer.get(b)
	line = line .. 'a'
	buffer.set(b, line)
	buffer.inc_cursor(b, 1)
	draw(b, "aft append char")

	-- move cursor back to beg
	local pos = {[0] = 0, [1] = 0}
	buffer.set_cursor(b, pos)
	draw(b, "aft move cursor to beg")

end

scroll_test()

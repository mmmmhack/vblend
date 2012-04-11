-- scroll_page.lua	:	page scroll test for edit/buffer.lua

require('buffer')

local win_height = 5

edit = {
	set_cursor = function(x, y) 
	end,
}
tfont = {
  num_rows = function() return win_height end,
  set_text_buf = function(x, y, ln) end,
}
editor = {
  options = {},
}

function draw(b, label)
  print(string.format("===== %s:\n%s", label, buffer.tostring(b))) 
end

function scroll_test()
	local win_pos = {[0] = 0, [1] = 0}
	local win_size = {[0] = 10, [1] = win_height}
	local b = buffer.new('test', win_pos, win_size)
  buffer.remove_all(b)
  local num_lines = 50
  for i = 0, num_lines - 1 do
    buffer.insert_line(b, tostring(i+1), i)
  end
  buffer.draw(b)
	draw(b, "init")

  -- scroll
--  buffer.set_cursor(b, edit_util.new_pos(0, num_lines - 1))
  buffer.set_cursor(b, edit_util.new_pos(0, win_height + 1))
  buffer.draw(b)
	draw(b, "page scroll")

end

scroll_test()

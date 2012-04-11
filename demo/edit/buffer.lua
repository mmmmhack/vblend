-- routines for working with text buffers
--[[

The buffer object has 2 buffers. The first is the 'lines' buffer which holds
the content (text). It has an unlimited number of lines, each with an unlimited 
number of characters.

The second is the 'display_lines' member, which is a fixed array of lines of
fixed length. This maps directly to a rectangle on the screen.

The horizontal and vertical scroll positions are used to define the position
of the left top corner of the 'display_lines' buffer relative to the 'lines' buffer.

After the scroll position is changed, update_display_lines() must be called
at some point to update the content of the 'display_lines' buffer with the correct 
content.  Currently, this is automatically done in a call to the 'draw()' function.
]]

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

require("edit_util")
require("buf_line")

-- returns an initialized buffer object
M.new = function(buffer_name, win_pos, win_size)
  local b = {}
	b.name = buffer_name
  b.lines_head = buf_line.new()
  b._cursor_pos = {[0]=0, [1]=0}		-- [0] is col_num (0-based index), [1] is line_num (0-based index)
  b.scroll_pos = {[0]=0, [1]=0}		-- used in buf2win()
  b.win_pos = {[0]=win_pos[0], [1]=win_pos[1]}
  b.win_size = {[0]=win_size[0], [1]=win_size[1]}
  b.redraw = false
--  b.update_all = true	-- optimization flag, triggers update of all lines in display_lines buffer if (v)scroll
  b.display_lines = {}
  local blank_ln = string.rep(' ', b.win_size[0])
	local num_lines = b.win_size[1]
  for i = 0, num_lines - 1 do
    b.display_lines[i] = blank_ln
  end
  return b
end

M.tostring = function(b)
	local s = ""
  s = s .. string.format("b.name: %s\n", b.name)
  s = s .. string.format("b.lines: len: %d\n", M.count_lines(b))
--  for i = 0, #b.lines do
	local line = b.lines_head
	local i = 0
	while line ~= nil do
--    s = s .. string.format("  [%2d]: '%s'\n", i, b.lines[i])
    s = s .. string.format("  [%2d]: '%s'\n", i, line.text)
		line = line.next_line
		i = i + 1
  end
  s = s .. string.format("b._cursor_pos: (%d, %d)\n", b._cursor_pos[0], b._cursor_pos[1])
  s = s .. string.format("b.scroll_pos: (%d, %d)\n", b.scroll_pos[0], b.scroll_pos[1])
  s = s .. string.format("b.win_pos: (%d, %d)\n", b.win_pos[0], b.win_pos[1])
  s = s .. string.format("b.win_size: (%d, %d)\n", b.win_size[0], b.win_size[1])
  s = s .. string.format("b.redraw: %s\n", tostring(b.redraw))
--  s = s .. string.format("b.update_all: %s\n", tostring(b.update_all))
  s = s .. string.format("b.display_lines: len: %d\n", #b.display_lines + 1)
  for i = 0, #b.display_lines do
    s = s .. string.format("  [%2d]: '%s'\n", i, b.display_lines[i])
  end
	return s
end

--[[
	descrip:
		converts buffer position to the position it occupies in the display window, after scroll offsets are applied
		scroll offsets are always positive and should cause the buffer text to display more to the left and up,
		compared to a scroll offset of 0

		example: buffer pos (10, 0) + scroll pos (1, 0) causes the 10th character of the first buffer line to
		appear at window pos (9, 0)
]]
M.buf2win = function(b, buf_pos)
  local wx = buf_pos[0] - b.scroll_pos[0]
  local wy = buf_pos[1] - b.scroll_pos[1]
  return {[0]=wx, [1]=wy}
end

--[[
	descrip:
		converts buffer display position to screen position by adding window pos offset of buffer
]]
M.win2scr = function(b, win_pos)
  local sx = win_pos[0] + b.win_pos[0]
  local sy = win_pos[1] + b.win_pos[1]
  return {[0]=sx, [1]=sy}
end

M.buf2scr = function (b, buf_pos)
  local win_pos = M.buf2win(b, buf_pos)
  return M.win2scr(b, win_pos)
end

-- adjusts cursor position on current cursor row, clamping as needed
M.inc_cursor = function(b, n)
  local x = b._cursor_pos[0] + n
  local y = b._cursor_pos[1] 

	local ln = M.get(b).text
	x = math.min(x, #ln)
	x = math.max(0, x)
  M.set_cursor(b, {[0]=x, [1]=y})
end

-- adjusts cursor position on current cursor row
M.inc_cursor_y = function(b, n)
  local x = b._cursor_pos[0] 
  local y = b._cursor_pos[1] 
  M.set_cursor(b, {[0]=(x), [1]=y+n})
end

--[[
	returns a copy of b._cursor_pos
]]
M.get_cursor = function (b)
	local pos = {[0] = b._cursor_pos[0], [1] = b._cursor_pos[1]}
	return pos
end

--[[
	set_cursor()

	descrip: sets cursor position in param buffer object and also on the screen
	params:
		pos:	type: table {[0]=x, [1]=y} where x, y are new values of b._cursor_pos

	notes:
		since the cursor should remain visible on the screen at all times, if the
		param position is off the screen, new b.scroll_pos should be calculated
		to bring it into visible region shown by b.display_lines.

]]
M.set_cursor = function (b, pos)

if pos == nil then
	debug_console()
end
	assert(pos[0] >= 0)
	assert(pos[1] >= 0)	
  b._cursor_pos[0] = pos[0]
  b._cursor_pos[1] = pos[1]

  -- get cursor pos in window
  local cursor_win_pos = M.buf2win(b, b._cursor_pos)

  -- calc scroll to ensure cursor visible in window
  -- x
  -- before min bound
  if cursor_win_pos[0] < 0 then
		b.scroll_pos[0] = b.scroll_pos[0] + cursor_win_pos[0]
  	b.redraw = true
  -- beyond max bound
  elseif cursor_win_pos[0] > (b.win_size[0] - 1) then
		b.scroll_pos[0] = b.scroll_pos[0] + (cursor_win_pos[0] - (b.win_size[0]-1))
  	b.redraw = true
  end

  -- y
  -- before min bound
  if cursor_win_pos[1] < 0 then
		b.scroll_pos[1] = b.scroll_pos[1] + cursor_win_pos[1]
  	b.redraw = true
  -- beyond max bound
  elseif cursor_win_pos[1] > (b.win_size[1] - 1) then
		b.scroll_pos[1] = b.scroll_pos[1] + (cursor_win_pos[1] - (b.win_size[1]-1))
  	b.redraw = true
  end

  -- use updated scroll pos to get cursor display pos
  cursor_win_pos = M.buf2win(b, b._cursor_pos)

  -- set the actual cursor position on the screen
  local scr_pos = M.win2scr(b, cursor_win_pos)
  edit.set_cursor(scr_pos[1], scr_pos[0])

end

--[[
	descrip:
		returns number of content lines in param buffer
	TODO: optimize with a cache var
]]
M.count_lines = function(b)
	local line = b.lines_head
	local i = 0
	while line ~= nil do
		i = i + 1
		line = line.next_line
  end
	return i
end

--[[ 
	descrip:
		returns number of chars in param buffer
]]
M.count_chars = function(b)
	local line = b.lines_head
	local i = 0
	while line ~= nil do
		i = i + #line.text
		line = line.next_line
  end
	return i
end

--[[
	descrip:
		returns buf_line at param line_num in b.lines

	params:
		[line_num]: type: number, descrip: 0-based index into b.lines linked list
								If nil, then default line will be returned. 
								Default line is at index b._cursor_pos[1].
	returns:
		buf_line: type: table 
		
	notes:
		if no buf_line at that index, nil is returned
]]

M.get = function(b, line_num)
  local line_num = line_num or b._cursor_pos[1]
	local i = 0
	local line = b.lines_head
	while line ~= nil do
		if i == line_num then
			return line
		end
		i = i + 1
		line = line.next_line
  end
	return nil
end

-- sets buffer text to param content, at param row or default 
M.set = function(b, content, row)
  local row = row or b._cursor_pos[1]
--  b.lines[row] = content
	local line = M.get(b, row)
	line.text = content
  b.redraw = true
end

--[[
	descrip:
		inserts param text in line buffer, before existing line at line_num, if any, 
		shifting existing line ahead in linked list.
	params:
		ln: type: string, descrip: content of new line to insert
		line_num: type: number, descrip: 0-based index of position where inserted

	returns:
		line: type: buf_line, descrip: buf_line at inserted pos or nil if no insertion

	notes:
		if line_num is negative or > num_lines, no insertion is done.
		if line_num == num_lines, line is appended at end
]]
M.insert_line = function(b, line_text, line_num)
	local num_lines = M.count_lines(b)
	if line_num == nil or line_num < 0 or line_num > num_lines then
		return nil
	end
	local new_line = buf_line.new(line_text)
	local prev_line = M.get(b, line_num - 1)
	if line_num == 0 or prev_line == nil then
		local old_head = b.lines_head
		b.lines_head = new_line
		new_line.next_line = old_head
	else
		new_line.next_line = prev_line.next_line
		prev_line.next_line = new_line
	end
--	b.update_all = true
	b.redraw = true
	return new_line
end

--[[
	descrip:
		removes param line at parm pos in line buffer.
	params:
		line_num: type: number, descrip: 0-based index of position where removed

	returns:
		line: type: string, descrip: text of line removed or nil if no removal

	notes:
		if line_num is negative or > num_lines, no removal is done.
]]
M.remove_line = function(b, line_num)
	local num_lines = M.count_lines(b)
	if line_num < 0 or line_num >= num_lines then
		return nil
	end
	local ln = M.get(b, line_num)
	-- no prev line: line is at head
	local prev_ln = M.get(b, line_num - 1)
	if line_num == 0 or prev_ln == nil then
		b.lines_head = ln.next_line
	-- hook prev to next
	else
		prev_ln.next_line = ln.next_line
	end
	b.redraw = true
	return ln.text
end

--[[
	descrip: removes all lines in buffer
]]
M.remove_all = function(b)
	b.lines_head = nil
	b.redraw = true
	b._cursor_pos = {[0]=0, [1]=0}
	b.scroll_pos = {[0]=0, [1]=0}
end

--[[
	descrip: 
		Builds display buffer from content of lines buffer and scroll offset.
		- All buffer lines in the range defined by the scroll offset should be
		  copied to the display buffer.
		- Any lines in the display buffer that haven't been overwritten by content lines
		  should be set to blank lines (or blank lines starting with '~' if tilde
			option set)
]]
M.update_display_lines = function(b)

	-- first, blank display buffer
	local ch = editor.options["tilde-display-lines"] and "~" or " "
  local blank_ln = ch .. string.rep(" ", b.win_size[0]-1)
  local j = 0
  for i = 0, #b.display_lines do
    b.display_lines[i] = blank_ln
	end

	-- get number of content lines in scroll range
  local beg_col = b.scroll_pos[0]
	local beg_line = b.scroll_pos[1]
	local num_content_lines = buffer.count_lines(b)
	local num_display_content_lines = num_content_lines - beg_line
	-- clamp to display height
	num_display_content_lines = math.min(num_display_content_lines, b.win_size[1])

	-- copy lines
	local end_line = beg_line + num_display_content_lines - 1
	local j = 0

	for i = beg_line, end_line do
		local ln_buf = buffer.get(b, i)
		local ln = ln_buf.text
    local end_col = math.min(#ln, beg_col + b.win_size[0])
    -- pad out the rest of the line to the end of the buffer window
    local pad = b.win_size[0] - (end_col - beg_col)
    local s = string.sub(ln, beg_col+1, end_col+1) .. string.rep(" ", pad)
    b.display_lines[j] = s
		j = j + 1
	end

end

--[[
	descrip:
		Updates screen buffer with current contents of b.display_lines buffer
]]
M.draw = function (b)

  if not b.redraw then
    do return end
  end

  M.update_display_lines(b)

  -- copy display_lines buffer to screen buffer
  local scr_col = b.win_pos[0]
  local scr_row = b.win_pos[1]
  for i = 0, #b.display_lines do
    local ln = b.display_lines[i]
    tfont.set_text_buf(scr_row + i, scr_col, ln)
  end
  b.redraw = false
end


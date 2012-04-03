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

-- returns an initialized buffer object
M.new = function(buffer_name, win_pos, win_size)
  local b = {}
	b.name = buffer_name
  b.lines = {[0]=""}
  b.cursor_pos = {[0]=0, [1]=0}
  b.scroll_pos = {[0]=0, [1]=0}		-- used in buf2win()
  b.win_pos = {[0]=win_pos[0], [1]=win_pos[1]}
  b.win_size = {[0]=win_size[0], [1]=win_size[1]}
  b.redraw = false
  b.scrolled = false	-- optimization flag, triggers update of all lines in display_lines buffer if (v)scroll
  b.display_lines = {}
  local blank_ln = string.rep(' ', b.win_size[0])
--  for i = 0, b.win_size[1] - 1 do
local num_lines = b.win_size[1]
  for i = 0, num_lines - 1 do
    b.display_lines[i] = blank_ln
  end
  return b
end

M.tostring = function(b)
	local s = ""
  s = s .. string.format("b.name: %s\n", b.name)
  s = s .. string.format("b.lines: len: %d\n", #b.lines)
  for i = 0, #b.lines do
    s = s .. string.format("  [%2d]: '%s'\n", i, b.lines[i])
  end
  s = s .. string.format("b.cursor_pos: (%d, %d)\n", b.cursor_pos[0], b.cursor_pos[1])
  s = s .. string.format("b.scroll_pos: (%d, %d)\n", b.scroll_pos[0], b.scroll_pos[1])
  s = s .. string.format("b.win_pos: (%d, %d)\n", b.win_pos[0], b.win_pos[1])
  s = s .. string.format("b.win_size: (%d, %d)\n", b.win_size[0], b.win_size[1])
  s = s .. string.format("b.redraw: %s\n", tostring(b.redraw))
  s = s .. string.format("b.scrolled: %s\n", tostring(b.scrolled))
  s = s .. string.format("b.display_lines: len: %d\n", #b.display_lines)
  for i = 0, #b.display_lines do
    s = s .. string.format("  [%2d]: '%s'\n", i, b.display_lines[i])
break
  end
	return s
end

-- converts buffer position to the position it occupies in the display window, after scroll offsets are applied
-- scroll offsets are always positive and should cause the buffer text to display more to the left and up,
-- compared to a scroll offset of 0
-- example: buffer pos (10, 0) + scroll pos (1, 0) causes the 10th character of the first buffer line to
--          appear at window pos (9, 0)
--
M.buf2win = function(b, buf_pos)
  local wx = buf_pos[0] - b.scroll_pos[0]
  local wy = buf_pos[1] - b.scroll_pos[1]
  return {[0]=wx, [1]=wy}
end

M.win2scr = function(b, win_pos)
  local sx = win_pos[0] + b.win_pos[0]
  local sy = win_pos[1] - b.win_pos[1]
  return {[0]=sx, [1]=sy}
end

M.buf2scr = function (b, buf_pos)
  local win_pos = M.buf2win(b, buf_pos)
  return M.win2scr(b, win_pos)
end

-- adjusts cursor position on current cursor row
M.inc_cursor = function(b, n)
  local x = b.cursor_pos[0] 
  local y = b.cursor_pos[1] 
  M.set_cursor(b, {[0]=(x + n), [1]=y})
end

--[[
	set_cursor()

	descrip: sets cursor position in param buffer object and also on the screen
	params:
		pos:	type: table {[0]=x, [1]=y} where x, y are new values of b.cursor_pos

	notes:
		since the cursor should remain visible on the screen at all times, if the
		param position is off the screen, new b.scroll_pos should be calculated
		to bring it into visible region shown by b.display_lines.

]]
M.set_cursor = function (b, pos)
--print(string.format("beg buffer.set_cursor(): pos: (%d, %d)", pos[0], pos[1]))
  b.cursor_pos[0] = pos[0]
  b.cursor_pos[1] = pos[1]

  -- get cursor pos in window
  local cursor_win_pos = M.buf2win(b, b.cursor_pos)

  -- calc scroll to ensure cursor visible in window
  -- x
  -- before min bound
  if cursor_win_pos[0] < 0 then
		b.scroll_pos[0] = b.scroll_pos[0] + cursor_win_pos[0]
    b.scrolled = true
  	b.redraw = true
  -- beyond max bound
  elseif cursor_win_pos[0] > (b.win_size[0] - 1) then
		b.scroll_pos[0] = b.scroll_pos[0] + (cursor_win_pos[0] - (b.win_size[0]-1))
    b.scrolled = true
  	b.redraw = true
  end

--DEBUG
--print(string.format("after calc scroll: b.scroll_pos[0]: %d", b.scroll_pos[0]))
  -- set scroll flag
--  if dx then
--    b.scrolled = true
--  end
  -- y: TODO: implement by making above a loop

  -- use updated scroll pos to get cursor display pos
  cursor_win_pos = M.buf2win(b, b.cursor_pos)

  -- set the actual cursor position on the screen
  local scr_pos = M.win2scr(b, cursor_win_pos)
  edit.set_cursor(scr_pos[1], scr_pos[0])

--print(string.format("end buffer.set_cursor(): scr_pos: %s, b.scroll_pos: %s", 
--	edit_util.pos2str(scr_pos), edit_util.pos2str(b.scroll_pos)))
end

-- returns buffer text at param row or default 
M.get = function(b, row)
  local row = row or b.cursor_pos[1]
  return b.lines[row]
end

-- sets buffer text to param content, at param row or default 
M.set = function(b, content, row)
  local row = row or b.cursor_pos[1]
  b.lines[row] = content
  b.redraw = true
end

-- builds display buffer from content of lines buffer and scroll offset
M.update_display_lines = function(b)
--if(b.name == "active") then
--	print("beg buffer.update_display_lines()")
--end
  local dis_col = b.win_pos[0]
  local dis_row = b.win_pos[1]
  local beg_col = b.scroll_pos[0]

  -- default: only draw cursor line
  local beg_row = --[[ b.scroll_pos[1] + --]] b.cursor_pos[1]
  local end_row = beg_row
  -- update all lines in window if scrolled
  if b.scrolled then
    beg_row = b.scroll_pos[1]
    end_row = math.max(#b.lines - 1, beg_row + b.win_size[1] - 1)
  end
  local blank_ln = string.rep(" ", b.win_size[1])
  local j = 0
  for i = beg_row, end_row do
    local ln = blank_ln
    if i <= #b.lines then
      ln = b.lines[i]
    end       
    local end_col = math.min(#ln, beg_col + b.win_size[0])
    -- for now: pad out the rest of the line to the end of the buffer window. later, maybe optimize?
    local pad = b.win_size[0] - (end_col - beg_col)
    local s = string.sub(ln, beg_col+1, end_col+1) .. string.rep(" ", pad)
--    tflua.set_screen_buf(scr_row, scr_col, s)
    b.display_lines[j] = s
    j = j + 1
    dis_row = dis_row + 1
  end
--if(b.name == "active") then
--	print(M.tostring(b))
--	print("end buffer.update_display_lines()")
--end
end

-- updates screen buffer with current contents of b.display_lines buffer
M.draw = function (b)
  if not b.redraw then
    do return end
  end
--if(b.name == "active") then
--	print("beg buffer.draw()")
--end
  M.update_display_lines(b)
  -- copy display_lines buffer to screen buffer
  local scr_col = b.win_pos[0]
  local scr_row = b.win_pos[1]
  for i = 0, #b.display_lines do
    local ln = b.display_lines[i]
    tfont.set_text_buf(scr_row + i, scr_col, ln)
  end
  b.redraw = false
  b.scrolled = false
--print(string.format("buffer after at end of draw():\n%s", M.tostring(b)))
--if(b.name == "active") then
--	print("end buffer.draw()")
--end
end


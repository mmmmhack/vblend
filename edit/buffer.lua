-- routines for working with text buffers
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

-- returns an initialized buffer object
M.new = function(win_pos, win_size)
  local b = {}
  b.lines = {[0]=""}
  b.cursor_pos = {[0]=0, [1]=0}
  b.scroll_pos = {[0]=0, [1]=0}
  b.win_pos = {[0]=win_pos[0], [1]=win_pos[1]}
  b.win_size = {[0]=win_size[0], [1]=win_size[1]}
  b.redraw = false
  b.scrolled = false
  b.display_lines = {}
  local blank_ln = string.rep(' ', b.win_size[0])
--  for i = 0, b.win_size[1] - 1 do
local num_lines = b.win_size[1]
  for i = 0, num_lines - 1 do
    b.display_lines[i] = blank_ln
  end
  return b
end

M.dump = function(b, outfile)
  local fh = io.open(outfile, 'w')
  fh:write(string.format("b.lines: len: %d\n", #b.lines))
  for i = 0, #b.lines do
    fh:write(string.format("  [%2d]: '%s'\n", i, b.lines[i]))
  end
  fh:write(string.format("b.cursor_pos: (%d, %d)\n", b.cursor_pos[0], b.cursor_pos[1]))
  fh:write(string.format("b.scroll_pos: (%d, %d)\n", b.scroll_pos[0], b.scroll_pos[1]))
  fh:write(string.format("b.win_pos: (%d, %d)\n", b.win_pos[0], b.win_pos[1]))
  fh:write(string.format("b.win_size: (%d, %d)\n", b.win_size[0], b.win_size[1]))
  fh:write(string.format("b.redraw: %s\n", tostring(b.redraw)))
  fh:write(string.format("b.scrolled: %s\n", tostring(b.scrolled)))
  fh:write(string.format("b.display_lines: len: %d\n", #b.display_lines))
  for i = 0, #b.display_lines do
    fh:write(string.format("  [%2d]: '%s'\n", i, b.display_lines[i]))
  end
end

-- converts buffer position to the position it occupies in the display window, after scrol offsets are applied
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

M.set_cursor = function (b, pos)
  b.cursor_pos[0] = pos[0]
  b.cursor_pos[1] = pos[1]

  -- get pos in window
  local win_pos = M.buf2win(b, b.cursor_pos)

  -- calc scroll to ensure cursor visible in window
  local dx = 0
  -- x
  -- before min bound
  if win_pos[0] < 0 then
    dx = 0 - win_pos[0]
  -- beyond max bound
  elseif win_pos[0] > b.win_size[0] - 1 then
    dx = win_pos[0] - (b.win_size[0] - 1)     --TODO: fix no! if beyond max bound, we need _positive_ scroll value to shift into bound! (cursor pos: 80, win size: 80, 80 - 80 - 1 = -1, need +1
    -- TODO: fix: if buf cursor_pos[0] is 80 and scroll_pos[0] is 1 then win cursor_pos[0] should be 79
  end
  b.scroll_pos[0] = b.scroll_pos[0] + dx
  -- set scroll flag
  if dx then
    b.scrolled = true
  end
--]]
  -- y: TODO: implement by making above a loop

  -- now, re-apply scroll pos to cursor pos
  win_pos = M.buf2win(b, b.cursor_pos)

  -- set the actual cursor position on the screen
  local scr_pos = M.win2scr(b, win_pos)
--print(string.format("buffer.set_cursor(): calling tflua.set_cursor(%d, %d)", scr_pos[1], scr_pos[0]))
  tflua.set_cursor(scr_pos[1], scr_pos[0])
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
--  error("not implemented")
  local dis_col = b.win_pos[0]
  local dis_row = b.win_pos[1]
  local beg_col = b.scroll_pos[0]

  -- default: only draw cursor line
  local beg_row = --[[ b.scroll_pos[1] + --]] b.cursor_pos[1]
  local end_row = beg_row
  -- redraw all lines in window if scrolled
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
end

-- updates screen buffer with current contents of b.display_lines buffer
M.draw = function (b)
  if not b.redraw then
    do return end
  end
--[[
  local scr_col = b.win_pos[0]
  local scr_row = b.win_pos[1]
  local beg_col = b.scroll_pos[0]

  -- default: only draw cursor line
  local beg_row = b.cursor_pos[1]
  local end_row = beg_row
  -- redraw all lines in window if scrolled
  if b.scrolled then
    beg_row = b.scroll_pos[1]
    end_row = math.max(#b.lines - 1, beg_row + b.win_size[1] - 1)
  end
  local blank_ln = string.rep(" ", b.win_size[1])
  for i = beg_row, end_row do
    local ln = blank_ln
    if i <= #b.lines then
      ln = b.lines[i]
    end       
    local end_col = math.min(#ln, beg_col + b.win_size[0])
    -- for now: pad out the rest of the line to the end of the buffer window. later, maybe optimize?
    local pad = b.win_size[0] - (end_col - beg_col)
    local s = string.sub(ln, beg_col, end_col) .. string.rep(" ", pad)
    tflua.set_screen_buf(scr_row, scr_col, s)
    scr_row = scr_row + 1
  end
--]]
  M.update_display_lines(b)
  -- copy display_lines buffer to screen buffer
  local scr_col = b.win_pos[0]
  local scr_row = b.win_pos[1]
  for i = 0, #b.display_lines do
    local ln = b.display_lines[i]
    tflua.set_screen_buf(scr_row + i, scr_col, ln)
  end
  b.redraw = false
  b.scrolled = false
end

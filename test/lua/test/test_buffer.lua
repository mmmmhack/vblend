-- test_buffer.lua  : unit tests for buffer.lua
--
-- test naming: method_condition_expectedResult
package.path = package.path .. ';../?.lua'
require('tf_debug')
require('util')
require('buffer')
require('testutil')

local assert_equal = testutil.assert_equal
local compare_lines = testutil.compare_lines

-- stubs
tflua = {}
tflua.set_cursor = function(row, col)
end

-- tests
local tests = {}

tests['new_p0x0s80x34_pos0x0size80x34'] = function()
  local ncols = 80
  local nrows = 34
  local wpos = {[0]=0, [1]=0}
  local wsize = {[0]=ncols, [1]=nrows}
  local b = buffer.new(wpos, wsize)
  assert_equal(b.win_pos[0], 0)
  assert_equal(b.win_pos[1], 0)
end

tests['new_p0x0s80x34_displayLinesAllBlank'] = function()
  local ncols = 80
  local nrows = 34
  local wpos = {[0]=0, [1]=0}
  local wsize = {[0]=ncols, [1]=nrows}
  local b = buffer.new(wpos, wsize)
  local exp_lines = {}
  local ln = string.rep(" ", ncols)
  for i = 0, nrows-1 do
    exp_lines[i] = ln
  end
  compare_lines(b.display_lines, exp_lines)
end

tests['set_testLineLen80_displayLinesTestLineAndBlanks'] = function()
  local ncols = 80
  local nrows = 34
  local wpos = {[0]=0, [1]=0}
  local wsize = {[0]=ncols, [1]=nrows}
  local b = buffer.new(wpos, wsize)
  local exp_lines = {}
  local test_line = string.rep("0123456789", 8) 
  buffer.set(b, test_line)

  exp_lines[0] = test_line
  local blank_ln = string.rep(" ", ncols)
  for i = 1, nrows-1 do
    exp_lines[i] = blank_ln
  end
  buffer.update_display_lines(b)
  compare_lines(b.display_lines, exp_lines)
end

tests['setScrollPos_testLine80ScrollPos01_display79andBlank'] = function()
--debug_console()
  local ncols = 80
  local nrows = 34
  local wpos = {[0]=0, [1]=0}
  local wsize = {[0]=ncols, [1]=nrows}
  local b = buffer.new(wpos, wsize)
  local exp_lines = {}
  local test_line = string.rep("0123456789", 8) 
  buffer.set(b, test_line)
--  buffer.inc_cursor(b, 1)
  b.scroll_pos[0] = 1
  buffer.update_display_lines(b)

  -- check cursor pos
  assert_equal(b.scroll_pos[0], 1)
  assert_equal(b.scroll_pos[1], 0)

  -- check display_lines
  local first_exp_line = string.rep("0123456789", 8)
  first_exp_line = string.sub(first_exp_line, 2) .. " " 
  exp_lines[0] = first_exp_line 
  local blank_ln = string.rep(" ", ncols)
  for i = 1, nrows-1 do
    exp_lines[i] = blank_ln
  end
  buffer.update_display_lines(b)
  compare_lines(b.display_lines, exp_lines)
end

tests['incCursor_testLine80CursorPos79_display79andBlank'] = function()
--debug_console()
  local ncols = 80
  local nrows = 34
  local wpos = {[0]=0, [1]=0}
  local wsize = {[0]=ncols, [1]=nrows}
  local b = buffer.new(wpos, wsize)
  local exp_lines = {}
  local test_line = string.rep("0123456789", 8) 
  buffer.set(b, test_line)
  b.cursor_pos[0] = 79
  buffer.inc_cursor(b, 1)
  buffer.update_display_lines(b)

  -- check cursor pos
  assert_equal(b.scroll_pos[0], 1)
  assert_equal(b.scroll_pos[1], 0)

  -- check display_lines
  local first_exp_line = string.rep("0123456789", 8)
  first_exp_line = string.sub(first_exp_line, 2) .. " " 
  exp_lines[0] = first_exp_line 
  local blank_ln = string.rep(" ", ncols)
  for i = 1, nrows-1 do
    exp_lines[i] = blank_ln
  end
  buffer.update_display_lines(b)
  compare_lines(b.display_lines, exp_lines)
end

tests['buf2win_buf10x0scl1x0_win9x0'] = function()
  local ncols = 80
  local nrows = 34
  local wpos = {[0]=0, [1]=0}
  local wsize = {[0]=ncols, [1]=nrows}
  local b = buffer.new(wpos, wsize)
  b.scroll_pos[0] = 1
  local buf_pos = {[0]=10, [1]=0}
  local win_pos = buffer.buf2win(b, buf_pos)
  local exp_win_pos = {[0]=9, [1]=0}
  assert_equal(win_pos[0], exp_win_pos[0])
  assert_equal(win_pos[1], exp_win_pos[1])
end

tests['incCursor_endOfWin_lineScrollCursorStillAtEndOfWin'] = function()
  local ncols = 80
  local nrows = 34
  local wpos = {[0]=0, [1]=0}
  local wsize = {[0]=ncols, [1]=nrows}
  local b = buffer.new(wpos, wsize)
  local test_line = string.rep("0123456789", 8) .. "0"
  b.cursor_pos[0] = 79
  buffer.inc_cursor(b, 1)

  assert_equal(b.scroll_pos[0], 1)
  assert_equal(b.cursor_pos[0], 80)
end

testutil.run_tests(tests)


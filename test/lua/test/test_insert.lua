-- test_insert.lua  : unit tests for text insertion

-- test naming: method_condition_expectedResult
package.path = package.path .. ';../?.lua'
require('tf_debug')
require('testutil')
require('util')
require('buffer')
require('insert_mode')

local assert_equal = testutil.assert_equal
local compare_lines = testutil.compare_lines

local _active_buf = nil

-- stubs
tflua = {}
tflua.set_cursor = function(row, col)
end

function active_buf()
	return _active_buf
end

function cc(ch)
	return ch
end

cmd_mode = {}
cmd_mode.set_text = function ()
end

-- tests
local tests = {}

tests['insChar_cursorEndOfLine_hscrollCursorEndOfLine'] = function()
  local ncols = 80
  local nrows = 34
  local wpos = {[0]=0, [1]=0}
  local wsize = {[0]=ncols, [1]=nrows}
  local b = buffer.new(wpos, wsize)
  local test_line = string.rep('0123456789', 8)
  buffer.set(b, test_line)
  b.cursor_pos[0] = 79
  _active_buf = b
  insert_mode.begin('a')
  insert_mode.char_pressed('0')

  assert_equal(b.cursor_pos[0], 81)
  assert_equal(b.scroll_pos[0], 2)
  -- cursor pos in buffer should be 81, cursor pos in window should be 80
  -- scroll pos is 2, at space (pos 81)
end

tests['insChar_prevInsEndOfLine_hscrollCursorEndOfLine'] = function()
  local ncols = 80
  local nrows = 34
  local wpos = {[0]=0, [1]=0}
  local wsize = {[0]=ncols, [1]=nrows}
  local b = buffer.new(wpos, wsize)
  local test_line = string.rep('0123456789', 7) .. '012345678'
  buffer.set(b, test_line)
  b.cursor_pos[0] = 78
  _active_buf = b
  insert_mode.begin('a')
  insert_mode.char_pressed('9')
  insert_mode.char_pressed('0')

  assert_equal(b.cursor_pos[0], 81)
  assert_equal(b.scroll_pos[0], 2)
end

testutil.run_tests(tests)

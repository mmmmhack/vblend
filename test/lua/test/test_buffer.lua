-- test_buffer.lua  : unit tests for buffer.lua
--
-- test naming: method_condition_expectedResult
package.path = package.path .. ';../?.lua'
require('tf_debug')
require('util')
require('buffer')

-- stubs
tflua = {}
tflua.set_cursor = function(row, col)
end

local num_failed = 0
local num_run = 0
local cur_test = nil
local tests = {}

function test_name()
  return cur_test;
end

function test_failed(msg)
  io.stderr:write(string.format("test %s failed: %s\n", test_name(), msg))
  debug.traceback()
  assert(false)
end

function assert_equal(v, vexp)
  if v ~= vexp then
    test_failed(string.format("assert_equal: v: %s, vexp: %s", tostring(v), tostring(vexp)))
    return
  end
end

function compare_lines(lines, exp_lines)
  if #lines ~= #exp_lines then
    test_failed(string.format("compare_lines: #lines: %d, #exp_lines: %d", #lines, #exp_lines))
    return
  end
  for i = 0, #lines do
    local lna = lines[i]
    local lnb = exp_lines[i]
    if lna ~= lnb then
      test_failed(string.format("compare_lines: lines[%d]: %s, exp_lines[%d]: %s", i, lna, i, lnb))
      return
    end
  end
end

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

tests['inCursor_testLine80ScrollPos01_display79andBlank'] = function()
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

function main()
--debug_console()
  for t, f in pairs(tests) do
    cur_test = t
    status, err = pcall(f) 
    if err then
      print("test failed: " .. err)
      num_failed = num_failed + 1
    end
    num_run = num_run + 1
  end
  print(string.format("%d run, %d passed, %d failed", num_run, num_run - num_failed, num_failed))
end

main()

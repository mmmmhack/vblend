-- unittest.lua : common unit test code
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.num_failed = 0
M.num_run = 0
M.cur_test = nil

M.test_name = function ()
  return M.cur_test;
end

M.test_failed = function (msg)
  io.stderr:write(string.format("test %s failed: %s\n", M.test_name(), msg))
  print(debug.traceback())
  assert(false)
end

M.assert_equal = function (v, vexp)
  if v ~= vexp then
    M.test_failed(string.format("assert_equal: v: %s, vexp: %s", tostring(v), tostring(vexp)))
    return
  end
end

M.compare_lines = function (lines, exp_lines)
  if #lines ~= #exp_lines then
    M.test_failed(string.format("compare_lines: #lines: %d, #exp_lines: %d", #lines, #exp_lines))
    return
  end
  for i = 0, #lines do
    local lna = lines[i]
    local lnb = exp_lines[i]
    if lna ~= lnb then
      M.test_failed(string.format("compare_lines: lines[%d]: %s, exp_lines[%d]: %s", i, lna, i, lnb))
      return
    end
  end
end

M.run_tests = function (tests)
--debug_console()
  for t, f in pairs(tests) do
    M.cur_test = t
    status, err = pcall(f) 
    if err then
      print("test failed: " .. err)
      M.num_failed = M.num_failed + 1
    end
    M.num_run = M.num_run + 1
  end
  print(string.format("%d run, %d passed, %d failed", M.num_run, M.num_run - M.num_failed, M.num_failed))
end



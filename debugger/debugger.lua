-- debugger.lua : implements a simple lua debugger
-- call 'debug_console() from client code to enter debugger
require('util')

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M._version = "0.1"
M._first_time = true
M._break_src = nil
M._break_line = nil
M._target_offset_from_top = nil -- level of debuggee function when breakpoint hit, relative to top of stack
M._instruction_tracing = false
M.trace_file = "trace.log"

M.print_help = function ()
  print("--- commands:");
  print("  b FILE:LINE   :    set breakpoint");
  print("  c             :    continue program execution");
  print("  o             :    print all local variables");
  print("  u             :    print all upvalue variables");
  print("  p EXPR        :    print value of expression");
  print("  s             :    step one instruction");
  print("  t             :    toggle instruction tracing");
  print("  i             :    show current location");
  print("  w             :    show backtrace");
  print("  q             :    quit program");
  print("  h             :    show this help");
  print("--- expressions :")
  print("  VAR_NAME        :    simple variable name")
  print("  T1.V2 ...       :    table variable access, dot operator")
  print("  T1['V2'] ...    :    table variable access, index operator")
  print("  type(EXPR)      :    type of variable resolved in EXPR")
  print("  len(EXPR)       :    length of table resolved in EXPR")
  print("  pairs(EXPR)     :    all (key,val) pairs in table resolved in EXPR")
  print("");
end

M.print_prompt = function ()
  io.write("> ");
end

M.set_breakpoint = function (ln)
  ln = M.trim(ln)
  -- pat match: \s*SRC_FILE:LINE_NUM
  local src, line = string.match(ln, "(.+):(%d+)")
  line = tonumber(line)
  if src == nil or line == nil then
    io.stderr:write("Error: missing or invalid breakpoint arg\n")
    debug.sethook()
    return
  end
  M._break_src = src
  M._break_line = line
  print(string.format("breaking at %s:%d\n", M._break_src, M._break_line));
  debug.sethook(M.check_breakpoints, "l")
end

M.check_breakpoints = function (event, line)
  local info = debug.getinfo(2, 'Sl')
--  if info.source == "@./lua/" .. M._break_src and info.currentline == M._break_line then
  local src_line = string.match(info.source, "([_%a][_%w]*%.lua)$")
--print(string.format("checking line[%s:%d]", src_line, line))
  if src_line == M._break_src and info.currentline == M._break_line then
    print("breakpoint hit!")
    debug_console()
  end
end

M.trim = function(s)
	local r = string.match(s, "^%s*(.-)%s*$")
	return r
end

M.isdigit = function(s)
	local n = string.byte(s)
	return n >= string.byte("0") and n <= string.byte("9")
end

-- global funcs
M.get_traceback = function(show_debug)
--print(string.format("bot level: %d, target_offset: %d, target_level: %d", M.getinfo_bottom(), M.target_offset, M.target_level()))
	local sret = ""
  local plevel = 1
  for level = 1, math.huge do 
    local info = debug.getinfo(level)   -- get all info
    if not info then break end 
    if info.what == "C" then -- is a C function? 
      sret = sret .. string.format("%2d [C function]\n", plevel)
      plevel = plevel + 1
    else -- a Lua function 
      -- skip lines in debug module TODO: narrow this down if we ever want to debug the debug module itself
      local internal_level = string.match(info.short_src, "debugger.lua$") ~= nil
      if not internal_level or show_debug then
        sret = sret .. string.format("%2d [%s:%d] (%s)\n", plevel, info.short_src, info.currentline, tostring(info.name))
        plevel = plevel + 1
      end
    end 
  end 
	return sret
end

function traceback(show_debug)
--print(string.format("bot level: %d, target_offset: %d, target_level: %d", M.getinfo_bottom(), M.target_offset, M.target_level()))
--[[
  local plevel = 1
  for level = 1, math.huge do 
    local info = debug.getinfo(level)   -- get all info
    if not info then break end 
    if info.what == "C" then -- is a C function? 
      print(string.format("%2d [C function]", plevel)) 
      plevel = plevel + 1
    else -- a Lua function 
      -- skip lines in debug module TODO: narrow this down if we ever want to debug the debug module itself
      local internal_level = string.match(info.short_src, "debugger.lua$") ~= nil
      if not internal_level or show_debug then
        print(string.format("%2d [%s:%d] (%s)", plevel, info.short_src, info.currentline, tostring(info.name))) 
        plevel = plevel + 1
      end
    end 
  end 
--]]
	local tb = M.get_traceback(show_debug)
--	return sret
	print(tb)
end

-- expr =    . identifier 
--        |  . identifier expr
--        |  [ identifier ]
--        |  [ identifier ] expr
--        |  [ number ]
--        |  [ number ] expr
--        |  [ ' string ' ]
--        |  [ ' string ' ] expr
M.split_index_expr = function (expr)
  if not expr or #expr == 0 then
    return nil
  end
  local dot_pat = "^%.([_%a][_%w]*)(.*)"
  local key, rest = string.match(expr, dot_pat)
  if key then
    return key, rest
  end
  local bracket_pat = "^%[(.-)%](.*)"
  key, rest = string.match(expr, bracket_pat)
  if key then
    return key, rest
  end
  local err = 'invalid expression: "^." or "^[" expected, found: "^"' .. expr
  return nil, err
end

-- recursively accesses the value of table indices in param expression.
-- the index_expr starts with either a '.' or '['
M.get_table_expr = function(val, index_expr)
--print(string.format("get_table_expr(): val: %s, index_expr: %s", tostring(val), tostring(index_expr)))
  local key, rest = M.split_index_expr(index_expr)
--print(string.format("get_table_expr(): key: %s, rest: %s", tostring(key), tostring(rest)))
  if not key then
    if rest ~= nil then
      local err = rest
      return nil, err
    end
    return val
  end
  local sub_val = nil
  local first_char = string.sub(key, 1, 1)
  if M.isdigit(first_char) then
    local nkey = tonumber(key)
    if nkey == nil then
      err = "invalid key"
      return nil, err
    end
    sub_val = val[nkey]
  else
    sub_val = val[key]
  end
--print(string.format("get_table_expr(): sub_val: %s", tostring(sub_val)))
  return M.get_table_expr(sub_val, rest)
end

-- splits param expression into a prefix preceding an index operator and the rest of the expression
M.split_head_expr = function (expr)
  local pos = string.find(expr, "%.")
  if pos then
    return string.sub(expr, 1, pos - 1), string.sub(expr, pos)
  end
  pos = string.find(expr, "%[")
  if pos then
    return string.sub(expr, 1, pos - 1), string.sub(expr, pos)
  end
  return expr
end

-- dumps all locals for target level
M.dump_locals = function()
--print(string.format("--- dump_locals for stack level %d", stack_level))
  local target_level = M.target_level()
  local i = 1
  while true do
    local name, val = debug.getlocal(target_level, i)
    if not name then
      break 
    end
    print(string.format("local %04d: name: [%s], val: [%s]", i, tostring(name), tostring(val)))
    i = i + 1
  end
	if i == 1 then
		print("no locals")
	end
end

M.dump_debug_info = function(level)
  print(string.format("---debug info for level %d:", level))
  local info = debug.getinfo(level+1)
  for k,v in pairs(info) do
    print(string.format("  %s: [%s]", tostring(k), tostring(v)))
  end
end

-- returns name and value of local variable with param name, if found, else nil
M.find_local_var = function(var_name)
  local target_level = M.target_level()
  local i = 1
  while true do
    local name, val = debug.getlocal(target_level, i)
--print(string.format(" i: %d: name: %s", i, tostring(name)))
    if not name then
      break 
    end
    if name == var_name then
      return name, val
    end
    i = i + 1
  end
end

-- dumps all upvalues at param stack level
M.dump_upvalues = function()
--print(string.format("du: looking for upvalues at stack level: %d", stack_level))
  local target_level = M.target_level()
  local func = debug.getinfo(target_level, 'f').func
  local i = 1
  while true do
    local name, val = debug.getupvalue(func, i)    
    if not name then
      break 
    end
    print(string.format("upvalue %04d: name: [%s], val: [%s]", i, tostring(name), tostring(val)))
    i = i + 1
  end
	if i == 1 then
		print("no upvalues")
	end
end

-- returns name and value of upvalue with param name, if found, else nil
M.find_upvalue = function(var_name)
  local target_level = M.target_level()
  local func = debug.getinfo(target_level, 'f').func
  local i = 1
  while true do
    local name, val = debug.getupvalue(func, i)    
--print(string.format("fu: uv %2d: name: [%s], val: [%s]", i, tostring(name), tostring(val)))
    if not name then
      break 
    end
    if name == var_name then
      return name, val
    end
    i = i + 1
  end
end

M.find_global_var = function(var_name)
  for k, v in pairs(_G) do
    if k == var_name then
      return k, v
    end
  end
end

-- recursively evaluates param expression, returns head, final val
M.eval_expr = function(expr)
  local head, rest = M.split_head_expr(expr)

  -- look for local first
  local name, val = M.find_local_var(head)

  -- if not found, look for upvalue
  if name == nil then
    name, val = M.find_upvalue(head)
  end

  -- if not found, look for global
  if name == nil then
    name, val = M.find_global_var(head)
  end

  -- we struck out
  if name == nil then
    return nil, nil
  end

  -- do recursive lookup
  local final_val, err = M.get_table_expr(val, rest)
  if err then
    return nil, err
  end
  return name, final_val
end

-- prints the value of param expression
M.print_evaluated_expr = function (expr)
  local n, v = M.eval_expr(expr)
  if n == nil then
    print("invalid expression: " .. expr)
    do return end
  end
  if type(v) == 'string' then
    print(string.format("%s: '%s'", expr, v))
  else
    print(string.format("%s: %s", expr, tostring(v)))
  end
end

-- prints the value of a builtin debugger function operating on param expression
M.print_func_expr = function(func_name, expr)
  local nm, val = M.eval_expr(expr)
	if val == nil then
		print(string.format("'%s' evaluates to nil", tostring(expr)))
		return
	end
  if      func_name == "type" then
    print(string.format("type(%s): %s", expr, type(val)))
  elseif func_name == "len" then
    print(string.format("len(%s): %d", expr, #val))
  elseif func_name == "pairs" then
    for k, v in pairs(val) do
      local sv
      if type(v) == 'string' then
        sv = "'" .. v .. "'"
      else  
        sv = tostring(v)
      end
      print(string.format("%-16s: %s", k, sv))
    end
  else
    print("invalid function: " .. func_name)
  end
end

-- prints the value of param expression, where it is either a builtin debugger function, local var or global var
M.print_expr = function(expr)
  local func_name, arg = string.match(expr, "(%w+)%((.+)%)")
  if func_name then
    M.print_func_expr(func_name, arg)
    return
  end

  -- print value of expression
 M.print_evaluated_expr(expr)
end

-- returns suffix of param path where suffix is everything after final path separator
M.base_name = function(path)
  local path_sep = '/' -- TODO: check OS path sep
  local pos = #path
  while pos >= 1 do
    local ch = string.sub(path, pos, pos)
    if ch == path_sep then
      return string.sub(path, pos+1)
    end
    pos = pos - 1
  end
  return path
end

-- returns count of stack levels from bottom up to level with param source file name
M.count_src_levels = function(src_name)
  local cnt = 0
  local bot_level = M.getinfo_bottom()
  local n = bot_level
  while true do
    local info = debug.getinfo(n, "S")
    if not info then
      break
    end
    -- it seems sometimes info gets returned for negative levels with tail calls, so also check for hitting level 0
    if n == 0 then
      break
    end
--print(string.format("level %2d: src: [%s]", n, tostring(info.source)))
    local base_name = M.base_name(string.sub(info.source, 2))
--    print(string.format("  base_name: [%s]", base_name))
    if base_name == src_name then
      break
    end
    cnt = cnt + 1
    n = n - 1
  end
  return cnt
end

-- returns stack level with debug.getinfo.func == param func name, or nil if not found. level is relative to caller, not this func
M.getinfo_level = function (func_name_at_level)
  local level = 1
  while true do
    local info = debug.getinfo(level+1)
--util.dump_debug_info(info, "get_info_level")
    local info_name = "na"
    if info then
      info_name = tostring(info.name)
    end
    if not info then
      break
    end
    if info.name == func_name_at_level then
--      return level + 1
      return level -- return level relative to caller
    end
    level = level + 1
  end
  return nil
end

-- returns stack level of stack bottom, relative to caller, not this function
M.getinfo_bottom = function()
  local level = 1
  while true do
    local info = debug.getinfo(level+1)
    local info_name = "na"
    if info then
      info_name = tostring(info.name)
    end
    if not info then
      break
    end
    level = level + 1
  end
  return level - 1  -- return level relative to caller
end

-- returns the absolute stack level of the target debugging function
M.target_level = function()
  return M.getinfo_bottom() - M._target_offset_from_top
end

M.find_source_line = function(src_file, line_num)
	local lines = {}
	for ln in io.lines(src_file) do
		lines[#lines + 1] = ln
	end
	local source_line = ""
	if lines and #lines >= line_num then
		source_line = lines[line_num]
	end
	return source_line 
end

-- prints debug info for the target stack level
M.print_target_level = function()
  local target_level = M.target_level()
  local info = debug.getinfo(target_level, 'Snl')
  local func = info.name
  local src = string.sub(info.source, 2)
  local line = info.currentline
	local instruction = " " .. util.trim(M.find_source_line(src, line))
--  print(string.format("%2d [%s:%d] (%s)%s", 1, src, line, tostring(func), instruction))
  print(string.format("[%s:%d] (%s)%s", src, line, tostring(func), instruction))
end

-- entered on 'step' command
M.instruction_executed = function()
  local level = 2   -- non-hook lua code is 2 stack levels above this function
  local info = debug.getinfo(level, 'Sl')
  if info.source ~= '@./debugger.lua' then
    debug.sethook()
    debug_console()
  end
end

-- steps a single line of target code
M.step_instruction = function()
  debug.sethook(M.instruction_executed, "l")
end

-- entered on 'next' command
M.next_instruction_executed = function()
--traceback(true)
--  local bot_level = M.getinfo_bottom()
--  local non_hook_level = bot_level - 2   -- non-hook lua code is 2 stack levels above this function
--print(string.format("---next_instruction: bot_level: %d, non_hook_level: %d, target_level: %d",
-- bot_level, non_hook_level, M.target_level()))
  -- break when target level is at 'top' of stack, not counting the 'hook' levels
  if M.target_level() == 2 then
    debug.sethook()
    debug_console()
  end
--local info = debug.getinfo(2, 'Sl')
--if info.source ~= '@./debugger.lua' then
--  debug.sethook()
--  debug_console()
--end
end

-- breaks on next line of target code in current function
M.next_instruction = function()
  debug.sethook(M.next_instruction_executed, "l")
end

M.log_next_instruction_executed = function()
  local info = debug.getinfo(2, 'Snl')
  local func = info.name
  local src = string.sub(info.source, 2)
  local line = info.currentline
	local fh = io.open(M.trace_file, "a")
  local ln = string.format("***[%s:%d] (%s)\n", src, line, tostring(func))
	fh:write(ln)
	local tb = M.get_traceback(true)
	fh:write(tb .. "\n")
	fh:close()
end

M.toggle_instruction_tracing = function()
	M.instruction_tracing = not M.instruction_tracing 
	if M.instruction_tracing then
		print(string.format("instruction tracing is ON, appending to %s", M.trace_file))
 	 debug.sethook(M.log_next_instruction_executed, "l")
	else
		print(string.format("instruction tracing is OFF"))
 	 debug.sethook()
	end
end

-- interactive debugging console
function debug_console()
  if M._first_time then
    print("--- lua debug console version " .. M._version)
    M._first_time = false
  end

  M._target_offset_from_top = M.count_src_levels('debugger.lua')
  M.print_target_level()

  local get_input = true
  while get_input do
    M.print_prompt();
    local ln = io.stdin:read()
    ln = M.trim(ln)
    if #ln ~= 0 then
      local c = string.sub(ln, 1, 1)
      -- continue
      if     c == 'c' then
        get_input = false;
      elseif c == 'b' then
        M.set_breakpoint(string.sub(ln, 2))
      elseif c == 'n' then
        M.next_instruction()
        get_input = false;
      elseif c == 'o' then
        M.dump_locals()
      elseif c == 'u' then
        M.dump_upvalues()
      elseif c == 'p' then
        local expr = M.trim(string.sub(ln, 2))
        M.print_expr(expr)
      elseif c == 's' then
        M.step_instruction()
        get_input = false;
      elseif c == 't' then
        M.toggle_instruction_tracing()
--  			get_input = false;
      elseif c == 'i' then
        M.print_target_level()
      elseif c == 'w' then
        traceback()
      elseif c == 'h' then
        M.print_help()
      elseif c == 'q' then
        debug.sethook() -- clear debug hook or we might not ever return to the C code
--        tflua.quit()    -- TODO: replace with tfedit.quit()
        os.exit(0)
        do return end
      else
        print("unknown command '" .. c .. "'")
      end
    end
  end
  print("continuing program execution");
end


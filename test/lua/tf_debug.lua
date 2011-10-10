-- tf_debug.lua : implements a simple lua debugger
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M._version = "0.1"
M._first_time = true
M._break_src = nil
M._break_line = nil
M._target_offset = nil -- level of debuggee function when breakpoint hit, relative to bottom of stack

M.print_help = function ()
  print("--- commands:");
  print("  b FILE:LINE   :    set breakpoint");
  print("  c             :    continue program execution");
  print("  o             :    print all local variables");
  print("  u             :    print all upvalue variables");
  print("  p EXPR        :    print value of expression");
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
  ln = util.trim(ln)
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
    debug_console(true)
  end
end

-- global funcs
function traceback(show_debug)
  for level = 1, math.huge do 
    local info = debug.getinfo(level)   -- get all info
    if not info then break end 
    if info.what == "C" then -- is a C function? 
      print(level, "C function") 
    else -- a Lua function 
      -- skip lines in debug module TODO: narrow this down if we ever want to debug the debug module itself
      local internal_level = string.match(info.short_src, "tf_debug.lua$") ~= nil
      if not internal_level or show_debug then
        print(string.format("[%s]:%d (%s)", info.short_src, info.currentline, tostring(info.name))) 
      end
    end 
  end 
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
--[[
  local bri_pat = "^%[([_%a][_%w]*)(.*)"
  key, rest = string.match(expr, bri_pat)
  if key then
    return key, rest
  end
  local brn_pat = "^%[(%d+)%](.*)"
  key, rest = string.match(expr, brn_pat)
  if key then
    return key, rest
  end
--]]
  local brk_pat = "^%[(.-)%](.*)"
  key, rest = string.match(expr, brk_pat)
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
  if util.isdigit(first_char) then
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

-- dumps all locals at param stack level
M.dump_locals = function(stack_level)
--print(string.format("--- dump_locals for stack level %d", stack_level))
  local i = 1
  while true do
    local name, val = debug.getlocal(stack_level, i)    
    if not name then
      break 
    end
    print(string.format("local %04d: name: [%s], val: [%s]", i, tostring(name), tostring(val)))
    i = i + 1
  end
end

-- returns name and value of local variable with param name, if found, else nil
M.find_local_var = function(var_name)
  local bot_level = M.getinfo_bottom()
  local level = bot_level - M.target_offset
  local i = 1
  while true do
    local name, val = debug.getlocal(level, i)    
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
M.dump_upvalues = function(stack_level)
--print(string.format("du: looking for upvalues at stack level: %d", stack_level))
  local func = debug.getinfo(stack_level, 'f').func
  local i = 1
  while true do
    local name, val = debug.getupvalue(func, i)    
    if not name then
      break 
    end
    print(string.format("upvalue %04d: name: [%s], val: [%s]", i, tostring(name), tostring(val)))
    i = i + 1
  end
end

-- returns name and value of upvalue with param name, if found, else nil
M.find_upvalue = function(var_name)
  local bot_level = M.getinfo_bottom()
  local level = bot_level - M.target_offset
-- :P
level = level-1 -- why??
--traceback(true)
  local func = debug.getinfo(level, 'f').func
--print(string.format("fu: stack level: %d: func: [%s]: looking for var_name: [%s]", level, tostring(func), var_name))
--print("-- locals:")
--M.dump_locals(level)
--print("-- debug info:")
--local di = debug.getinfo(level)
--for k,v in pairs(di) do print(k, v) end
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
  print(string.format("%s: %s", expr, tostring(v)))
end

-- prints the value of a builtin debugger function operating on param expression
M.print_func_expr = function(func_name, expr)
  local nm, val = M.eval_expr(expr)
  if      func_name == "type" then
    print(string.format("type(%s): %s", expr, type(val)))
  elseif func_name == "len" then
    print(string.format("len(%s): %d", expr, #val))
  elseif func_name == "pairs" then
    for k, v in pairs(val) do
      print(string.format("%-16s: %s", k, tostring(v)))
    end
  else
    print("invalid function: " .. func_name)
  end
end

-- prints the value of param expression, where it is either a builtin debugger function, local var or global var
M.print_expr = function(expr)
  func_name, arg = string.match(expr, "(%w+)%((.+)%)")
  if func_name then
    M.print_func_expr(func_name, arg)
    return
  end

  -- print value of expression
 M.print_evaluated_expr(expr)
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

function debug_console(print_traceback)
  if M._first_time then
    print("--- lua debug console version " .. M._version)
    M._first_time = false
  end
  local print_traceback = false
  local bot_level = M.getinfo_bottom()
  local cur_level = M.getinfo_level('debug_console')
  if cur_level then
    M.target_offset = bot_level - (cur_level + 2)  -- getinfo() stack level of target function, relative to bottom level (2 levels above debug_consol())
  else
    M.target_offset = nil
  end
  if print_traceback then
    print(string.format("--- BEG debug_console(): bot_level: %s, cur_level: %s, M.target_offset: %s", 
      tostring(bot_level), tostring(cur_level), tostring(M.target_offset)))
    traceback()
  end
  local get_input = true
  while get_input do
    M.print_prompt();
    local ln = io.stdin:read()
    ln = util.trim(ln)
    if #ln ~= 0 then
      local c = string.sub(ln, 1, 1)
      -- continue
      if     c == 'c' then
        get_input = false;
      elseif c == 'b' then
        M.set_breakpoint(string.sub(ln, 2))
      elseif c == 'o' then
        local level = bot_level - M.target_offset
        M.dump_locals(level)
      elseif c == 'u' then
        local level = bot_level - M.target_offset
        M.dump_upvalues(level)
      elseif c == 'p' then
        local expr = util.trim(string.sub(ln, 2))
        M.print_expr(expr)
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


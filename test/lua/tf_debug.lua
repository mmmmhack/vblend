-- tf_debug.lua : implements a simple lua debugger
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M._break_src = nil
M._break_line = nil
M._target_level = nil -- level of debuggee function when breakpoint hit, relative to bottom of stack

M.print_help = function ()
  print("--- commands:");
  print("  b FILE:LINE   :    set breakpoint");
  print("  c             :    continue program execution");
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
--print("tf_debug.check_breakpoints(): source:line: " .. info.source .. ":" .. line)
--print("_break_src=[" .. _break_src .. "], _break_line=[" .. _break_line .. "]")
  if info.source == "@./lua/" .. M._break_src and info.currentline == M._break_line then
    print("breakpoint hit!")
    debug_console(true)
  end
end

-- global funcs
function traceback()
  for level = 1, math.huge do 
--    local info = debug.getinfo(level, "Sln") 
    local info = debug.getinfo(level)   -- get all info
    if not info then break end 
    if info.what == "C" then -- is a C function? 
      print(level, "C function") 
    else -- a Lua function 
      -- skip lines in debug module TODO: narrow this down if we ever want to debug the debug module itself
      local m = string.match(info.short_src, "tf_debug.lua$")
      local show_debug = true
      if m == nil or show_debug then
        print(string.format("[%s]:%d (%s) namewhat: [%s]", info.short_src, info.currentline, tostring(info.name), tostring(info.namewhat))) 
      end
    end 
  end 
end

M.find_local_var = function(var_name)
  local bot_level = M.getinfo_bottom()
  local level = bot_level - M.target_level
  local info = debug.getinfo(level)
traceback()
print(string.format("find_local_var(): bot_level: %d, M.target_level: %d, level: %d, src:line: %s:%d", bot_level, M.target_level, level, info.short_src, info.currentline))
  local i = 1
  while true do
    local name, val = debug.getlocal(level, i)    
    if not name then
      break 
    end
--print(string.format("%s: %s", name, tostring(val)))
    if name == var_name then
      return name, val
    end
    i = i + 1
  end
end

M.print_var_name = function (var_name)
  local n, v = M.find_local_var(var_name)
  if n == nil then
    print("local var not found: " .. var_name)
    do return end
  end
  print(string.format("%s: %s", n, tostring(v)))
end

M.print_func_expr = function(func_name, expr)
  if      func_name == "type" then
  elseif func_name == "len" then
  elseif func_name == "pairs" then
  else
    print("invalid function: " .. func_name)
  end
end

M.print_expr = function(expr)
  func_name, arg = string.match(expr, "(%w+)%((.+)%)")
  if func_name then
    M.print_func_expr(func_name, arg)
    return
  end
  -- TODO: add recursive var indexing
  M.print_var_name(expr)
end

-- returns stack level with debug.getinfo.func == param func name, or nil if not found
M.getinfo_level = function (func_name_at_level)
print(string.format("--- BEG getinfo_level(): func_name_at_level: %s", tostring(func_name_at_level)))
  local level = 1
  while true do
    local info = debug.getinfo(level+1)
    local info_name = "na"
    if info then
      info_name = tostring(info.name)
    end
print(string.format("  level: %d, info.name: %s", level+1, info_name))
    if not info then
      break
    end
    if info.name == func_name_at_level then
print(string.format("--- RET getinfo_level(): ret: %d", level+1))
      return level
    end
    level = level + 1
  end
print(string.format("--- END getinfo_level(): reached level %d, returning nil", level))
  return nil
end

M.getinfo_bottom = function()
print(string.format("--- BEG getinfo_bottom()"))
  local level = 1
  while true do
    local info = debug.getinfo(level+1)
    local info_name = "na"
    if info then
      info_name = tostring(info.name)
    end
print(string.format("  level: %d, info.name: %s", level+1, info_name))
    if not info then
      break
    end
    level = level + 1
  end
print(string.format("--- END getinfo_bottom(): returning level %d", level))
  return level
end

function debug_console(print_traceback)
print_traceback = true
  if print_traceback then
    traceback()
  end
  local bot_level = M.getinfo_bottom()
  local cur_level = M.getinfo_level('debug_console')
  if cur_level then
    M.target_level = bot_level - (cur_level + 2)  -- getinfo() stack level of target function, relative to bottom level (2 levels above debug_consol())
  else
    M.target_level = nil
  end
print(string.format("debug_console(): bot_level: %d, cur_level: %s, M.target_level: %s", bot_level, tostring(cur_level), tostring(M.target_level)))
  local get_input = true
  while get_input do
    M.print_prompt();
    local ln = io.read()
    ln = util.trim(ln)
    if #ln ~= 0 then
      local c = string.sub(ln, 1, 1)
--print("c: [" .. c .. "]")
      -- continue
      if     c == 'c' then
        get_input = false;
      elseif c == 'b' then
        M.set_breakpoint(string.sub(ln, 2))
      elseif c == 'p' then
        local expr = util.trim(string.sub(ln, 2))
        M.print_expr(expr)
      elseif c == 'w' then
        traceback()
      elseif c == 'h' then
        M.print_help()
      elseif c == 'q' then
        tflua.quit()    -- TODO: replace with tfedit.quit()
        do return end
      else
        print("unknown command '" .. c .. "'")
      end
    end
  end
  print("continuing program execution");
end


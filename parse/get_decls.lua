-- get_decls.lua : reads pre-processed header file, returns table of declarations
function get_decls(fname)
  io.input(fname)
  local buf = io.read(math.huge)
  local brace_level = 0
  local decls = {}
  local cur_decl = ""
  for i = 1, #buf do
    
    local c = string.sub(buf, i, i)   
    
    -- track brace level
    if c == '{' then
      brace_level = brace_level + 1
    elseif c== '}' then
      brace_level = brace_level - 1
    end
    
    -- add to cur decl
    cur_decl = cur_decl .. c

    -- detect end decl
    if brace_level == 0 then
      if c == ';' then
        decls[#decls + 1] = cur_decl
        cur_decl = ""
      end
    end

  end
  return decls
end


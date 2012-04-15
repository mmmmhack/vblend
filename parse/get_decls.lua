-- get_decls.lua : reads pre-processed header file, returns table of declarations
function get_decls(fname, verbose)
  if verbose then
    print(string.format("get_decls(): opening input file [%s]", fname))
  end
  io.input(fname)
--  local buf = io.read(math.huge)
  local math_reallybig = 1000000000
	local buf = io.read(math_reallybig)
  local brace_level = 0
  local decls = {}
  local cur_decl = ""
  local num_chars = 0
  for i = 1, #buf do
    num_chars = num_chars + 1

    local c = string.sub(buf, i, i)   
    
    -- track brace level
    if c == '{' then
      brace_level = brace_level + 1
      if verbose then
        print(string.format("ch %d: inc to brace_level %d", i, brace_level))
      end
    elseif c== '}' then
      brace_level = brace_level - 1
      if verbose then
        print(string.format("ch %d: dec to brace_level %d", i, brace_level))
      end
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

  if verbose then
    print(string.format("get_decls(): closing input file, %d chars processed, %d decls parsed", num_chars, #decls))
  end
  io.close()

  return decls
end


-- gen_wrappers.lua  : generates lua function wrapper code for C header files

--[[ from now on, do this instead:
export LUA_PATH=$LUA_PATH;$PROJ_DIR/parse/?.lua
export LUA_PATH=$LUA_PATH;$PROJ_DIR/gamelib/?.lua
]]
require('util')
require('getopt')
require('get_decls')
require('debugger')

-- file with subset of function names for which wrappers should be generated
local sel_funcs = nil
local param_type_map = {
  ['const char*'] = 'string',   -- TODO: add pattern-matching properties as needed
  ['const char *'] = 'string',
  ['double'] = 'number',
  ['float'] = 'number',
  ['int'] = 'integer',
}
local opt_type_map = nil
local ret_params_map = nil
local includes_map = nil

local usage_desc = [[
Usage: gen_wrappers [options] DECL_FILE
Reads C header file from DECL_FILE, generates lua function wrappers from function declarations.
]]

local opt_defs = {
  includes_map = {
    short_opt = 'i',
    long_opt = 'includes-map',
    has_arg = true,
    descrip = "get C file includes for functions from '[func_name]=include_file' table entries in lua file INCLUDES_FILE",
    arg_descrip = 'INCLUDES_FILE',
  },
  remove_prefix = {
    short_opt = 'p',
    long_opt = 'remove-prefix',
    has_arg = true,
    descrip = 'remove PREFIX from function names',
    arg_descrip = 'PREFIX',
  },
  ret_params = {
    short_opt = 'r',
    long_opt = 'ret-params',
    has_arg = true,
    descrip = "identify returned values in function params from '[func_name,param_name]=lua_type' table entries in lua file RET_PARAMS_FILE",
    arg_descrip = 'RET_PARAMS_FILE',
  },
  sel_funcs = {
    short_opt = 's',
    long_opt = 'sel-funcs',
    has_arg = true,
    descrip = "only generate wrappers for '[func_name]=true' table entries in lua file SEL_FUNCS_FILE",
    arg_descrip = 'SEL_FUNCS_FILE',
  },
  type_map = {
    short_opt = 't',
    long_opt = 'type-map',
    has_arg = true,
    descrip = "get type conversions from '[ctype]=lua_type' table entries in lua file TYPE_MAP_FILE",
    arg_descrip = 'TYPE_MAP_FILE',
  },
  verbose = {
    short_opt = 'v',
    long_opt = 'verbose',
    has_arg = false,
    descrip = 'be verbose about what is happening',
  },
  help = {
    short_opt = 'h',
    long_opt = 'help',
    has_arg = false,
    descrip = 'show this help',
  },
}

-- parsed cmd-line options
local opts = nil

-- parses cmd-line options from param args and option definitions
function getopts(args)
  opts, non_opt_args = getopt.parse(args, opt_defs)  
  if not opts then
    os.exit(1)
  end    
  if opts.help then
    getopt.usage(usage_desc, opt_defs) 
    os.exit(0)
  end
  return non_opt_args
end

local lua_keyword_sub = {
	['begin'] = 'Begin',
	['end'] = 'End',
}

-- returns lua function name for param c function name
function get_lw_func_name(func_name)
  local lw_func_name = func_name
  --strip prefix if specified
  if opts.remove_prefix then
    local npre = #opts.remove_prefix
    if #lw_func_name >= npre then
      local pre = string.sub(lw_func_name, 1, npre)
      if pre == opts.remove_prefix then
        lw_func_name = string.sub(lw_func_name, npre + 1)
      end
    end
  end
  -- make first char lower case
	local first_ch = string.sub(lw_func_name, 1, 1)
  local rest = string.sub(lw_func_name, 2)
	lw_func_name = util.tolower(first_ch) .. rest

  -- do lua keyword sub
	if lua_keyword_sub[lw_func_name] then
		lw_func_name = lua_keyword_sub[lw_func_name] 
	end

  return lw_func_name
end

-- returns lua type name for corresponding param c type
function get_lua_type(ctype)
  -- look in opts type-map table
  if opt_type_map and opt_type_map[ctype] ~= nil then
      return opt_type_map[ctype]
  end
  -- look in default type-map table
  if param_type_map[ctype] == nil then
    if opts.verbose then
      print(string.format("get_lua_type(): lua type not found for ctype: [%s]", tostring(ctype)))
    end
    return nil
  end
  return param_type_map[ctype]
end

-- parses string of function parameters, returns table of param data suitable for generating the wrapper code
function get_params(func_name, param_decls)
  local params = {}
  for i, p in ipairs(param_decls) do
--print(string.format("get_params(): i: %2d, p: [%s]", i, p))
    if p == "void" then
    else  
      local ctype, cident = string.match(p, "^(.-)([_%a][_%w]*)$")
      local param = {}
      param.ctype = util.trim(ctype)
      param.cident = cident
      param.luatype = get_lua_type(param.ctype)
      param.is_ret = false

      -- check some extra cases for defining luatype: look in 'return params' type-map table
      if param.luatype == nil and ret_params_map then
        local rp_luatype = ret_params_map[func_name .. "," .. cident]
        if rp_luatype ~= nil then
					if opts.verbose then
						print(string.format("get_params(): setting param %s from ret_params_map", rp_luatype))
					end
          param.luatype = rp_luatype
          param.is_ret = true
        end
      end

      -- if no lua param type, return nil to skip this func
      if param.luatype == nil then
        if opts.verbose then
          print(string.format("get_params(): lua param not found for %s() param: %s", func_name, cident))
        end
        return nil
      end

      params[#params + 1] = param
--      print(string.format("  param %2d: [%s] [%s], luatype: [%s]", i, param.ctype, param.cident, param.luatype))
    end
  end
  return params
 end

-- reads list of functions from a file specified by command-line opt, only functions in the list will get wrappers
function read_sel_funcs()
  if opts.verbose then
    print(string.format("read_sel_funcs(): reading selected functions from lua file: [%s]", opts.sel_funcs))
  end

  sel_funcs = dofile(opts.sel_funcs)

  if opts.verbose then
    print(string.format("read_sel_funcs(): %d selected function(s) found", #opts.sel_funcs))
  end

end

-- returns true if param func is in the list of selected funcs
function is_sel_func(func_name)
  if not sel_funcs then
    read_sel_funcs()
  end
  for k, v in pairs(sel_funcs) do
    if func_name == k then
      return true
    end
  end
  return false
end

-- returns c and lua return types from return type declaration
function get_return_types(ret_decl)
  local c_ret_type = ret_decl --TODO: add filtering as needed
  local lua_ret_type = nil
  -- TODO: replace with table lookup
  if 
    c_ret_type == "int" or
    c_ret_type == "unsigned int" or
    c_ret_type == "float" or
    c_ret_type == "double" then
      lua_ret_type = "number"
  elseif 
    c_ret_type == "const char*" or
    c_ret_type == "const char *" then
      lua_ret_type = "string"
  elseif c_ret_type == "void" then
    lua_ret_type = "void"
  else  
    -- check some ways for getting luatype: look in opt_type_map table
    lua_ret_type = get_lua_type(c_ret_type)
  end
  if lua_ret_type == nil then
    if opts.verbose then
      print(string.format("get_return_types(): lua_ret_type is nil for c_ret_type: [%s]", c_ret_type))
    end
    return nil
  end
  return c_ret_type, lua_ret_type 
end

-- strips trailing '*' from param ctype declaration (for 'return param' definition before C func call)
function strip_pointer(ctype)
  local s = string.gsub(ctype, "%*%s*$", "")
  return s
end

-- returns wrapper code for param function declaration, and a 'register func' line
function gen_func_wrapper(decl)
--print(string.format("beg gfw: decl: [%s]", decl))
  local ret_decl, func_name, params_decl = string.match(decl, "^%s*(.-)%s+([_%a][_%w]+)%s*%((.*)%)%s*;%s*$") 
  if opts.verbose then
    print(string.format("gen_func_wrapper(): ret_decl: [%s], func_name: [%s], params_decl: [%s]", tostring(ret_decl), tostring(func_name), tostring(params_decl)))
  end
  if ret_decl == nil or func_name == nil or params_decl == nil then
    error(string.format("failed parsing decl: [%s]", decl))
  end
  local lw_func_name = get_lw_func_name(func_name)

	-- if func_name specified in includes_map, implement wrapping by custom include
  if includes_map and includes_map[func_name] ~= nil then
		local include_file = includes_map[func_name]
    if opts.verbose then
      print(string.format("gen_func_wrapper(): func_name: [%s], implementing with include file [%s]", func_name, include_file))
    end
		local func_def = string.format('#include "%s"\n', include_file)
		local func_reg = string.format('  {"%s", lw_%s},\n', lw_func_name, lw_func_name)
		return func_def, func_reg
  end

  -- if wrapping a subset and function not in subset, skip wrapping this function
  if opts.sel_funcs and not is_sel_func(func_name) then
    if opts.verbose then
      print(string.format("gen_func_wrapper(): no sel_func match: decl: [%s]", decl))
    end
    return nil, "not in selfuncs list"
  end

  -- get param defs
  if opts.verbose then
    print(string.format("gen_func_wrapper(): parsing param declarations"))
  end
  local params = {}
  if #params_decl > 0 then
    local param_decls_nt = util.split(params_decl, ",")
    local param_decls = {}
    for i, p in ipairs(param_decls_nt) do
      param_decls[#param_decls + 1] = util.trim(p)
    end
    params = get_params(func_name, param_decls)
    -- if params not supported, skip wrapping this function
    if params == nil then
      return nil, "param(s) not supported"
    end
  end

  if opts.verbose then
    print(string.format("gen_func_wrapper(): emitting C function definition"))
  end
  local func_def = ""

  -- emit beg func
  local s = string.format("static int lw_%s(lua_State* L) {\n", lw_func_name)
  func_def = func_def .. s

  -- emit get lua args from stack
	local stack_index = 0 - #params
  for i, param in ipairs(params) do
    if param.is_ret then
      s = string.format("  %s %s = 0;\n", strip_pointer(param.ctype), param.cident)
    else
      local cast = ""
      if param.luatype=="userdata" then
        cast = string.format("(%s) ", param.ctype)
      end
      s = string.format("  %s %s = %slua_to%s(L, %d);\n", param.ctype, param.cident, cast, param.luatype, stack_index)
      stack_index = stack_index + 1
    end
    func_def = func_def .. s
  end

	-- emit assign ret val
  local c_ret_type, lua_ret_type = get_return_types(ret_decl)
  -- skip this function if return type not supported
  if c_ret_type == nil then
    if opts.verbose then
      print(string.format("gen_func_wrapper(): func %s: no ret type for decl: [%s]", func_name, ret_decl))
    end
    return nil, "return type not supported"
  end
	local nRet = 0
	if c_ret_type ~= "void" then
		s = string.format("  %s ret_val = \n", c_ret_type)
    func_def = func_def .. s
		nRet = 1
	end

  -- emit beg cfunc call
  s = string.format("  %s(", func_name)
  func_def = func_def .. s

  -- emit cargs
  for i, param in pairs(params) do
    if i > 1 then
      func_def = func_def .. ","
    end
    local ret_mod = param.is_ret and "&" or ""
    s = string.format("\n    %s%s", ret_mod, param.cident)
    func_def = func_def .. s
  end

  -- emit end cfunc call
  s = string.format("\n  );\n")
  func_def = func_def .. s

  -- emit push cret to lua stack
  if nRet > 0 then
    s = string.format("  lua_push%s(L, ret_val);\n", lua_ret_type)
    func_def = func_def .. s
  end

  -- emit push ret param values if any
  for i, param in pairs(params) do
    if param.is_ret then
      s = string.format("  lua_push%s(L, %s);\n", param.luatype, param.cident)
      func_def = func_def .. s
      nRet = nRet + 1
    end
  end

  -- emit ret count                           ex: return 0;
  s = string.format("  return %d;\n", nRet)
  func_def = func_def .. s

  -- emit end func                            ex: }
  s = "}\n"
  func_def = func_def .. s

--print(string.format("  func_def:\n%s", func_def))

  -- generate func reg line
	local func_reg = string.format('  {"%s", lw_%s},\n', lw_func_name, lw_func_name)

  return func_def, func_reg
end

function main()
  -- getopts
  local non_opt_args = getopts(arg)
  if #non_opt_args == 0 then
    io.stderr:write("missing DECL_FILE\n")
    os.exit(1)
  end
  -- input file
  local decl_fname = non_opt_args[1]

  -- ouput files
  local base_name = string.match(decl_fname, "(.+)%.[^.]*$")
  if not base_name then
    base_name= decl_fname
  end
  local func_def_fname = string.format("lua_%s_func_def.c", base_name)
  local func_reg_fname = string.format("lua_%s_func_reg.c", base_name)
  local skipped_funcs_fname = string.format("lua_%s_func_skipped.txt", base_name)

  -- add type conversions from opt if given
  if opts.type_map then
    opt_type_map = dofile(opts.type_map)
  end
  -- read 'return param' type conversions
  if opts.ret_params then
    ret_params_map = dofile(opts.ret_params)
  end
  -- read includes file if given
  if opts.includes_map then
    includes_map = dofile(opts.includes_map)
  end

--debug_console()

  -- process all declarations
  local skipped_func_decls = {}
  local num_typedefs = 0
  local num_func_defs_generated = 0
  local func_defs = ""
  local func_regs = ""
  local decls = get_decls(decl_fname, opts.verbose)
  for i, decl in ipairs(decls) do
    if opts.verbose then
      print(string.format("processing decl %04d: [%s]", i, decl))
    end

    -- skip typedef decls
    if string.match(decl, "^%s*typedef") then
      if opts.verbose then 
        print("skipping typedef decl")    
      end
      num_typedefs = num_typedefs + 1
    -- assume func decl
    else
      if opts.verbose then
        print("processing func decl")    
      end
      local func_def, func_reg = gen_func_wrapper(decl)  
      if func_def then
        func_defs = func_defs .. func_def
        func_regs = func_regs .. func_reg
        num_func_defs_generated = num_func_defs_generated + 1
      else
        local reason = func_reg
        skipped_func_decls[#skipped_func_decls + 1] = {reason=reason, decl=decl}
      end
    end
  end

  -- output
	io.output(func_def_fname)	
	io.write(func_defs)
	io.close()
	io.output(func_reg_fname)
	io.write(func_regs)
	io.close()
  io.output(skipped_funcs_fname)
  for i, skip in ipairs(skipped_func_decls) do
    io.write(string.format("--- skipped decl %d (%s):\n%s\n", i, skip.reason, skip.decl))
  end
	io.close()

  -- summary
  print(string.format("%d declarations(s) were parsed", #decls))
  print(string.format("%d typedefs were skipped", num_typedefs))
  print(string.format("%d func(s) written to %s, %s", num_func_defs_generated, func_def_fname, func_reg_fname))
  print(string.format("%d func(s) were skipped: %s", #skipped_func_decls, skipped_funcs_fname))
end

main()

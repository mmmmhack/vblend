-- gen_wrappers.lua  : generates lua function wrapper code for C header files

package.path=package.path .. ';../parse/?.lua'
package.path=package.path .. ';../test/lua/?.lua'
require('util')
require('getopt')
require('get_decls')
require('tf_debug')

--local preproc_fname = "preproc_gl.h"
--local wrapper_fname = "wrapper_funcs.c"
--local reg_fname = "reg_list.c"

local skipped_func_decls = {}

-- file with subset of function names for which wrappers should be generated
local sel_funcs = nil
local type_map = {
  ['const char *'] = 'string',
  ['double'] = 'number',
  ['float'] = 'number',
  ['int'] = 'integer',
}
local opt_type_map = nil

local usage_desc = [[
Usage: gen_wrappers [options] DECL_FILE
Reads C header file from DECL_FILE, generates lua function wrappers from function declarations.
]]

local opt_defs = {
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
    descrip = "get return values from function params for '[func_name,param_name]=true' table entries in lua file RET_PARAMS_FILE",
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
    descrip = "use type conversions from '[ctype]=lua_type' table entries in lua file TYPE_MAP_FILE",
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

local handled_return_types = {
	['GLint']=true, 
	['void']=true,
}

local handled_param_types = {
	['GLbitfield']='integer', 
	['GLclampf']='float', 
	['GLenum']='integer', 
	['GLfloat']='float',
	['GLdouble']='double',
	['GLint']='integer', 
	['const char *']='string',
	['void']='none',
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

--[[
-- reads and parses header file with param filename, returns table of declarations as strings
function parse_declarations(decl_fname)
  io.input(decl_fname)
  local decls = {}
  local cur_decl = ""
  local prev_ln = nil
  local continued_line = false
  local is_preproc_line = false
  local i = 0
  for ln in io.lines() do
    i = i + 1
    ln = util.trim(ln)
--print(string.format("gfd: ln %04d: [%s], prev_ln: [%s], continued_line: %s", i, ln, tostring(prev_ln), tostring(continued_line)))
    -- continued preproc
    if is_preproc_line and continued_line then
--print(string.format("  is #preproc ln continued"))
    -- blank ln
    elseif #ln == 0 then
    -- preproc
    elseif string.sub(ln, 1, 1) == "#" then
--print(string.format("  is #preproc ln"))
      is_preproc_line = true
    -- extern C
    elseif ln == 'extern "C" {' then
--print(string.format("  is extern C ln"))
    -- decl
    else
--print(string.format("  adding to decl %04d: [%s]", #decls + 1, ln))
      cur_decl = cur_decl .. ln  
    end

    -- end decl
    if string.sub(ln, #ln) == ";" then
      decls[#decls + 1] = cur_decl
--print(string.format("  added decl %04d: [%s]", #decls, cur_decl))
      cur_decl = ""
    end

    -- set continued line flag
    if string.sub(ln, #ln) == "\\" then
--print("  found continued line, next line should be same type")
      continued_line = true
    else
      continued_line = false
    end
    prev_ln = ln
  end
  io.close()
  return decls
end
--]]

-- returns lua type name for corresponding param c type
function get_lua_type(ctype)
  -- supplement type-map table with opt-supplied filename if any
  if opt_type_map and opt_type_map[ctype] ~= nil then
      return opt_type_map[ctype]
  end
  -- look in type-map table
  if type_map[ctype] == nil then
--    debug_console()
--    error(string.format("lua type not found for ctype: [%s]", tostring(ctype)))
    return nil
  end
  return type_map[ctype]
end

-- parses string of function parameters, returns table of param data suitable for generating the wrapper code
function get_params(param_decls)
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
      -- if no lua param type, return nil to skip wrapping function
      if param.luatype == nil then
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
--[[
  sel_funcs = {}
  io.input(opts.sel_funcs)
  for ln in io.lines() do
    local func_name = util.trim(ln)
    sel_funcs[func_name] = true 
  end
  io.close()
--]]
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
  if c_ret_type == "int" or
     c_ret_type == "unsigned int" or
     c_ret_type == "float" or
     c_ret_type == "double" 
  then
    lua_ret_type = "number"
  elseif c_ret_type == "void" then
    lua_ret_type = "void"
  else  
  end
  if lua_ret_type == nil then
--    error(string.format("lua_ret_type is nil for c_ret_type: [%s]", c_ret_type))
    return nil
  end
  return c_ret_type, lua_ret_type 
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
  -- if wrapping a subset and function not in subset, skip wrapping this function
  if opts.sel_funcs and not is_sel_func(func_name) then
    if opts.verbose then
      print(string.format("gen_func_wrapper(): no sel_func match: decl: [%s]", decl))
    end
    return
  end
--print(string.format("  ret_decl: [%s],\n  func_name: [%s],\n  params: [%s]", ret_decl, func_name, params_decl))
--debug_console()

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
    params = get_params(param_decls)
    -- if params not support, skip wrapping this function
    if params == nil then
      return
    end
  end

  if opts.verbose then
    print(string.format("gen_func_wrapper(): emitting C function definition"))
  end
  local func_def = ""

  -- emit beg func
  local lw_func_name = get_lw_func_name(func_name)
  local s = string.format("static int lw_%s(lua_State* L) {\n", lw_func_name)
  func_def = func_def .. s

  -- emit get lua args from stack
	local stack_index = 0 - #params
  for i, param in ipairs(params) do
    s = string.format("  %s %s = lua_to%s(L, %d);\n", param.ctype, param.cident, param.luatype, stack_index)
    stack_index = stack_index + 1
    func_def = func_def .. s
  end

	-- emit assign ret val
  local c_ret_type, lua_ret_type = get_return_types(ret_decl)
  -- skip this function if return type not supported
  if c_ret_type == nil then
    return nil
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

  -- TODO: emit cargs
  -- for each param
  for i, param in pairs(params) do
    if i > 1 then
      func_def = func_def .. ","
    end
    s = string.format("\n    %s", param.cident)
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
--debug_console()

  -- read from input file
  local num_typedefs = 0
  local num_func_defs_generated = 0
  local func_defs = ""
  local func_regs = ""
--  local decls = parse_declarations(decl_fname)
  local decls = get_decls(decl_fname, opts.verbose)
--print(string.format("%d decls found", #decls))
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
        skipped_func_decls[#skipped_func_decls + 1] = decl
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
  for i, v in ipairs(skipped_func_decls) do
    io.write(string.format("--- skipped decl %d:\n%s\n", i, v))
  end
	io.close()

  -- summary
  print(string.format("%d declarations(s) were parsed", #decls))
  print(string.format("%d typedefs were skipped", num_typedefs))
  print(string.format("%d func(s) written to %s, %s", num_func_defs_generated, func_def_fname, func_reg_fname))
  print(string.format("%d func(s) were skipped: %s", #skipped_func_decls, skipped_funcs_fname))
end

main()

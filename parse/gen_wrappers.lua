-- gen_wrappers.lua  : generates lua function wrapper code for C header files

package.path=package.path .. ';../parse/?.lua'
package.path=package.path .. ';../test/lua/?.lua'
require('util')
require('getopt')
require('tf_debug')

--local preproc_fname = "preproc_gl.h"
--local wrapper_fname = "wrapper_funcs.c"
--local reg_fname = "reg_list.c"

-- file with subset of function names for which wrappers should be generated
local sel_funcs = nil

local usage_desc = [[
Usage: gen_wrappers [options] DECL_FILE
Reads C header file from DECL_FILE, generates lua function wrappers from function declarations.
]]

local opt_defs = {
--[[
  src_file = {
    short_opt = 'f',
    long_opt = 'src-file',
    has_arg = true,
    descrip = 'read declarations from FILE',
    arg_descrip = 'FILE',
  },
--]]
  remove_prefix = {
    short_opt = 'p',
    long_opt = 'remove-prefix',
    has_arg = true,
    descrip = 'remove PREFIX from function names',
    arg_descrip = 'PREFIX',
  },
  sel_funcs = {
    short_opt = 's',
    long_opt = 'sel-funcs',
    has_arg = true,
    descrip = 'only generate wrappers for list of function names in SEL_FILE',
    arg_descrip = 'SEL_FILE',
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

--[[
function gen_func_wrapper(decl)
--print(string.format("beg gen_func_wrapper(): decl: [%s]", decl))
  local ret_type, func_name, params = string.match(decl, "GLAPI%s+(%S+)%s+GLAPIENTRY (%w+)%s*%((.+)%)") 

print(string.format("ret_type:  [%s], func: [%s], params: [%s]", ret_type, func_name, params))
	local handled = handled_return_types[ret_type] ~= nil
	if not handled then
		return
	end
--  print(ln)

	-- emit begin wrapper function
	local first_ch, rest = string.match(func_name, "gl(.)(.+)")
	local wrapper_func_name = util.tolower(first_ch) .. rest
	if lua_keyword_sub[wrapper_func_name] then
		wrapper_func_name = lua_keyword_sub[wrapper_func_name] 
	end
	local wrapper_code = string.format("static int lw_%s(lua_State* L) {\n", wrapper_func_name)

	-- parse all params, emit code to collect values from lua stack
  local n = 0
	params = util.trim(params)
	local args = ""
	local toks = util.split(params, ",")
	local num_args = #toks
	for i, param in ipairs(toks) do
    n = n + 1
		local tparam = util.trim(param)
--    print(string.format("  arg %2d: [%s]", n, targ))
		local param_type, param_ident = string.match(tparam, "(.-)([_%a][_%w]*)$")
		param_type = util.trim(param_type)
		param_ident = util.trim(param_ident)
		if param_ident == "void" and param_type == "" then
			param_type = param_ident
			param_ident = ""
		end
		local lua_param_type = handled_param_types[param_type]
		handled = lua_param_type ~= nil
		if not handled then
print(string.format("param_type [%s] NOT HANDLED: %s", param_type, decl))
			return
		end
--print(string.format("  param %2d: [%s] [%s] lua_param_type: [%s]", n, param_type, param_ident, lua_param_type))
		local arg_ln = ""
		if lua_param_type == "integer" then
			local stack_index = (n - num_args) - 1
			arg_ln = string.format("  int %s = lua_tointeger(L, %d);\n", param_ident, stack_index)
			if #args > 0 then
				args = args .. ","
			end
			args = args .. string.format("\n    %s", param_ident)
		elseif lua_param_type == "float" then
			local stack_index = (n - num_args) - 1
			arg_ln = string.format("  float %s = lua_tonumber(L, %d);\n", param_ident, stack_index)
			if #args > 0 then
				args = args .. ","
			end
			args = args .. string.format("\n    %s", param_ident)
		elseif lua_param_type == "double" then
			local stack_index = (n - num_args) - 1
			arg_ln = string.format("  double %s = lua_tonumber(L, %d);\n", param_ident, stack_index)
			if #args > 0 then
				args = args .. ","
			end
			args = args .. string.format("\n    %s", param_ident)
		elseif lua_param_type == "string" then
			local stack_index = (n - num_args) - 1
			arg_ln = string.format("  const char* %s = lua_tostring(L, %d);\n", param_ident, stack_index)
			if #args > 0 then
				args = args .. ","
			end
			args = args .. string.format("\n    %s", param_ident)
		else
		end
		wrapper_code = wrapper_code .. arg_ln
  end

	local nRet = 0

	-- emit code for assignment of return value if any from C function call
	if ret_type == "GLint" then
		wrapper_code = wrapper_code .. "  GLint rc = \n"
		nRet = 1
	end

	-- emit code for the C function call
	wrapper_code = wrapper_code .. string.format("  %s(%s);\n", func_name, args) 

	-- push return val from C function on to lua stack
	if ret_type == "GLint" then
		wrapper_code = wrapper_code .. string.format("  lua_pushnumber(L, rc);\n")
	end
	wrapper_code = wrapper_code .. string.format("  return %d;\n", nRet)
	wrapper_code = wrapper_code .. "}\n"
--print(string.format("%32s: args: [%s], ret: [%s]", func_name, args, ret_type))
--	local fh = io.open(wrapper_fname, "w")
--	fh:write(wrapper_code)
--	fh:close()
--	io.output(wrapper_fname)	
--	io.write(wrapper_code)
--	print(wrapper_code)
	local reg_entry = string.format('  {"%s", lw_%s},\n', wrapper_func_name, wrapper_func_name)
	return wrapper_code, reg_entry
end

--]]

function get_lw_func_name(func_name)
	local first_ch = string.sub(func_name, 1, 1)
  local rest = string.sub(func_name, 2)
	local lw_func_name = util.tolower(first_ch) .. rest
  -- TODO: strip prefix if specified
  if opts.remove_prefix then
    local npre = #opts.remove_prefix
    if #lw_func_name >= npre then
      local pre = string.sub(lw_func_name, 1, npre)
      if pre == opts.remove_prefix then
        lw_func_name = string.sub(lw_func_name, npre + 1)
      end
    end
  end
  -- TODO: do lua keyword sub
--[[  
	if lua_keyword_sub[lw_func_name] then
		lw_func_name = lua_keyword_sub[lw_func_name] 
	end
]]
  return lw_func_name
end

-- parses src file returns table of function declarations as strings
function get_function_declarations(decl_fname)
  io.input(decl_fname)
  local decls = {}
  local cur_decl = ""
  local i = 0
  for ln in io.lines() do
    i = i + 1
    ln = util.trim(ln)
    -- blank ln
    if #ln == 0 then
    -- preproc
    elseif string.sub(ln, 1, 1) == "#" then
    -- decl
    else
      cur_decl = cur_decl .. ln  
    end

    -- end decl
    if string.sub(ln, #ln) == ";" then
      decls[#decls + 1] = cur_decl
      cur_decl = ""
    end
  end
  io.close()
  return decls
end

-- parses string of function parameters, returns table of param data suitable for generating the wrapper code
function get_params(param_decls)
  local params = {}
  for i, p in ipairs(param_decls) do
--print(string.format("get_params(): i: %2d, p: [%s]", i, p))
    if p == "void" then
    else  
      local ctype, cident = string.match(p, "^(.-)([_%a][_%w]*)$")
--      print(string.format("  param %2d: [%s]", i, p))
        print(string.format("  param %2d: [%s] [%s]", i, ctype, cident))
        local param = {}
        param.ctype = ctype
        param.cident = cident
        params[#params + 1] = param
    end
  end
  --   create param table:
  --       ctype
  --       cident
  --       luatype

  -- cident is final token
  -- ctype is all but final token
  return params
 end

-- reads list of functions from a file specified by command-line opt, only functions in the list will get wrappers
function read_sel_funcs()
  sel_funcs = {}
  io.input(opts.sel_funcs)
  for ln in io.lines() do
    local func_name = util.trim(ln)
    sel_funcs[func_name] = true 
  end
  io.close()
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
  else  
  end
  return c_ret_type, lua_ret_type 
end

-- returns wrapper code for param function declaration, and a 'register func' line
function gen_func_wrapper(decl)
--  print(string.format("decl: [%s]", decl))
  local ret_decl, func_name, params_decl = string.match(decl, "^%s*(.-)%s+([_%a][_%w]+)%s*%((.*)%)%s*;%s*$") 
  if opts.sel_funcs and not is_sel_func(func_name) then
    return
  end
--print(string.format("  ret_decl: [%s],\n  func_name: [%s],\n  params: [%s]", ret_decl, func_name, params_decl))
  -- parse ret_type, func_name and params
  --   get param defs
  --   emit beg func                            ex: static int lw_clearColor(lua_State* L) {
  --   emit code to get args from lua stack     ex: float red = lua_tonumber(L, -4);
  --   emit beg func call                       ex:   glClearColor(
  --   emit cargs                               ex:     red,
  --   emit end func call                       ex:   );
  --   emit push cret to lua stack
  --   emit ret count                           ex: return 0;
  --   emit end func                            ex: }

--debug_console()
  -- get param defs
  local params = {}
  if #params_decl > 0 then
    local param_decls_nt = util.split(params_decl, ",")
    local param_decls = {}
    for i, p in ipairs(param_decls_nt) do
      param_decls[#param_decls + 1] = util.trim(p)
    end
    params = get_params(param_decls)
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
  end

	-- emit assign ret val
  local c_ret_type, lua_ret_type = get_return_types(ret_decl)
	local nRet = 0
	if c_ret_type ~= "void" then
		s = string.format("  %s ret_val = \n", c_ret_type)
    func_def = func_def .. s
		nRet = 1
	end

  -- emit beg cfunc call
  s = string.format("  %s(\n", func_name)
  func_def = func_def .. s

  -- TODO: emit cargs

  -- emit end cfunc call
  s = string.format("  );\n")
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

--debug_console()

  -- read from input file
  local ndefs = 0
  local func_defs = ""
  local func_regs = ""
  local decls = get_function_declarations(decl_fname)
  for i, decl in ipairs(decls) do
    local func_def, func_reg = gen_func_wrapper(decl)  
    if func_def then
      func_defs = func_defs .. func_def
      func_regs = func_regs .. func_reg
      ndefs = ndefs + 1
    end
  end

  -- output
	io.output(func_def_fname)	
	io.write(func_defs)
	io.close()
	io.output(func_reg_fname)
	io.write(func_regs)
	io.close()
print(string.format("%d func(s) written to %s, %s", ndefs, func_def_fname, func_reg_fname))
end

main()

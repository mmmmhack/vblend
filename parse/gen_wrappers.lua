-- gen_wrappers.lua  : generates lua function wrapper code for C header files

package.path=package.path .. ';../parse/?.lua'
package.path=package.path .. ';../test/lua/?.lua'
require('util')
require('getopt')

--local preproc_fname = "preproc_gl.h"
local wrapper_fname = "wrapper_funcs.c"
local reg_fname = "reg_list.c"

local usage_desc = [[
Usage: gen_wrappers [options] 
Reads C header file from stdin, generates lua function wrappers from function declarations.
]]

local old_desc = [[
Options:
  -p, --remove-prefix PREFIX    remove PREFIX from function names
  -s, --sel-funcs SEL_FILE      only generate wrappers for list of function names in SEL_FILE
  -h, --help                    show this help
]]

local opt_defs = {
  src_file = {
    short_opt = 'f',
    long_opt = 'src-file',
    has_arg = true,
    descrip = 'read declarations from FILE',
    arg_descrip = 'FILE',
  },
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

local opts = nil

function getopts(args)
  opts = getopt.parse(args, opt_defs)  
  if not opts then
    os.exit(1)
  end    
  if opts.help then
    getopt.usage(usage_desc, opt_defs) 
    os.exit(0)
  end
end

local lua_keyword_sub = {
	['begin'] = 'Begin',
	['end'] = 'End',
}

--[[
local selected_funcs = {
	['glBegin'] = true,
	['glBlendFunc'] = true,
	['glClear'] = true,
	['glClearColor'] = true,
	['glColor3f'] = true,
	['glColor4f'] = true,
	['glEnd'] = true,
	['glLoadIdentity'] = true,
	['glMatrixMode'] = true,
	['glOrtho'] = true,
	['glVertex2f'] = true,
	['glVertex3f'] = true,
}
--]]

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

function get_function_declarations()
  if opts.src_file then
    io.input(opts.src_file)
  end
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
  return decls
end

function gen_func_wrapper(decl)
  print(string.format("decl: [%s]", decl))
end

function main()
  -- getopts
  getopts(arg)

  -- read from stdin
  local decls = get_function_declarations()
  for i, decl in ipairs(decls) do
    gen_func_wrapper(decl)  
  end

--[[
	io.output(wrapper_fname)	
	io.write(wrappers)
	io.close()

	io.output(reg_fname)
	io.write(reg_list)
	io.close()
--]]
end

main()

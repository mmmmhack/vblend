-- gen_wrappers.lua  : generates function wrapper code from gl.h, for a subset of functions

package.path=package.path .. ';../test/lua/?.lua'
require('util')

--local gl_h_fname = "/opt/local/include/GL/gl.h"

local preproc_fname = "preproc_gl.h"
local wrapper_fname = "wrapper_funcs.c"
local reg_fname = "reg_list.c"

local lua_keyword_sub = {
	['begin'] = 'Begin',
	['end'] = 'End',
}

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

-- returns fname of new header file with comments stripped
-- TODO: support quote mode
function main()
	-- read header file, produce new one without C comments
--	local preproc_fname = preproc_header_file(gl_h_fname)

	local wrappers = ""
	local reg_list = ""
  local fin = io.open(preproc_fname, "r")
  if not fin then
    error("failed opening file: " .. preproc_fname)
  end
	local in_glapi = false
	local cur_func = nil
	local glapi_decl = nil
  local i = 0
  for ln in fin:lines() do
    i = i + 1
    ln = util.trim(ln)

--print(string.format("in_glapi: %s: ln: %s", tostring(in_glapi), ln))

		-- not in glapi declaration
		if not in_glapi then

			 -- detect GLAPIENTRY lines 
  		local ret_type, func_name = string.match(ln, "GLAPI%s+(%S-)%s+GLAPIENTRY ([_%a][_%w]*).+") 
			if func_name then 
				in_glapi = true
				cur_func = func_name
				glapi_decl = ln

			end

			-- go right back out if ; on same line
			if in_glapi and string.match(ln, ";%s*$") then
				in_glapi = false
			
				-- process selected funcs
				if selected_funcs[cur_func] then
--					print(string.format("  parsing func_name: [%s]", func_name))
					local wrapper, reg = gen_func_wrapper(glapi_decl)
					wrappers = wrappers .. wrapper
					reg_list = reg_list .. reg
				end
				cur_func = nil
			end

		-- in multi-line glapi declaration
		else
			glapi_decl = glapi_decl .. ln

			-- detect end of declaration
			if string.match(ln, ";%s*$") then
				in_glapi = false

				-- process selected funcs
				if selected_funcs[cur_func] then
--					print(string.format("  parsing func_name: [%s]", cur_func))
					local wrapper, reg = gen_func_wrapper(glapi_decl)
					wrappers = wrappers .. wrapper
					reg_list = reg_list .. reg
				end
				cur_func = nil
			end
   end

  end
  fin:close()

	io.output(wrapper_fname)	
	io.write(wrappers)
	io.close()

	io.output(reg_fname)
	io.write(reg_list)
	io.close()

end
main()

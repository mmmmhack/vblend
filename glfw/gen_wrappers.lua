-- gen_wrappers.lua  : generates function wrapper code from glfw.h

package.path=package.path .. ';../test/lua/?.lua'
require('util')

local glfw_dir = os.getenv('glfw_dir')
local glfw_h_fname = string.format("%s/include/GL/glfw.h", glfw_dir)

local wrapper_fname = "wrapper_funcs.c"
local reg_fname = "reg_list.c"

local handled_return_types = {
	['int']=true, 
	['long']=true,
	['void']=true,
}

local handled_param_types = {
	['int']=true, 
	['long']=true,
	['const char *']=true,
	['void']=true,
}

function gen_func_wrapper(ln)
  local ret_type, func_name, params = string.match(ln, "GLFWAPI%s+(%S+)%s+GLFWAPIENTRY (%w+)%((.+)%)") 
	local handled = handled_return_types[ret_type] ~= nil
	if not handled then
		return
	end
--  print(ln)

	-- emit begin wrapper function
	local first_ch, rest = string.match(func_name, "glfw(.)(.+)")
	local wrapper_func_name = util.tolower(first_ch) .. rest
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
		handled = handled_param_types[param_type] ~= nil
		if not handled then
--			print(string.format("param_type [%s] NOT HANDLED: %s", param_type, ln))
			return
		end
--		print(string.format("  param %2d: [%s] [%s]", n, param_type, param_ident))
		local arg_ln = ""
		if param_type == "int" or param_type == "long" then
			local ltype = "number"
			local stack_index = (n - num_args) - 1
			arg_ln = string.format("  int %s = lua_to%s(L, %d);\n", param_ident, ltype, stack_index)
			if #args > 0 then
				args = args .. ","
			end
			args = args .. string.format("\n    %s", param_ident)
		elseif param_type == "const char *" then
			local ltype = "string"
			local stack_index = (n - num_args) - 1
			arg_ln = string.format("  const char* %s = lua_to%s(L, %d);\n", param_ident, ltype, stack_index)
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
	if ret_type == "int" then
		wrapper_code = wrapper_code .. "  int rc = \n"
		nRet = 1
	end

	-- emit code for the C function call
	wrapper_code = wrapper_code .. string.format("  %s(%s);\n", func_name, args) 

	-- push return val from C function on to lua stack
	if ret_type == "int" then
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

function main()
	local wrappers = ""
	local reg_list = ""
  local fin = io.open(glfw_h_fname, "r")
  if not fin then
    error("failed opening file: " .. glfw_h_fname)
  end
  local i = 0
  for ln in fin:lines() do
    i = i + 1
    ln = util.trim(ln)
    local skip = false

    -- skip blank lines
    if #ln == 0 then
      skip = true
    -- skip preproc lines
    elseif string.sub(ln, 1, 1) == "#" then 
      skip = true
     -- process GLFWAPIENTRY lines 
    elseif string.match(ln, "GLFWAPIENTRY") then 
      -- print(ln)
      local wrapper, reg = gen_func_wrapper(ln)
			if wrapper ~= nil then
				wrappers = wrappers .. wrapper
				reg_list = reg_list .. reg
			end
    else  
    end
  end
  fin:close()
--  print(i .. " lines read from file " .. glfw_h_fname)

	io.output(wrapper_fname)	
	io.write(wrappers)
	io.close()

	io.output(reg_fname)
	io.write(reg_list)
	io.close()

end
main()

-- gen_constants.lua  : generates constant definition code from gl.h

package.path=package.path .. ';../gamelib/?.lua'
require('util')

--local glfw_dir = os.getenv('glfw_dir')
--local glfw_h_fname = string.format("%s/include/GL/glfw.h", glfw_dir)
local preproc_fname = "preproc_gl.h"
local const_defs_fname = "constant_defs.c"

local selected_defines = {
	["GL_COLOR_BUFFER_BIT"] = true,
	["GL_DEPTH_BUFFER_BIT"] = true,
	["GL_FALSE"] = true,
	["GL_LINES"] = true,
	["GL_LINE_LOOP"] = true,
	["GL_MODELVIEW"] = true,
	["GL_POINTS"] = true,
	["GL_POLYGON"] = true,
	["GL_PROJECTION"] = true,
	["GL_QUADS"] = true,
	["GL_QUAD_STRIP"] = true,
	["GL_TEXTURE"] = true,
	["GL_TRIANGLES"] = true,
	["GL_TRIANGLE_FAN"] = true,
	["GL_TRIANGLE_STRIP"] = true,
	["GL_TRUE"] = true,
}
local defines = {}

-- evaluates a #define expression and returns the result
function eval_def(def_expr)
	local val = loadstring('return ' .. def_expr)()	
	return val
end

function gen_const_def(ln)
--	print(string.format("--- scanning ln: %s", ln))
	
	-- match define name and expr
	local cname, cdef = string.match(ln, "^%s*#define ([_%a][_%w]*)%s+(.+)")
--	print(string.format("cname: [%s], cdef: [%s]", cname, cdef))

	-- do simple recursive define lookups on define
	local done = false
	while not done do
		-- match hex val
		local pre, def, post = string.match(cdef, "(.-)(0x[0-9a-fA-F]+)(.*)")
		if not def then
			-- match identifier
			pre, def, post = string.match(cdef, "(.-)([_%a][_%w]*)(.*)")
		end
--		print(string.format("  pre: [%s], def: [%s], post: [%s]", tostring(pre), tostring(def), tostring(post)))
		if def == nil then
			done = true
		else
			local spre = pre and pre or ""
			local spost = post and post or ""
			local edef = def
			-- lookup previous define
			local prev_def_val = defines[def]
			if prev_def_val ~= nil then
				edef = prev_def_val
--				print(string.format("  found pre-defined value of [%s]: [%s]", tostring(def), tostring(prev_def_val)))
			end
			local expr = spre .. edef .. spost
			local val = eval_def(expr)
--			print(string.format("  assigning new val [%s] of expr [%s] to cdef ", tostring(val), tostring(expr)))
			cdef = val
		end
	end
	local const_val = eval_def(cdef)
--print(string.format("  eval_def(%s): %s", tostring(cdef), tostring(const_val)))
--print(string.format("  saving define [%s]: [%s] (0x%x)", tostring(cname), tostring(const_val), tonumber(const_val)))
	
	-- save define in table for recursive lookups
	defines[cname] = const_val

	-- emit C code to define the const in the glfw table
	local def_ret = string.format("  lua_pushnumber(L, %s);\n", tostring(const_val))
	def_ret = def_ret .. string.format('  lua_setfield(L, -2, "%s");\n\n', cname)
	return def_ret
end

function main()
	local const_defs = [[static void define_constants(lua_State* L) {
	// push table
  lua_getglobal(L, "gl");

]]
	-- read header file
  local fin = io.open(preproc_fname, "r")
  if not fin then
    error(string.format("failed opening file: %s", preproc_fname))
  end
  local i = 0
  for ln in fin:lines() do
    i = i + 1
    ln = util.trim(ln)
    local skip = false

    -- only process GL_XXX defines
    if string.match(ln, "^%s*#define GL_") then 
      -- print(ln)
      local const_def = gen_const_def(ln)
			if const_def == nil then
				error(string.format("const_def is nil for ln: %s", ln))
			end
			const_defs = const_defs .. const_def
    end
  end
  fin:close()
--  print(i .. " lines read from file " .. glfw_h_fname)

	const_defs = const_defs .. [[
	// pop table
	lua_pop(L, 1);

}// define_constants()

]]
	io.output(const_defs_fname)	
	io.write(const_defs)
	io.close()
end
main()


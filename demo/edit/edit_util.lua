-- edit_util.lua : utility for edit app

local modname = ...
local M = {}
_G[modname] = M
package.loaded[modname] = M

--[[
	descrip:
		Returns string rep of param 2d position object.
]]
M.pos2str = function(t)
	local s = string.format("(%d, %d)", t[0], t[1])
	return s
end

--[[
	descrip:
		Creates new 2d position object from param coords.
]]
M.new_pos = function(x, y)
	local t = {[0]=x, [1]=y}
	return t
end

--[[
	descrip:
		Splits line at param col into 3 pieces and returns them: (line_pre, ch, line_post)

	params:
		ln: type: string, descrip: line to split
		col: type: number, descrip: 0-based index of position to split at
]]	
M.split_line = function(ln, col)
	local ln_pre = string.sub(ln, 1, col-1 + 1) -- convert from 0-based to 1-based
	local ch = string.sub(ln, col + 1, col + 1)
	local ln_pst = string.sub(ln, col + 1 + 1)
	return ln_pre, ch, ln_pst
end

--[[
	descrip:
		Loads text from param file into param buffer.

	params:
		b: type: table, descrip: line_buf object
		fname: type: string, descrip: filename to read text from

	returns:
		rc: type: boolean, descrip: true if loaded, else false
		
]]
M.buf_load = function(b, fname)
	buffer.remove_all(b)
	local i = 0
	for line in io.lines(fname) do
		-- convert tabs to spaces
		local ln = string.gsub(line, "\t", "    ")
		buffer.insert_line(b, ln, i)
		i = i + 1
	end
	return true
end


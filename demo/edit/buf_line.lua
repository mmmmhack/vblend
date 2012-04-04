-- buf_line.lua	:	holds a line of text for an edit buffer
local modname = ...
local M = {}
_G[modname] = M
package.loaded[modname] = M

buf_line.new = function(line_text) 
	local t = {
		text = line_text or "",
		next_line = nil,
	}
	return t
end


-- util.lua	:	misc utilities
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

function isdigit(s)
	n = string.byte(s)
	return n >= string.byte("0") and n <= string.byte("9")
end

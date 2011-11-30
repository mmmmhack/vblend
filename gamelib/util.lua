-- util.lua	:	misc utilities
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.isdigit = function(s)
	local n = string.byte(s)
	return n >= string.byte("0") and n <= string.byte("9")
end

M.isprintable = function(ch)
	local n = string.byte(ch)
	local min = string.byte(' ')
	local max = string.byte('~')
	return n >= min and n <= max
end

M.ptable = function(t)
	for k,v in pairs(t) do
		print("k: [" .. k .. "], v: [" .. tostring(v) .. "]")
	end
end

M.trim = function(s)
	local r = string.match(s, "^%s*(.-)%s*$")
	return r
end

M.dump_debug_info = function (info, label)
	print(string.format("---%s: debug info:", label))
	for k,v in pairs(info) do
		print("  ", k, v)
	end
end

M.split = function (str, delim, maxSplit)
		-- Eliminate bad cases...
		if string.find(str, delim) == nil then
				return { str }
		end
		if maxSplit == nil or maxSplit < 1 then
				maxSplit = 0    -- No limit
		end
		local result = {}
		local pat = "(.-)" .. delim .. "()"
		local ntok = 0
		local lastPos
		for part, pos in string.gfind(str, pat) do
				ntok = ntok + 1
				result[ntok] = part
				lastPos = pos
				if ntok == maxSplit then break end
		end
		-- Handle the last field
		if ntok ~= maxSplit then
				result[ntok + 1] = string.sub(str, lastPos)
		end
		return result
end

M.tolower = function(c)
  local nA = string.byte('A')
  local nZ = string.byte('Z')
  local na = string.byte('a')
  local nL = na - nA
  local n = string.byte(c)
  local cr = c
  if n >= nA and n<= nZ then
    cr = string.char(n + nL)
  end
  return cr
end


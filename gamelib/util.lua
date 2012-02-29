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

-- this function doesn't appear to work correctly to tokenize
-- strings delimited by multiple spaces or varied whitespace. See the 'tokenize()' function below for an
-- alternative
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

M.join = function(toks, delim)
	local s = ""
	for i, tok in ipairs(toks) do
		if i ~= 1 then
			s = s .. delim
		end
		s = s .. tok
	end
	return s
end

M.tokenize = function(s, delim_pat)
  delim_pat = delim_pat or "%s+"
  local toks = {}
  local head_pos = 1
  local beg_pos, end_pos = string.find(s, delim_pat, 1)
  while beg_pos ~= nil do
    if head_pos < beg_pos then
      local tok = string.sub(s, head_pos, beg_pos - 1)
      toks[#toks + 1] = tok
    end
    head_pos = end_pos + 1
    beg_pos, end_pos = string.find(s, delim_pat, head_pos)
  end
  if head_pos <= #s then
    local tok = string.sub(s, head_pos, #s)
    toks[#toks + 1] = tok
  end
  return toks
end

M.test_tokenize = function()
  local tests = {
   [1] = {
    s = "", exp_toks = {},
   },
   [2] = {
    s = " ", exp_toks = {},
   },
   [3] = {
    s = "1", exp_toks = {'1',},
   },
   [4] = {
    s = " 1", exp_toks = {'1',},
   },
   [5] = {
    s = "1 ", exp_toks = {'1',},
   },
   [6] = {
    s = " 1 ", exp_toks = {'1',},
   },
   [7] = {
    s = "1 2", exp_toks = {'1', '2'},
   },
   [8] = {
    s = " 1 2", exp_toks = {'1', '2'},
   },
   [9] = {
    s = "1 2 ", exp_toks = {'1', '2'},
   },
   [10] = {
    s = " 1 2 ", exp_toks = {'1', '2'},
   },
   [11] = {
    s = " 11 22  ", exp_toks = {'11', '22'},
   },
   [12] = {
    s = " 11 22  333", exp_toks = {'11', '22', '333'},
   },
  }
  for i, t in ipairs(tests) do
    local toks = M.tokenize(t.s)
    assert(toks)
    assert(#toks == #t.exp_toks)
    for j = 1, #toks do
      if toks[j] ~= t.exp_toks[j] then
        print(string.format("test %d: toks[%d] = [%s], exp_toks[%d] = [%s]", i, j, toks[j], j, t.exp_toks[j]))
      end
      assert(toks[j] == t.exp_toks[j])
    end
  end
end

-- function below seems irrelevant because of builtin string.lower()
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

M.readlines = function(fname)
	local fh = io.open(fname)
	local lines = {}
	for ln in fh:lines() do
		lines[#lines + 1] = ln
	end
	return lines
end


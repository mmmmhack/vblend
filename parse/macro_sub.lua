-- macro_sub.lua  : does token substitution

package.path=package.path .. ';../parse/?.lua'
package.path=package.path .. ';../gamelib/?.lua'
require('util')
require('getopt')

local defines_fname = arg[1]
local defines = dofile(defines_fname)
--local buf = io.read(math.huge)
local math_reallybig = 1000000000
local buf = io.read(math_reallybig)
for src, dst in pairs(defines) do
  buf = string.gsub(buf, src, dst)
end
io.write(buf)

-- macro_sub.lua  : does token substitution

package.path=package.path .. ';../parse/?.lua'
package.path=package.path .. ';../test/lua/?.lua'
require('util')
require('getopt')
require('tf_debug')

local defines_fname = arg[1]
local defines = dofile(defines_fname)
local buf = io.read(math.huge)
for src, dst in pairs(defines) do
  buf = string.gsub(buf, src, dst)
end
io.write(buf)

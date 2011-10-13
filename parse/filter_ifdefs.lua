-- filter_ifdefs.lua  : filters out [a subset of] '#ifXXX ... #endif' lines read from stdin, writes to stdout

-- TODO: add support for #else, #elsif

package.path=package.path .. ';../parse/?.lua'
require('getopt')

local usage_desc = [[
Usage: filter_ifdefs [options]
Reads C header file from stdin, emits #if/#endif filtered blocks to stdout
]]

local opt_defs = {
  defines_file = {
    short_opt = 'd',
    long_opt = 'defines',
    has_arg = true,
    descrip = "read lua table of entries ['#if...'] = [defined_value]",
    arg_descrip = 'DEFINES_FILE',
  },
  help = {
    short_opt = 'h',
    long_opt = 'help',
    has_arg = false,
    descrip = 'show this help',
  },
}
local opts = nil

local defines = {}
local conditions = {}

function current_condition()
  local cond = conditions[#conditions]
  return cond
end

function is_defined(cond)
if cond == nil then
  return false
end
--print(string.format("is_defined(): looking for define for cond [%s], #defines: %d", tostring(cond), #defines))

for k,v in pairs(defines) do
--  print(string.format(" define[%s]=[%s]", tostring(k), tostring(v)))
end
  local val = defines[cond]
  return val
end

function main()
  -- process cmd-line opts
  opts, non_opt_args = getopt.parse(arg, opt_defs)
  if opts.help then
    getopt.usage(usage_desc, opt_defs)
    os.exit(0)
  end
  if opts.defines_file then
--print(string.format("reading opts.defines_file: %s", tostring(opts.defines)))
    defines = dofile(opts.defines_file)
--print(string.format("defines: [%s]", tostring(defines)))
  end

  -- process stdin
  for ln in io.lines() do
--print(string.format("#conditions: %d, ln: [%s]", #conditions, ln))
    -- #if, inc level
    if string.match(ln, "^%s*#%s*if") then
      conditions[#conditions + 1] = ln
    -- #endif, dec level
    elseif string.match(ln, "^%s*#%s*endif") then
      conditions[#conditions] = nil
    -- non-conditional line
    else
      local cc = current_condition()
--print(string.format("cc: [%s], is_defined(cc): %s", tostring(cc), tostring(is_defined(cc))))
      if is_defined(cc) then
        io.write(ln .. "\n")
      end
    end
  end
end

main()


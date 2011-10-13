-- strip_defines.lua :  reads from stdin, skips all lines with '^%s*#%s*define', outputs to stdout

for ln in io.lines() do
  if not string.match(ln, '^%s*#%s*define') then
    io.write(ln .. "\n")
  end
end

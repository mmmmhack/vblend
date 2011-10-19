-- strip_includes.lua :  reads from stdin, skips all lines with '^%s*#%s*include', outputs to stdout

for ln in io.lines() do
  if not string.match(ln, '^%s*#%s*include') then
    io.write(ln .. "\n")
  end
end

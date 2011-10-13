-- strip_blank_lines.lua :  reads from stdin, skips all blank lines, outputs to stdout

for ln in io.lines() do
  if not string.match(ln, '^%s*$') then
    io.write(ln .. "\n")
  end
end

-- join_continued_lines.lua :  reads from stdin, joins any line ending with '\' to the next, outputs to stdout

local prev_ln = nil
for ln in io.lines() do
  if prev_ln == nil then
    prev_ln = ln
  else 
    local pos = string.find(prev_ln, "\\%s*$")
    if pos ~= nil then
      if pos == 1 then
        prev_ln = ln
      else
        prev_ln = string.sub(prev_ln, 1, pos - 1) .. ln
      end
    else
      io.write(prev_ln .. "\n")
      prev_ln = ln
    end
  end
end
-- output final ln if any
if prev_ln ~= nil then
  io.write(prev_ln .. "\n")
end

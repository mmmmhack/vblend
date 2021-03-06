-- strip_c_comments.lua : reads from stdin, strips C-style comments from a .c file, writes to stdout

--local preproc_fname = "preproc_gl.h"

function preproc_header_file()
--  io.stderr:write("beg preproc\n")
  --local buf = io.read(math.huge)
  local math_reallybig = 1000000000
	local buf = io.read(math_reallybig)
  io.close()

  local bufout = ""
  local in_comment = false
  local cp = nil
  for i = 1, #buf do
--[[
    if i % 1000 == 0 then
      io.stderr:write(i, "\n")
    end
--]]
    local c = string.sub(buf, i, i)   
    -- non-comment mode
    if not in_comment then
      if cp == '/' and c == '*' then
        in_comment = true
        bufout = string.sub(bufout, 1, #bufout - 1) -- remove '/'
      else
        bufout = bufout .. c
      end
    -- comment mode
    else
      if cp == '*' and c == '/' then
        in_comment = false
      end
    end
    cp = c
  end

--  io.stderr:write("end preproc\n")
  io.write(bufout)
  
end

preproc_header_file()


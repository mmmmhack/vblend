-- preproc_header.lua

local preproc_fname = "preproc_gl.h"

function preproc_header_file(fname)
	io.input(fname)
	local buf = io.read(math.huge)
	io.close()

	print("beg preproc")
	local bufout = ""
	local in_comment = false
	local cp = nil
	for i = 1, #buf do
		if i % 1000 == 0 then
			print(i)
		end
		local c = string.sub(buf, i, i)		
		-- non-comment mode
		if not in_comment then
			if cp == '/' and c == '*' then
				in_comment = true
				bufout = string.sub(bufout, 1, #bufout - 1)	-- remove '/'
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

	io.output(preproc_fname)
	io.write(bufout)
	
	print(string.format("end preproc: created %s", preproc_fname))
--	return preproc_fname
end

fname = ...
preproc_header_file(fname)


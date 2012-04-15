-- strip_cpp_comments.lua : reads from stdin, strips C++-style comments from a file, writes to stdout

function strip()
	--local buf = io.read(math.huge)
  local math_reallybig = 1000000000
	local buf = io.read(math_reallybig)
	io.close()

	local bufout = ""
	local in_comment = false
	local cp = nil
	for i = 1, #buf do
		local c = string.sub(buf, i, i)		
		-- non-comment mode
		if not in_comment then
			if cp == '/' and c == '/' then
				in_comment = true
				bufout = string.sub(bufout, 1, #bufout - 1)	-- remove '/'
			else
				bufout = bufout .. c
			end
		-- comment mode
		else
			if c == '\n' then
				in_comment = false
				bufout = bufout .. c
			end
		end
		cp = c
	end

	io.write(bufout)
	
end

strip()


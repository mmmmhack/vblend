-- gen_ape.lua	:	generates skeleton <step> elements from file of source:line lines
require('util')

function main()
	if #arg < 1 then
		io.stderr:write("usage: gen_ape INFILE\n")
		os.exit(1)
	end
	local infile = arg[1]
	local lines = util.readlines(infile)
--	util.ptable(lines)
	for i, ln in ipairs(lines) do
		print(string.format('<step location="%s">', ln))
		print("<narrative>")
		print("</narrative>")
		print("</step>")
		print("")
	end

end
main()

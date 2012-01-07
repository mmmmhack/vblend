require('rixml51')
require('debugger')

function ptable(t, level)
	local indent = string.rep(" ", level * 2)
	print(string.format(" {\n", indent))
	for k, v in pairs(t) do
		io.write(string.format("%s  [%s]: %s", indent, k, tostring(v)))
		if type(v) == "table" then
			ptable(v, level + 1)
		else
			io.write(",\n")
		end
	end
	io.write(string.format("%s},\n", indent))
end

function get_steps(xml_t)
end

function main()
	local infile = "ape_lua.xml"
	if #arg == 1 then
		infile = arg[1]
	end
	local s = io.open(infile):read("*a")
	print(string.format("%d bytes read from %s", #s, infile))
--debug_console()
	local t = collect(s)
	ptable(t, 0)
end

main()

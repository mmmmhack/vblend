-- gen_vim_ape.lua	:	reads ape xml file, generates vim script to load data into vim
require('rixml51')

-- converts lua table to vim list/dict
function table2vimstring(t)
	local def
	-- if array table, produce list
	if #t > 0 then
		def = "["
		for i, v in ipairs(t) do
			if i > 1 then
				def = def .. ","
			end
			def = def .. tovimstring(v)
		end
		def = def .. "]"
	else
		-- else, produce dict
		def = "{"
		local i = 0
		for k, v in pairs(t) do
			i = i + 1
			if i > 1 then
				def = def .. ","
			end
			def = def .. "'" .. k .. "' : " .. tovimstring(v)
		end
		def = def .. "}"
	end
	return def
end

function tovimstring(v)
	if type(v) == "number" then
		return tostring(number)
	elseif type(v) == "string" then
		-- TODO: check for single/double quotes
		return "'" .. v .. "'"
	elseif type(v) == "table" then
		return table2vimstring(v)
	end
end

-- extracts ape info from 'raw' xml-to-lua table
function get_steps(raw_xlt)
	local steps = {}
	local t = raw_xlt[1]
	-- first item is title element
	local i = 1
	local title_xlt = t[i]
	for i = 2, #t do
		local step = {}
		local step_xlt = t[i]
		assert(step_xlt['label'] == 'step')
		local attrs = step_xlt['xarg']
		step.location = attrs.location
		steps[#steps + 1] = step
	end
	return steps
end

function main()
	-- read xml
	local infile = "ape_lua.xml"
	local s = io.open(infile):read("*a")
	print(string.format("%d bytes read from %s", #s, infile))
	local t = collect(s)
	local steps = get_steps(t)

	-- write vim def
	local s = tovimstring(steps)
	print(s)
--	util.ptable(steps)

end

main()

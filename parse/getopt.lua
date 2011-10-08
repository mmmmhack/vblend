-- getopt.lua

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

--[[ 
-- accepts table of optdefs, returns table of opts

format of optdefs:
optdefs = {
	['delete_files'] = {
		short_opt = 'd',
		long_opt = 'delete-files',
		has_arg = true,
		default = '~/delete-list.txt',
		descrip = 'read list of files to be deleted from DELETE_LIST',
		arg_descrip = 'DELETE_LIST',
	},
}

if an arg as follows is given: '--delete-files ~/my-delete-list.txt',
the following will be returned:

opts = {
	['delete_files'] = '~/my-delete-list.txt',
}

it's description in usage will be:
	-d, --delete-files DELETE_LIST		read list of files to be deleted from DELETE_LIST
]]

M.err_msg = function (msg)
	io.stderr:write(msg)
end

M.is_opt = function(arg)
	return #arg > 0 and string.sub(arg, 1, 1) == '-'
end

M.is_longopt = function(arg)
	return #arg > 1 and string.sub(arg, 1, 2) == '--'
end

M.create_default_opts = function (opt_defs)
	local opts = {}
	for k, v in pairs(opt_defs) do
		if opt_defs[k]['default'] ~= nil then
			opts[k] = opt_defs[k]['default']
		end
	end
	return opts
end

M.find_optdef = function(arg, opt_defs)
	for opt_name, opt_def in pairs(opt_defs) do
		if M.is_longopt(arg) then
			if arg == "--" .. opt_def.long_opt then
				return opt_name, opt_def
			end
		else
			if arg == "-" .. opt_def.short_opt then
				return opt_name, opt_def
			end
		end
	end
end

M.usage = function (usage_desc, opt_defs)
	-- TODO: sort
	-- calc spacing of longest opt
	local max_len = 0
	for opt_name, opt_def in pairs(opt_defs) do
		local arg_descrip = opt_def['arg_descrip'] and opt_def['arg_descrip'] or ""
		local ln = string.format("  -%s, --%s %s", opt_def.short_opt, opt_def.long_opt, arg_descrip)
		max_len = math.max(max_len, #ln)
	end
	print(usage_desc)
	print("Options:")
	-- list opts
	for opt_name, opt_def in pairs(opt_defs) do
		local arg_descrip = opt_def['arg_descrip'] and opt_def['arg_descrip'] or ""
		local opt_syn = string.format("-%s, --%s %s", opt_def.short_opt, opt_def.long_opt, arg_descrip)
		local pad = max_len - #opt_syn
		local pad_opt_syn = opt_syn .. string.rep(" ", pad)
		local ln = string.format("  %s %s", pad_opt_syn, opt_def.descrip)
		print(ln)
	end
end

-- returns table 'opt' with options set, and remainder of non-option args from param args
M.parse = function (args, opt_defs)
	-- create default opts
	local non_opt_args = {}
	local opts = M.create_default_opts(opt_defs)

	-- for each arg:
	local i = 1
	while i <= #args do
		local arg = args[i]

		-- if opt arg:
		if M.is_opt(arg) then
			-- look for opt def
			local opt_name, opt_def = M.find_optdef(arg, opt_defs)
			-- if not found: 
			if not opt_def then
				M.err_msg(string.format("invalid option: %s\n", arg))
				return nil
			end

			-- get arg of option, if any
			if opt_def.has_arg then
				if i == #args or M.is_opt(args[i+1]) then
					M.err_msg(string.format("missing arg after option: %s\n", arg))
					return nil	
				end
				i = i + 1
				opts[opt_name] = args[i]
			-- else set bool value for opt
			else
				opts[opt_name] = true
			end
		-- else, non-opt arg
		else
			non_opt_args[#non_opt_args + 1] = arg
		end

		i = i + 1
	end
	return opts, non_opt_args
end



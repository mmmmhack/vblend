-- world.lua	:	defines the robot war environment

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

local bot_w = 50
local bot_h = 30

M.bots = {}

M.init = function(botfiles, world_w, world_h)
	local corner = 0
	local b = 20
	for i,f in ipairs(botfiles) do
		local bot_name = string.sub(f, 1, #f - 4)
		local bot = {}
		local x, y
		if corner == 0 then
			x = b
			y = b
		elseif corner == 1 then
			x = world_w - b - bot_w
			y = world_h - b - bot_h
		elseif corner == 2 then
			x = b
			y = world_h - b - bot_h
		elseif corner == 3 then
			x = world_w - b - bot_w
			y = b
		end
		bot.pos = {x = x, y = y}
		if corner < 4 then
			M.bots[bot_name] = bot
		end
		corner = corner + 1
	end
end

M.bot_pos = function(bot_name)
	local bot = M.bots[bot_name]
	local pos = {x = bot.pos.x, y = bot.pos.y}
	return pos
end

M.bot_size = function(bot_name)
	local size = {w = bot_w, h = bot_h}
	return size
end


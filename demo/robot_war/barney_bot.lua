-- barney_bot.lua

local M = {}

local max_v = 50

M.update = function(bot_name, dt)

	-- set new velocity with random probability
	if math.random() > 0.99 then
		print(string.format("%s: setting new vel", bot_name))
		local rnd_dir = math.random() < 0.5 and -1 or 1
		local vx = math.random() * max_v * rnd_dir
		local rnd_dir = math.random() < 0.5 and -1 or 1
		local vy = math.random() * max_v * rnd_dir
		bot_set_vel(bot_name, vx, vy)
	end
	-- fire new dir
	if math.random() > 0.99 then
		local deg = 360 * math.random() 
		bot_fire_gun(bot_name, deg)
	end
end

return M

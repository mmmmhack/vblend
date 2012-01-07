-- billy_bot.lua	:	currently same as barney bot

local M = {}

M.update = function(bot_name, dt)
	local max_v = bot_max_velocity(bot_name)

	-- set new velocity with random probability
	if math.random() > 0.99 then
		print(string.format("%s: setting new vel", bot_name))
		local rnd_dir = math.random() < 0.5 and -1 or 1
		local vx = math.random() * max_v * rnd_dir
		local rnd_dir = math.random() < 0.5 and -1 or 1
		local vy = math.random() * max_v * rnd_dir
		bot_set_vel(bot_name, vx, vy)
	end

	-- fire in other robot dir
	if not bot_reloading(bot_name) then
		local target_dir, target_dist = bot_scan_first_other_bot(bot_name)
		bot_fire_gun(bot_name, target_dir)
	else
--		print(string.format("%s: reloading", bot_name))
	end
end

return M

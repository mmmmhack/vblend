-- api.lua	:	global functions called by user scripts
require('geom')
require('strict')

--local bot_max_v = 50
--local gun_reload_time = 1
--local bullet_vel = 200
local gun_barrel_w = 35

function bot_set_vel(bot_name, new_vx, new_vy)
	local res = true
	local vx = new_vx
	vx = math.max(-world.bot_max_vel, vx)
	vx = math.min( world.bot_max_vel, vx)
	if vx ~= new_vx then
		res = false
	end
	local vy = new_vy
	vy = math.max(-world.bot_max_vel, vy)
	vy = math.min( world.bot_max_vel, vy)
	if vy ~= new_vy then
		res = false
	end
	local bot = world.bots[bot_name]
	bot.vel.x = vx
	bot.vel.y = vy
	return res
end

function bot_fire_gun(bot_name, dir)
	local bot = world.bots[bot_name]
	if bot.gun.reloading ~= 0 then
		print(string.format("%s: reloading for %f more seconds, can't fire, out of ammo", bot_name, bot.gun.reloading))
		return
	end
	bot.gun.dir = dir
	print(string.format("%s: boom!", bot_name))		
	local theta = geom.deg2rad(bot.gun.dir)
	local bullet = {
		pos = {
			x = bot.pos.x + bot.size.w/2 + math.cos(theta) * gun_barrel_w, 
			y = bot.pos.y + bot.size.h/2 + math.sin(theta) * gun_barrel_w
		},
		vel = {x = world.bullet_vel * math.cos(theta), y = world.bullet_vel * math.sin(theta)},
		exploding = false,
		explode_time = 0,
		radius = world.bullet_init_radius,
	}
	world.bullets[#world.bullets + 1] = bullet
	bot.gun.reloading = world.gun_reload_time
end

function bot_reloading(bot_name)
	local bot = world.bots[bot_name]
	return bot.gun.reloading ~= 0
end

function bot_scan_first_other_bot(bot_name)
	local src_bot = world.bots[bot_name]
	local vsrc = world.bot_pos(src_bot)
	for dst_name, dst_bot in pairs(world.bots) do
		if dst_bot ~= src_bot then
			local vdst = world.bot_pos(dst_bot)
			local vsd = vector3.sub(vdst, vsrc)
			local dist = vector3.magnitude(vsd)
			vsd = vector3.normalized(vsd)
			local rad = math.atan2(vsd.y, vsd.x)
			local deg = geom.rad2deg(rad)
			return deg, dist
		end
	end
end

function bot_max_velocity(bot_name)
	return world.bot_max_vel
end


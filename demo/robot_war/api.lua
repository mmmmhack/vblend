-- api.lua	:	global functions called by user scripts
require('geom')
require('strict')

local bot_max_v = 50
local gun_reload_time = 3
local bullet_vel = 200
local gun_barrel_w = 35

function bot_set_vel(bot_name, new_vx, new_vy)
	local res = true
	local vx = new_vx
	vx = math.max(-bot_max_v, vx)
	vx = math.min( bot_max_v, vx)
	if vx ~= new_vx then
		res = false
	end
	local vy = new_vy
	vy = math.max(-bot_max_v, vy)
	vy = math.min( bot_max_v, vy)
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
		vel = {x = bullet_vel * math.cos(theta), y = bullet_vel * math.sin(theta)},
	}
	world.bullets[#world.bullets + 1] = bullet
	bot.gun.reloading = gun_reload_time
end


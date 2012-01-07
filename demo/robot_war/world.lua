-- world.lua	:	defines the robot war environment

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

require('vector3')
require('debugger')

local gun_radius = 10
local gun_turret_color = {0.1, 0.1, 0.1}
local gun_barrel_w = 35
local gun_barrel_h = 10
local gun_barrel_color = {0.3, 0.3, 0.3}
local gun_reload_time = 1.5

local bullet_init_radius = 5
local bullet_color = {0.95, 0.7, 0.4}
local bullet_max_explode_time = 0.1
local bullet_explode_rate = 1000
local bullet_vel = 500
local bullet_explosion_damage_dt = 1

local bot_w = 50
local bot_h = 30
local bot_init_health = 100
local bot_max_vel = 50

local world_w = nil
local world_h = nil

local bot_colors = {
	[1] = {1, 0, 0},
	[2] = {0, 0, 1},
	[3] = {0, 1, 0},
	[4] = {1, 1, 0},
}

M.bots = {}
M.bullets = {}

M.init = function(botfiles, world_w_i, world_h_i)
	-- set world vars from local vars (TODO: fix this)
	M.gun_reload_time = gun_reload_time 
	M.running = true
	M.bullet_init_radius = bullet_init_radius
	M.bullet_vel = bullet_vel
	M.bot_init_health = bot_init_health 
	M.bot_max_vel = bot_max_vel 

	-- create bots
	world_w = world_w_i
	world_h = world_h_i
	local corner = 0
	local b = 20
	for i,f in ipairs(botfiles) do
		local bot_name = string.sub(f, 1, #f - 4)
		local bot = {}
		bot.size = {w = bot_w, h = bot_h}
		bot.name = bot_name
		bot.color = bot_colors[i]
		bot.script = dofile(f)
		bot.vel = {x = 0, y = 0}
		bot.gun = {dir = 0, reloading = 0}
		bot.health = M.bot_init_health

		-- calc bot pos
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
	local bot = M.bots[bot_name]
	local size = {w = bot.w, h = bot.h}
	return size
end

M.draw_bot = function(bot, num_bot)
	local pos = bot.pos
	local size = bot.size

	-- draw body
	local c = bot.color
	gl.color3f(c[1], c[2], c[3])
--		gamelib.draw_rect(pos.x, pos.y, size.w, size.h)
	gl.pushMatrix()
		local dir = vector3.new(bot.vel.x, bot.vel.y, 0)
--debug_console()
		dir = vector3.normalized(dir)
		if vector3.magnitude(dir) == 0 then
			bot.dir = vector3.new(1, 0, 0)
		else
			bot.dir = dir
		end
		local rad = math.atan2(bot.dir.y, bot.dir.x)
		local deg = geom.rad2deg(rad)
		gl.translatef(pos.x + size.w/2, pos.y + size.h/2, 0)
		gl.rotatef(deg, 0, 0, 1)
		gamelib.draw_rect(-size.w/2, -size.h/2, size.w, size.h)
	gl.popMatrix()

	-- draw gun barrel
	gl.color3f(gun_barrel_color[1], gun_barrel_color[2], gun_barrel_color[3])
	gl.pushMatrix()
		gl.translatef(pos.x + size.w/2, pos.y + size.h/2, 0)
		gl.rotatef(bot.gun.dir, 0, 0, 1)
		gamelib.draw_rect(0, -gun_barrel_h/2, gun_barrel_w, gun_barrel_h)
	gl.popMatrix()
	-- draw gun turret
	gl.color3f(gun_turret_color[1], gun_turret_color[2], gun_turret_color[3])
	gamelib.draw_circle(pos.x + bot.size.w/2, pos.y + bot.size.h/2, gun_radius)

	-- draw health
	local draw_health = true
	if draw_health then
--		local start_row = tfont.num_rows() - 1
		local start_row = 0
		local row = start_row + num_bot
		local col = 1
	--debug_console()
		local txt = string.format("%s health: %d", bot.name, bot.health)
		txt = txt .. string.rep(" ", tfont.num_cols() - #txt)
		tfont.set_text_buf(row, col, txt)
	end

end

M.draw_bullet = function(bullet)
	gl.color3f(bullet_color[1], bullet_color[2], bullet_color[3])
	gamelib.draw_circle(bullet.pos.x, bullet.pos.y, bullet.radius)
end

M.update_obj_pos = function(obj, dt)
	obj.pos.x = obj.pos.x + obj.vel.x * dt
	obj.pos.y = obj.pos.y + obj.vel.y * dt
end

M.calc_bot_world_collisions = function()
	local border = 5
	for name, bot in pairs(M.bots) do
		if bot.pos.x < 0 or bot.pos.x + bot.size.w > world_w then
			print(string.format("%s: bonk!", bot.name))
			bot.vel.x = 0
			bot.vel.y = 0
			if bot.pos.x < 0 then
				bot.pos.x = border
			else
				bot.pos.x = world_w - bot.size.w - border
			end
		end
		if bot.pos.y < 0 or bot.pos.y + bot.size.h > world_h then
			print(string.format("%s: bonk!", bot.name))
			bot.vel.x = 0
			bot.vel.y = 0
			if bot.pos.y < 0 then
				bot.pos.y = border
			else
				bot.pos.y = world_h - bot.size.h - border
			end
		end
	end
	
end

M.calc_bullet_world_collisions = function()
	local border = bullet_init_radius
	for name, bullet in pairs(M.bullets) do
		-- ignore exploding bullets
		if not bullet.exploding then
			if bullet.pos.x < 0 or bullet.pos.x + bullet.radius > world_w then
	--			print(string.format("%s: bonk!", bullet.name))
				bullet.vel.x = 0
				bullet.vel.y = 0
				if bullet.pos.x < 0 then
					bullet.pos.x = border
				else
					bullet.pos.x = world_w - bullet.radius - border
				end
				bullet.exploding = true
			end
			if bullet.pos.y < 0 or bullet.pos.y + bullet.radius > world_h then
	--			print(string.format("%s: bonk!", bullet.name))
				bullet.vel.x = 0
				bullet.vel.y = 0
				if bullet.pos.y < 0 then
					bullet.pos.y = border
				else
					bullet.pos.y = world_h - bullet.radius - border
				end
				bullet.exploding = true
			end
		end
	end
end

M.update_explosions = function(dt)
	for name, bullet in pairs(M.bullets) do
		-- update explode state
		if bullet.exploding then
			bullet.explode_time = bullet.explode_time + dt
			bullet.radius = bullet_init_radius + bullet.explode_time * bullet_explode_rate
			if bullet.explode_time >= bullet_max_explode_time then
				bullet.exploding = false
				bullet.radius = 0
			end
		end
	end
end

M.calc_bullet_bot_collisions = function()
	for name, bullet in pairs(M.bullets) do
		local vbul = vector3.new(bullet.pos.x, bullet.pos.y, 0)
		for bname, bot in pairs(M.bots) do
			local vbot = vector3.new(bot.pos.x + bot.size.w/2, bot.pos.y + bot.size.h/2, 0)
			local dist = vector3.dist(vbul, vbot)
			if dist <= bullet.radius then
				if not bullet.exploding then
					bullet.exploding = true
				end
				local damage = bullet_explosion_damage_dt
				bot.health = bot.health - damage
				bot.health = math.max(0, bot.health)
--print(string.format("explosion damage to bot %s: health: %d", bot.name, bot.health))
--M.running = false
			end
		end
	end

end

M.calc_collisions = function()

	-- calc bot-bot collisions
	M.calc_bot_world_collisions()

	-- calc bullet-world collisions
	M.calc_bullet_world_collisions()

	-- calc bullet-bot collisions
	M.calc_bullet_bot_collisions()

end

M.update = function(dt)
	if M.running then
		-- call bot scripts
		for name, bot in pairs(M.bots) do
			if bot.health > 0 then
				bot.script.update(name, dt)
			end
		end
		
		-- update bots
		for name, bot in pairs(M.bots) do
			-- position
			M.update_obj_pos(bot, dt)
			-- gun reload
			if bot.gun.reloading ~= 0 then
				bot.gun.reloading = math.max(0, bot.gun.reloading - dt)
			end
		end
		-- update bullet positions
		for i, bullet in ipairs(M.bullets) do
			M.update_obj_pos(bullet, dt)
		end

		-- calc collisions
		M.calc_collisions()

		-- update bullet explosions
		M.update_explosions(dt)
	end

	-- draw bots
	local num_bot = 0
	for name, bot in pairs(M.bots) do
		num_bot = num_bot + 1
		M.draw_bot(bot, num_bot)
	end

	-- draw bullets
	for i, bullet in ipairs(M.bullets) do
		M.draw_bullet(bullet, dt)
	end

	-- draw text
  tfont.draw_text_buf()
end

M.bot_pos = function(bot)
 local vpos = vector3.new(bot.pos.x + bot.size.w/2, bot.pos.y + bot.size.h/2, 0)
 return vpos
end


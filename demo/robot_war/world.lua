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

local bullet_radius = 5
local bullet_color = {0.95, 0.7, 0.4}

local bot_w = 50
local bot_h = 30

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

M.draw_bot = function(bot)
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

end

M.draw_bullet = function(bullet)
	gl.color3f(bullet_color[1], bullet_color[2], bullet_color[3])
	gamelib.draw_circle(bullet.pos.x, bullet.pos.y, bullet_radius)
end

M.update_obj_pos = function(obj, dt)
	obj.pos.x = obj.pos.x + obj.vel.x * dt
	obj.pos.y = obj.pos.y + obj.vel.y * dt
end

M.calc_collisions = function()
	-- calc bot-world collisions
	local bump = 5
	for name, bot in pairs(M.bots) do
		if bot.pos.x < 0 or bot.pos.x + bot.size.w > world_w then
			print(string.format("%s: bonk!", bot.name))
			bot.vel.x = 0
			bot.vel.y = 0
			if bot.pos.x < 0 then
				bot.pos.x = bump
			else
				bot.pos.x = world_w - bot.size.w - bump
			end
		end
		if bot.pos.y < 0 or bot.pos.y + bot.size.h > world_h then
			print(string.format("%s: bonk!", bot.name))
			bot.vel.x = 0
			bot.vel.y = 0
			if bot.pos.y < 0 then
				bot.pos.y = bump
			else
				bot.pos.y = world_h - bot.size.h - bump
			end
		end
	end
	
	-- calc bot-bot collisions
end

M.update = function(dt)
	-- call bot scripts
	for name, bot in pairs(M.bots) do
		bot.script.update(name, dt)
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

	-- draw bots
	for name, bot in pairs(M.bots) do
		M.draw_bot(bot)
	end

	-- draw bullets
	for i, bullet in ipairs(M.bullets) do
		M.draw_bullet(bullet, dt)
	end

end


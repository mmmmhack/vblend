-- barney_bot.lua

local M = {}

local bot_name = 'barney_bot'

M.draw = function()
	gl.color3f(1, 0, 1)
	local pos = world.bot_pos(bot_name)
	local size = world.bot_size(bot_name)
	gamelib.draw_rect(pos.x, pos.y, size.w, size.h)
end

M.update = function()
	M.draw()
end

return M

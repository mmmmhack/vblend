-- billy_bot.lua

local M = {}

M.draw = function()
	gl.color3f(0, 1, 0)
	local pos = world.bot_pos('billy_bot')
	local size = world.bot_size('billy_bot')
	gamelib.draw_rect(pos.x, pos.y, size.w, size.h)
end

M.update = function()
	M.draw()
end

return M

-- test_draw_circle.lua
require('gamelib')
require('debugger')

function main()

	local radius = 30
	gamelib.open_window("test draw_circle()")
	local run = true
	while run do
		gl.color3f(0, 0, 1)
		local x = gamelib.win_width() / 2
		local y = gamelib.win_height() / 2
		gamelib.draw_circle(x, y, radius)
		gamelib.update()
		if gamelib.window_closed() or glfw.getKey(glfw.GLFW_KEY_ESC) == glfw.GLFW_PRESS then
			run = false
		end
	end
end

main()

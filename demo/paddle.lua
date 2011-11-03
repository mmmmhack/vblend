-- paddle.lua	:	tests pong paddle drawing and movement
require('gamelib')

function main()
	gamelib.open_window()
	local done=false
	while not done do

		-- draw paddle
		-- get input
		-- update paddle pos

		-- check for quit
		gamelib.update()
		local quit_key = glfw.getKey(glfw.GLFW_KEY_ESC) == glfw.GLFW_PRESS
		if gamelib.window_closed() or quit_key then
			done = true
		end
	end
end

main()

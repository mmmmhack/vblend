-- light_sphere.lua	:	lighting test

require("gamelib")

function main()
	local rc = gamelib.open_window()
  gl.enable(gl.GL_DEPTH_TEST)
  gamelib.set_perspective()

	while true do
		gamelib.frame_start()

    gl.clear(gl.GL_DEPTH_BUFFER_BIT)


    if gamelib.window_closed() or glfw.getKey(glfw.GLFW_KEY_ESC)==glfw.GLFW_PRESS then
      break
    end

		gamelib.update()
		gamelib.frame_end()
	end
end

main()

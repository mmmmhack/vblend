-- depth_test.lua	:	tests depth buffer

require("gamelib")

function main()
	local rc = gamelib.open_window()
  gl.enable(gl.GL_DEPTH_TEST)
	while true do
		gamelib.frame_start()

    gl.clear(gl.GL_DEPTH_BUFFER_BIT)

    local d
    -- green tri
    d = 0
		gl.color3f(0, 1, 0)
		gl.Begin(gl.GL_TRIANGLES)
			gl.vertex3f(0, 0, d)
			gl.vertex3f(200, 0, d)
			gl.vertex3f(0, 200, d)
		gl.End()

    -- red tri
    d = -0.1
		gl.color3f(1, 0, 0)
		gl.Begin(gl.GL_TRIANGLES)
			gl.vertex3f(50, 0, d)
			gl.vertex3f(300, 0, d)
			gl.vertex3f(50, 300, d)
		gl.End()

    if gamelib.window_closed() or glfw.getKey(glfw.GLFW_KEY_ESC)==glfw.GLFW_PRESS then
      break
    end

		gamelib.update()
		gamelib.frame_end()
	end
end

main()

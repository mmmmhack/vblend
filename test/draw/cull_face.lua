-- cull_face.lua	:	tests state of face culling in opengl

require("gamelib")

function main()
	local rc = gamelib.open_window()
	gl.enable(gl.GL_CULL_FACE)
	while not gamelib.window_closed() do
		gamelib.frame_start()

		gl.color3f(0, 1, 0)
		gl.Begin(gl.GL_TRIANGLES)
			gl.vertex2f(0, 0)
			gl.vertex2f(200, 0)
			gl.vertex2f(0, 200)
		gl.End()

		gamelib.update()
		gamelib.frame_end()
	end
end

main()

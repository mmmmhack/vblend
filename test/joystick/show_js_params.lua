require('gamelib')

function main()
	local n = glfw.getJoystickParam(1, glfw.GLFW_PRESENT)
	print(string.format("joystick present: %s", tostring(n)))
end

main()


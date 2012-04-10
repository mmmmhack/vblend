-- draw_trans.lua : tests drawing of semi-transparent rectangle

require("gamelib")

function draw_rect()
  local w = gamelib.win_width() / 4
  local h = gamelib.win_height() / 4
  local b = 10
  local d = -0.1
  gl.color4f(0, 1, 0, 1)
  gl.Begin(gl.GL_QUADS)
    gl.vertex3f(b, b, d)
    gl.vertex3f(b + w, b, d)
    gl.vertex3f(b + w, b + h, d)
    gl.vertex3f(b, b + h, d)
  gl.End()
--  print(string.format("gl.GL_RECTANGLE: %s, gl.GL_NO_ERROR: %s", tostring(gl.GL_RECTANGLE), tostring(gl.GL_NO_ERROR)))
  local d = 0.0
  b = 50
  local s = 0.5
  local c = 0.3
  gl.color4f(c, c, c, s)
  gl.Begin(gl.GL_QUADS)
    gl.vertex3f(b, b, d)
    gl.vertex3f(b + w, b, d)
    gl.vertex3f(b + w, b + h, d)
    gl.vertex3f(b, b + h, d)
  gl.End()
end

function main()
  local rc = gamelib.open_window()
  local done = false
  gl.enable(gl.GL_BLEND)
  gl.blendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)
  while not done do

    draw_rect()

    gamelib.update()
    local esc_key_hit = glfw.getKey(glfw.GLFW_KEY_ESC) == gl.GL_TRUE
    if esc_key_hit or gamelib.window_closed() then 
      done = true
    end

    -- check for gl errors
    local err = gl.getError()
    if err ~= gl.GL_NO_ERROR then
      local err_str = glu.errorString(err)
      print(string.format("gl Error: err: %d, err_str: %s", err, err_str))
    end
  end
end

main()

-- pong.lua : demo game for gamelib

require('gamelib')

local r = { x=50, y=50, w=50, h=50 }
local xdir = 1
local ydir = 1

local win_w = 800 -- TODO: replace with gamelib.win_width()
local win_h = 600 -- TODO: replace with gamelib.win_height()

function draw()
  gl.color3f(0, 0.75, 0)
  gamelib.draw_rect(r.x, r.y, r.w, r.h)
end

function update()
  r.x = r.x + xdir
  r.y = r.y + ydir

  if (r.x + r.w >= win_w) or (r.x < 0) then
    xdir = -xdir
  end
  if (r.y + r.h >= win_h) or (r.y < 0) then
    ydir = -ydir
  end
end

function main()
  gamelib.open_window()

  local run = true
  while run do
    draw()
    update()

    gamelib.update()
    if gamelib.window_closed() then
      run = false
    end
  end
end

main()

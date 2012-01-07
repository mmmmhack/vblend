-- hello.lua	:	hello world demo for gamelib

-- set path to gamelib TODO: find a better way
--package.path = package.path .. ';../gamelib/?.lua'
--package.cpath = package.cpath .. ';../gamelib/?.so'

require('gamelib')
require('lua_tfont')

function main()
	gamelib.open_window()

  sys.chdir("/Users/williamknight/proj/git/vblend/demo")
  tfont.set_text_buf(10, 20, "howdy!")
	local run = true
	while run do
		
    tfont.draw_text_buf()

		gamelib.update()

		if gamelib.window_closed() then
			run = false
		end
	end

end

main()

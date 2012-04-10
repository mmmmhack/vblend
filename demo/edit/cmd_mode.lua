-- cmd_mode.lua : command-line mode routines
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

M.buf = nil   -- TODO: replace with better init? (currently set in editor.lua init())

-- cmd handlers
M.quit = function()
	quit()
end

M.cmd_handler = {
  ['q'] = M.quit,
}

M.add_handler = function(cmd, handler_func)
	local old_func = M.cmd_handler[cmd]
	M.cmd_handler[cmd] = handler_func
	return old_func
end

-- begin command-mode
M.begin = function ()

  -- show command prompt
  buffer.set(M.buf, ":")

  local col = 1
  local row = 0
  buffer.set_cursor(M.buf, {[0]=col, [1]=row})
end

-- shows err msg for invalid cmd
M.not_a_cmd = function(cmd)
  buffer.set(M.buf, "Error: not a command: " .. cmd)
--  M.update_scr()
end

-- public function to set cmd-line text, for when it's used as a status line
M.set_text = function(s)
  buffer.set(M.buf, s)
end

M.get_text = function()
  return buffer.get(M.buf).text
end

-- handles cmd entered from cmd-line
M.do_cmd = function(cmd)
  if #cmd == 0 then
    do return end
  end
  local h = M.cmd_handler[cmd]
  if h == nil then
    M.not_a_cmd(cmd)  
    do return end
  end
  h(cmd)
end

-- handles keyboard character input during command-line mode
M.char_pressed = function (ch)
--print("cmd_line: char_pressed_command(): ch: [" .. ch .. "]")

  -- backspace
  if      ch == editor.cc(ASC_BS) then
    local cmd_line = M.get_text()
    if #cmd_line <= 1 then  
      do return end
    end
    cmd_line = string.sub(cmd_line, 1, #cmd_line - 1)
    M.set_text(cmd_line)
    buffer.inc_cursor(M.buf, -1)

  -- enter
  elseif ch == editor.cc(ASC_RET) then
    -- get cmd
    local ln = buffer.get(M.buf).text
    local cmd = string.sub(ln, 2) 

    -- erase cmd-line
		buffer.set(M.buf, "")

    -- move screen cursor back to prev pos
		-- is this a hack? because the buffer._cursor_pos is getting set to itself,
		-- and we are relying on the side-effect of it also setting the screen cursor
		-- maybe should set the screen cursor directly?
    local b = editor.active_buf()
		local pos = buffer.get_cursor(b)
    buffer.set_cursor(b, pos)

    -- process command
    M.do_cmd(cmd) 
    
    editor.set_mode("normal")
  else
    -- append ch to cmd-line
    buffer.set(M.buf, buffer.get(M.buf).text .. ch)

    -- update cursor
    buffer.inc_cursor(M.buf, 1)
  end

end -- char_pressed


let g:ape_steps = [
\ {
\    'src_file' : "/Users/williamknight/proj/git/vblend/lua/lua.c",
\    'src_line' : "380",
\    'continue' : "step",
\    'narr' : "Lua entry point.\nCreates new lua_State.\n",
\ },
\ {
\    'src_file' : "/Users/williamknight/proj/git/vblend/lua/lauxlib.c",
\    'src_line' : "648",
\    'continue' : "step",
\    'narr' : "Calls internal func to create new lua_State.\n",
\ },
\ {
\    'src_file' : "/Users/williamknight/proj/git/vblend/lua/lstate.c",
\    'src_line' : "147",
\    'continue' : "step",
\    'narr' : "Allocates memory for lua_State struct.\n",
\ },
\ {
\    'src_file' : "/Users/williamknight/proj/git/vblend/lua/lauxlib.c",
\    'src_line' : "630",
\    'continue' : "step",
\    'narr' : "if empty alloc, just free.\n\n",
\ },
\ {
\    'src_file' : "/Users/williamknight/proj/git/vblend/lua/lauxlib.c",
\    'src_line' : "635",
\    'continue' : "step",
\    'narr' : "Allocates through call to Clib func.\n",
\ },
\ {
\    'src_file' : "/Users/williamknight/proj/git/vblend/lua/lauxlib.c",
\    'src_line' : "636",
\    'continue' : "step",
\    'narr' : "\n",
\ },
\ {
\    'src_file' : "/Users/williamknight/proj/git/vblend/lua/lstate.c",
\    'src_line' : "148",
\    'continue' : "step",
\    'narr' : "If no mem avail, return NULL.\n",
\ },
\ {
\    'src_file' : "/Users/williamknight/proj/git/vblend/lua/lstate.c",
\    'src_line' : "149",
\    'continue' : "",
\    'narr' : "\n",
\ },
\]

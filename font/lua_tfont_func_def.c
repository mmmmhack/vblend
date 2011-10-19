static int lw_init(lua_State* L) {
  int ret_val = 
  tfont_init(
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_cleanup(lua_State* L) {
  tfont_cleanup(
  );
  return 0;
}
static int lw_num_rows(lua_State* L) {
  int ret_val = 
  tfont_num_rows(
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_num_cols(lua_State* L) {
  int ret_val = 
  tfont_num_cols(
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_char_width(lua_State* L) {
  int ret_val = 
  tfont_char_width(
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_char_height(lua_State* L) {
  int ret_val = 
  tfont_char_height(
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_set_text_buf(lua_State* L) {
  int row = lua_tointeger(L, -3);
  int col = lua_tointeger(L, -2);
  const char* s = lua_tostring(L, -1);
  tfont_set_text_buf(
    row,
    col,
    s
  );
  return 0;
}
static int lw_draw_text_buf(lua_State* L) {
  tfont_draw_text_buf(
  );
  return 0;
}

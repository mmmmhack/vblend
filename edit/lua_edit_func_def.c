static int lw_set_cursor(lua_State* L) {
  int row = lua_tointeger(L, -2);
  int col = lua_tointeger(L, -1);
  edit_set_cursor(
    row,
    col
  );
  return 0;
}
static int lw_get_cursor(lua_State* L) {
  int row_ret = 0;
  int col_ret = 0;
  edit_get_cursor(
    &row_ret,
    &col_ret
  );
  lua_pushinteger(L, row_ret);
  lua_pushinteger(L, col_ret);
  return 2;
}
static int lw_draw_cursor(lua_State* L) {
  edit_draw_cursor(
  );
  return 0;
}

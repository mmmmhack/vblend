static int lw_double_time(lua_State* L) {
  double ret_val = 
  sys_double_time(
  );
  lua_pushnumber(L, ret_val);
  return 1;
}

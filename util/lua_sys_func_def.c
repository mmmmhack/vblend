static int lw_chdir(lua_State* L) {
  const char* path = lua_tostring(L, -1);
  int ret_val = 
  sys_chdir(
    path
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_double_time(lua_State* L) {
  double ret_val = 
  sys_double_time(
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_getcwd(lua_State* L) {
  const char* ret_val = 
  sys_getcwd(
  );
  lua_pushstring(L, ret_val);
  return 1;
}

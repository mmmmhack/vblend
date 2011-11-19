static int lw_perspective(lua_State* L) {
  GLdouble fovy = lua_tonumber(L, -4);
  GLdouble aspect = lua_tonumber(L, -3);
  GLdouble zNear = lua_tonumber(L, -2);
  GLdouble zFar = lua_tonumber(L, -1);
  gluPerspective(
    fovy,
    aspect,
    zNear,
    zFar
  );
  return 0;
}

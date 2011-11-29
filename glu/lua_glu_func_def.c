static int lw_lookAt(lua_State* L) {
  GLdouble eyeX = lua_tonumber(L, -9);
  GLdouble eyeY = lua_tonumber(L, -8);
  GLdouble eyeZ = lua_tonumber(L, -7);
  GLdouble centerX = lua_tonumber(L, -6);
  GLdouble centerY = lua_tonumber(L, -5);
  GLdouble centerZ = lua_tonumber(L, -4);
  GLdouble upX = lua_tonumber(L, -3);
  GLdouble upY = lua_tonumber(L, -2);
  GLdouble upZ = lua_tonumber(L, -1);
  gluLookAt(
    eyeX,
    eyeY,
    eyeZ,
    centerX,
    centerY,
    centerZ,
    upX,
    upY,
    upZ
  );
  return 0;
}
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

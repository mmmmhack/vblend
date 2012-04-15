static int lw_deleteQuadric(lua_State* L) {
  GLUquadric* quad = (GLUquadric*) lua_touserdata(L, -1);
  gluDeleteQuadric(
    quad
  );
  return 0;
}
static int lw_errorString(lua_State* L) {
  GLenum error = lua_tointeger(L, -1);
  const GLubyte * ret_val = 
  gluErrorString(
    error
  );
  lua_pushstring(L, ret_val);
  return 1;
}
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
static int lw_newQuadric(lua_State* L) {
  GLUquadric* ret_val = 
  gluNewQuadric(
  );
  GLUquadric** data_on_stack = lua_newuserdata(L, sizeof(GLUquadric**));
  *data_on_stack = ret_val;
  return 1;
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
static int lw_sphere(lua_State* L) {
  GLUquadric* quad = (GLUquadric*) lua_touserdata(L, -4);
  GLdouble radius = lua_tonumber(L, -3);
  GLint slices = lua_tointeger(L, -2);
  GLint stacks = lua_tointeger(L, -1);
  gluSphere(
    quad,
    radius,
    slices,
    stacks
  );
  return 0;
}

static int lw_clearColor(lua_State* L) {
  float red = lua_tonumber(L, -4);
  float green = lua_tonumber(L, -3);
  float blue = lua_tonumber(L, -2);
  float alpha = lua_tonumber(L, -1);
  glClearColor(
    red,
    green,
    blue,
    alpha);
  return 0;
}
static int lw_clear(lua_State* L) {
  int mask = lua_tointeger(L, -1);
  glClear(
    mask);
  return 0;
}
static int lw_blendFunc(lua_State* L) {
  int sfactor = lua_tointeger(L, -2);
  int dfactor = lua_tointeger(L, -1);
  glBlendFunc(
    sfactor,
    dfactor);
  return 0;
}
static int lw_matrixMode(lua_State* L) {
  int mode = lua_tointeger(L, -1);
  glMatrixMode(
    mode);
  return 0;
}
static int lw_ortho(lua_State* L) {
  double left = lua_tonumber(L, -6);
  double right = lua_tonumber(L, -5);
  double bottom = lua_tonumber(L, -4);
  double top = lua_tonumber(L, -3);
  double near_val = lua_tonumber(L, -2);
  double far_val = lua_tonumber(L, -1);
  glOrtho(
    left,
    right,
    bottom,
    top,
    near_val,
    far_val);
  return 0;
}
static int lw_loadIdentity(lua_State* L) {
  glLoadIdentity();
  return 0;
}
static int lw_Begin(lua_State* L) {
  int mode = lua_tointeger(L, -1);
  glBegin(
    mode);
  return 0;
}
static int lw_End(lua_State* L) {
  glEnd();
  return 0;
}
static int lw_vertex2f(lua_State* L) {
  float x = lua_tonumber(L, -2);
  float y = lua_tonumber(L, -1);
  glVertex2f(
    x,
    y);
  return 0;
}
static int lw_vertex3f(lua_State* L) {
  float x = lua_tonumber(L, -3);
  float y = lua_tonumber(L, -2);
  float z = lua_tonumber(L, -1);
  glVertex3f(
    x,
    y,
    z);
  return 0;
}
static int lw_color3f(lua_State* L) {
  float red = lua_tonumber(L, -3);
  float green = lua_tonumber(L, -2);
  float blue = lua_tonumber(L, -1);
  glColor3f(
    red,
    green,
    blue);
  return 0;
}
static int lw_color4f(lua_State* L) {
  float red = lua_tonumber(L, -4);
  float green = lua_tonumber(L, -3);
  float blue = lua_tonumber(L, -2);
  float alpha = lua_tonumber(L, -1);
  glColor4f(
    red,
    green,
    blue,
    alpha);
  return 0;
}

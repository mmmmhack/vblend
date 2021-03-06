static int lw_clearColor(lua_State* L) {
  GLclampf red = lua_tonumber(L, -4);
  GLclampf green = lua_tonumber(L, -3);
  GLclampf blue = lua_tonumber(L, -2);
  GLclampf alpha = lua_tonumber(L, -1);
  glClearColor(
    red,
    green,
    blue,
    alpha
  );
  return 0;
}
static int lw_clear(lua_State* L) {
  GLbitfield mask = lua_tointeger(L, -1);
  glClear(
    mask
  );
  return 0;
}
static int lw_blendFunc(lua_State* L) {
  GLenum sfactor = lua_tointeger(L, -2);
  GLenum dfactor = lua_tointeger(L, -1);
  glBlendFunc(
    sfactor,
    dfactor
  );
  return 0;
}
static int lw_enable(lua_State* L) {
  GLenum cap = lua_tointeger(L, -1);
  glEnable(
    cap
  );
  return 0;
}
static int lw_disable(lua_State* L) {
  GLenum cap = lua_tointeger(L, -1);
  glDisable(
    cap
  );
  return 0;
}
static int lw_getError(lua_State* L) {
  GLenum ret_val = 
  glGetError(
  );
  lua_pushinteger(L, ret_val);
  return 1;
}
static int lw_matrixMode(lua_State* L) {
  GLenum mode = lua_tointeger(L, -1);
  glMatrixMode(
    mode
  );
  return 0;
}
static int lw_ortho(lua_State* L) {
  GLdouble left = lua_tonumber(L, -6);
  GLdouble right = lua_tonumber(L, -5);
  GLdouble bottom = lua_tonumber(L, -4);
  GLdouble top = lua_tonumber(L, -3);
  GLdouble near_val = lua_tonumber(L, -2);
  GLdouble far_val = lua_tonumber(L, -1);
  glOrtho(
    left,
    right,
    bottom,
    top,
    near_val,
    far_val
  );
  return 0;
}
static int lw_frustum(lua_State* L) {
  GLdouble left = lua_tonumber(L, -6);
  GLdouble right = lua_tonumber(L, -5);
  GLdouble bottom = lua_tonumber(L, -4);
  GLdouble top = lua_tonumber(L, -3);
  GLdouble near_val = lua_tonumber(L, -2);
  GLdouble far_val = lua_tonumber(L, -1);
  glFrustum(
    left,
    right,
    bottom,
    top,
    near_val,
    far_val
  );
  return 0;
}
static int lw_pushMatrix(lua_State* L) {
  glPushMatrix(
  );
  return 0;
}
static int lw_popMatrix(lua_State* L) {
  glPopMatrix(
  );
  return 0;
}
static int lw_loadIdentity(lua_State* L) {
  glLoadIdentity(
  );
  return 0;
}
static int lw_rotatef(lua_State* L) {
  GLfloat angle = lua_tonumber(L, -4);
  GLfloat x = lua_tonumber(L, -3);
  GLfloat y = lua_tonumber(L, -2);
  GLfloat z = lua_tonumber(L, -1);
  glRotatef(
    angle,
    x,
    y,
    z
  );
  return 0;
}
static int lw_translatef(lua_State* L) {
  GLfloat x = lua_tonumber(L, -3);
  GLfloat y = lua_tonumber(L, -2);
  GLfloat z = lua_tonumber(L, -1);
  glTranslatef(
    x,
    y,
    z
  );
  return 0;
}
static int lw_Begin(lua_State* L) {
  GLenum mode = lua_tointeger(L, -1);
  glBegin(
    mode
  );
  return 0;
}
static int lw_End(lua_State* L) {
  glEnd(
  );
  return 0;
}
static int lw_vertex2f(lua_State* L) {
  GLfloat x = lua_tonumber(L, -2);
  GLfloat y = lua_tonumber(L, -1);
  glVertex2f(
    x,
    y
  );
  return 0;
}
static int lw_vertex3f(lua_State* L) {
  GLfloat x = lua_tonumber(L, -3);
  GLfloat y = lua_tonumber(L, -2);
  GLfloat z = lua_tonumber(L, -1);
  glVertex3f(
    x,
    y,
    z
  );
  return 0;
}
static int lw_normal3f(lua_State* L) {
  GLfloat nx = lua_tonumber(L, -3);
  GLfloat ny = lua_tonumber(L, -2);
  GLfloat nz = lua_tonumber(L, -1);
  glNormal3f(
    nx,
    ny,
    nz
  );
  return 0;
}
static int lw_color3f(lua_State* L) {
  GLfloat red = lua_tonumber(L, -3);
  GLfloat green = lua_tonumber(L, -2);
  GLfloat blue = lua_tonumber(L, -1);
  glColor3f(
    red,
    green,
    blue
  );
  return 0;
}
static int lw_color4f(lua_State* L) {
  GLfloat red = lua_tonumber(L, -4);
  GLfloat green = lua_tonumber(L, -3);
  GLfloat blue = lua_tonumber(L, -2);
  GLfloat alpha = lua_tonumber(L, -1);
  glColor4f(
    red,
    green,
    blue,
    alpha
  );
  return 0;
}
static int lw_shadeModel(lua_State* L) {
  GLenum mode = lua_tointeger(L, -1);
  glShadeModel(
    mode
  );
  return 0;
}

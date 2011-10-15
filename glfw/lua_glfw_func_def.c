static int lw_init(lua_State* L) {
  int ret_val = 
  glfwInit(
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_terminate(lua_State* L) {
  glfwTerminate(
  );
  return 0;
}
static int lw_openWindow(lua_State* L) {
  int width = lua_tointeger(L, -9);
  int height = lua_tointeger(L, -8);
  int redbits = lua_tointeger(L, -7);
  int greenbits = lua_tointeger(L, -6);
  int bluebits = lua_tointeger(L, -5);
  int alphabits = lua_tointeger(L, -4);
  int depthbits = lua_tointeger(L, -3);
  int stencilbits = lua_tointeger(L, -2);
  int mode = lua_tointeger(L, -1);
  int ret_val = 
  glfwOpenWindow(
    width,
    height,
    redbits,
    greenbits,
    bluebits,
    alphabits,
    depthbits,
    stencilbits,
    mode
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_openWindowHint(lua_State* L) {
  int target = lua_tointeger(L, -2);
  int hint = lua_tointeger(L, -1);
  glfwOpenWindowHint(
    target,
    hint
  );
  return 0;
}
static int lw_closeWindow(lua_State* L) {
  glfwCloseWindow(
  );
  return 0;
}
static int lw_setWindowTitle(lua_State* L) {
  const char * title = lua_tostring(L, -1);
  glfwSetWindowTitle(
    title
  );
  return 0;
}
static int lw_getWindowSize(lua_State* L) {
  int  width = 0;
  int  height = 0;
  glfwGetWindowSize(
    &width,
    &height
  );
  lua_pushinteger(L, width);
  lua_pushinteger(L, height);
  return 2;
}
static int lw_setWindowSize(lua_State* L) {
  int width = lua_tointeger(L, -2);
  int height = lua_tointeger(L, -1);
  glfwSetWindowSize(
    width,
    height
  );
  return 0;
}
static int lw_setWindowPos(lua_State* L) {
  int x = lua_tointeger(L, -2);
  int y = lua_tointeger(L, -1);
  glfwSetWindowPos(
    x,
    y
  );
  return 0;
}
static int lw_iconifyWindow(lua_State* L) {
  glfwIconifyWindow(
  );
  return 0;
}
static int lw_restoreWindow(lua_State* L) {
  glfwRestoreWindow(
  );
  return 0;
}
static int lw_swapBuffers(lua_State* L) {
  glfwSwapBuffers(
  );
  return 0;
}
static int lw_swapInterval(lua_State* L) {
  int interval = lua_tointeger(L, -1);
  glfwSwapInterval(
    interval
  );
  return 0;
}
static int lw_getWindowParam(lua_State* L) {
  int param = lua_tointeger(L, -1);
  int ret_val = 
  glfwGetWindowParam(
    param
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_pollEvents(lua_State* L) {
  glfwPollEvents(
  );
  return 0;
}
static int lw_waitEvents(lua_State* L) {
  glfwWaitEvents(
  );
  return 0;
}
static int lw_getKey(lua_State* L) {
  int key = lua_tointeger(L, -1);
  int ret_val = 
  glfwGetKey(
    key
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_getMouseButton(lua_State* L) {
  int button = lua_tointeger(L, -1);
  int ret_val = 
  glfwGetMouseButton(
    button
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_setMousePos(lua_State* L) {
  int xpos = lua_tointeger(L, -2);
  int ypos = lua_tointeger(L, -1);
  glfwSetMousePos(
    xpos,
    ypos
  );
  return 0;
}
static int lw_getMouseWheel(lua_State* L) {
  int ret_val = 
  glfwGetMouseWheel(
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_setMouseWheel(lua_State* L) {
  int pos = lua_tointeger(L, -1);
  glfwSetMouseWheel(
    pos
  );
  return 0;
}
static int lw_getJoystickParam(lua_State* L) {
  int joy = lua_tointeger(L, -2);
  int param = lua_tointeger(L, -1);
  int ret_val = 
  glfwGetJoystickParam(
    joy,
    param
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_getTime(lua_State* L) {
  double ret_val = 
  glfwGetTime(
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_setTime(lua_State* L) {
  double time = lua_tonumber(L, -1);
  glfwSetTime(
    time
  );
  return 0;
}
static int lw_sleep(lua_State* L) {
  double time = lua_tonumber(L, -1);
  glfwSleep(
    time
  );
  return 0;
}
static int lw_extensionSupported(lua_State* L) {
  const char * extension = lua_tostring(L, -1);
  int ret_val = 
  glfwExtensionSupported(
    extension
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_getNumberOfProcessors(lua_State* L) {
  int ret_val = 
  glfwGetNumberOfProcessors(
  );
  lua_pushnumber(L, ret_val);
  return 1;
}
static int lw_enable(lua_State* L) {
  int token = lua_tointeger(L, -1);
  glfwEnable(
    token
  );
  return 0;
}
static int lw_disable(lua_State* L) {
  int token = lua_tointeger(L, -1);
  glfwDisable(
    token
  );
  return 0;
}
static int lw_loadTexture2D(lua_State* L) {
  const char * name = lua_tostring(L, -2);
  int flags = lua_tointeger(L, -1);
  int ret_val = 
  glfwLoadTexture2D(
    name,
    flags
  );
  lua_pushnumber(L, ret_val);
  return 1;
}

static void define_constants(lua_State* L) {
	// push table
  lua_getglobal(L, "glfw");

  lua_pushnumber(L, 2);
  lua_setfield(L, -2, "GLFW_VERSION_MAJOR");

  lua_pushnumber(L, 7);
  lua_setfield(L, -2, "GLFW_VERSION_MINOR");

  lua_pushnumber(L, 0);
  lua_setfield(L, -2, "GLFW_VERSION_REVISION");

  lua_pushnumber(L, 0);
  lua_setfield(L, -2, "GLFW_RELEASE");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GLFW_PRESS");

  lua_pushnumber(L, -1);
  lua_setfield(L, -2, "GLFW_KEY_UNKNOWN");

  lua_pushnumber(L, 32);
  lua_setfield(L, -2, "GLFW_KEY_SPACE");

  lua_pushnumber(L, 256);
  lua_setfield(L, -2, "GLFW_KEY_SPECIAL");

  lua_pushnumber(L, 257);
  lua_setfield(L, -2, "GLFW_KEY_ESC");

  lua_pushnumber(L, 258);
  lua_setfield(L, -2, "GLFW_KEY_F1");

  lua_pushnumber(L, 259);
  lua_setfield(L, -2, "GLFW_KEY_F2");

  lua_pushnumber(L, 260);
  lua_setfield(L, -2, "GLFW_KEY_F3");

  lua_pushnumber(L, 261);
  lua_setfield(L, -2, "GLFW_KEY_F4");

  lua_pushnumber(L, 262);
  lua_setfield(L, -2, "GLFW_KEY_F5");

  lua_pushnumber(L, 263);
  lua_setfield(L, -2, "GLFW_KEY_F6");

  lua_pushnumber(L, 264);
  lua_setfield(L, -2, "GLFW_KEY_F7");

  lua_pushnumber(L, 265);
  lua_setfield(L, -2, "GLFW_KEY_F8");

  lua_pushnumber(L, 266);
  lua_setfield(L, -2, "GLFW_KEY_F9");

  lua_pushnumber(L, 267);
  lua_setfield(L, -2, "GLFW_KEY_F10");

  lua_pushnumber(L, 268);
  lua_setfield(L, -2, "GLFW_KEY_F11");

  lua_pushnumber(L, 269);
  lua_setfield(L, -2, "GLFW_KEY_F12");

  lua_pushnumber(L, 270);
  lua_setfield(L, -2, "GLFW_KEY_F13");

  lua_pushnumber(L, 271);
  lua_setfield(L, -2, "GLFW_KEY_F14");

  lua_pushnumber(L, 272);
  lua_setfield(L, -2, "GLFW_KEY_F15");

  lua_pushnumber(L, 273);
  lua_setfield(L, -2, "GLFW_KEY_F16");

  lua_pushnumber(L, 274);
  lua_setfield(L, -2, "GLFW_KEY_F17");

  lua_pushnumber(L, 275);
  lua_setfield(L, -2, "GLFW_KEY_F18");

  lua_pushnumber(L, 276);
  lua_setfield(L, -2, "GLFW_KEY_F19");

  lua_pushnumber(L, 277);
  lua_setfield(L, -2, "GLFW_KEY_F20");

  lua_pushnumber(L, 278);
  lua_setfield(L, -2, "GLFW_KEY_F21");

  lua_pushnumber(L, 279);
  lua_setfield(L, -2, "GLFW_KEY_F22");

  lua_pushnumber(L, 280);
  lua_setfield(L, -2, "GLFW_KEY_F23");

  lua_pushnumber(L, 281);
  lua_setfield(L, -2, "GLFW_KEY_F24");

  lua_pushnumber(L, 282);
  lua_setfield(L, -2, "GLFW_KEY_F25");

  lua_pushnumber(L, 283);
  lua_setfield(L, -2, "GLFW_KEY_UP");

  lua_pushnumber(L, 284);
  lua_setfield(L, -2, "GLFW_KEY_DOWN");

  lua_pushnumber(L, 285);
  lua_setfield(L, -2, "GLFW_KEY_LEFT");

  lua_pushnumber(L, 286);
  lua_setfield(L, -2, "GLFW_KEY_RIGHT");

  lua_pushnumber(L, 287);
  lua_setfield(L, -2, "GLFW_KEY_LSHIFT");

  lua_pushnumber(L, 288);
  lua_setfield(L, -2, "GLFW_KEY_RSHIFT");

  lua_pushnumber(L, 289);
  lua_setfield(L, -2, "GLFW_KEY_LCTRL");

  lua_pushnumber(L, 290);
  lua_setfield(L, -2, "GLFW_KEY_RCTRL");

  lua_pushnumber(L, 291);
  lua_setfield(L, -2, "GLFW_KEY_LALT");

  lua_pushnumber(L, 292);
  lua_setfield(L, -2, "GLFW_KEY_RALT");

  lua_pushnumber(L, 293);
  lua_setfield(L, -2, "GLFW_KEY_TAB");

  lua_pushnumber(L, 294);
  lua_setfield(L, -2, "GLFW_KEY_ENTER");

  lua_pushnumber(L, 295);
  lua_setfield(L, -2, "GLFW_KEY_BACKSPACE");

  lua_pushnumber(L, 296);
  lua_setfield(L, -2, "GLFW_KEY_INSERT");

  lua_pushnumber(L, 297);
  lua_setfield(L, -2, "GLFW_KEY_DEL");

  lua_pushnumber(L, 298);
  lua_setfield(L, -2, "GLFW_KEY_PAGEUP");

  lua_pushnumber(L, 299);
  lua_setfield(L, -2, "GLFW_KEY_PAGEDOWN");

  lua_pushnumber(L, 300);
  lua_setfield(L, -2, "GLFW_KEY_HOME");

  lua_pushnumber(L, 301);
  lua_setfield(L, -2, "GLFW_KEY_END");

  lua_pushnumber(L, 302);
  lua_setfield(L, -2, "GLFW_KEY_KP_0");

  lua_pushnumber(L, 303);
  lua_setfield(L, -2, "GLFW_KEY_KP_1");

  lua_pushnumber(L, 304);
  lua_setfield(L, -2, "GLFW_KEY_KP_2");

  lua_pushnumber(L, 305);
  lua_setfield(L, -2, "GLFW_KEY_KP_3");

  lua_pushnumber(L, 306);
  lua_setfield(L, -2, "GLFW_KEY_KP_4");

  lua_pushnumber(L, 307);
  lua_setfield(L, -2, "GLFW_KEY_KP_5");

  lua_pushnumber(L, 308);
  lua_setfield(L, -2, "GLFW_KEY_KP_6");

  lua_pushnumber(L, 309);
  lua_setfield(L, -2, "GLFW_KEY_KP_7");

  lua_pushnumber(L, 310);
  lua_setfield(L, -2, "GLFW_KEY_KP_8");

  lua_pushnumber(L, 311);
  lua_setfield(L, -2, "GLFW_KEY_KP_9");

  lua_pushnumber(L, 312);
  lua_setfield(L, -2, "GLFW_KEY_KP_DIVIDE");

  lua_pushnumber(L, 313);
  lua_setfield(L, -2, "GLFW_KEY_KP_MULTIPLY");

  lua_pushnumber(L, 314);
  lua_setfield(L, -2, "GLFW_KEY_KP_SUBTRACT");

  lua_pushnumber(L, 315);
  lua_setfield(L, -2, "GLFW_KEY_KP_ADD");

  lua_pushnumber(L, 316);
  lua_setfield(L, -2, "GLFW_KEY_KP_DECIMAL");

  lua_pushnumber(L, 317);
  lua_setfield(L, -2, "GLFW_KEY_KP_EQUAL");

  lua_pushnumber(L, 318);
  lua_setfield(L, -2, "GLFW_KEY_KP_ENTER");

  lua_pushnumber(L, 319);
  lua_setfield(L, -2, "GLFW_KEY_KP_NUM_LOCK");

  lua_pushnumber(L, 320);
  lua_setfield(L, -2, "GLFW_KEY_CAPS_LOCK");

  lua_pushnumber(L, 321);
  lua_setfield(L, -2, "GLFW_KEY_SCROLL_LOCK");

  lua_pushnumber(L, 322);
  lua_setfield(L, -2, "GLFW_KEY_PAUSE");

  lua_pushnumber(L, 323);
  lua_setfield(L, -2, "GLFW_KEY_LSUPER");

  lua_pushnumber(L, 324);
  lua_setfield(L, -2, "GLFW_KEY_RSUPER");

  lua_pushnumber(L, 325);
  lua_setfield(L, -2, "GLFW_KEY_MENU");

  lua_pushnumber(L, 325);
  lua_setfield(L, -2, "GLFW_KEY_LAST");

  lua_pushnumber(L, 0);
  lua_setfield(L, -2, "GLFW_MOUSE_BUTTON_1");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GLFW_MOUSE_BUTTON_2");

  lua_pushnumber(L, 2);
  lua_setfield(L, -2, "GLFW_MOUSE_BUTTON_3");

  lua_pushnumber(L, 3);
  lua_setfield(L, -2, "GLFW_MOUSE_BUTTON_4");

  lua_pushnumber(L, 4);
  lua_setfield(L, -2, "GLFW_MOUSE_BUTTON_5");

  lua_pushnumber(L, 5);
  lua_setfield(L, -2, "GLFW_MOUSE_BUTTON_6");

  lua_pushnumber(L, 6);
  lua_setfield(L, -2, "GLFW_MOUSE_BUTTON_7");

  lua_pushnumber(L, 7);
  lua_setfield(L, -2, "GLFW_MOUSE_BUTTON_8");

  lua_pushnumber(L, 7);
  lua_setfield(L, -2, "GLFW_MOUSE_BUTTON_LAST");

  lua_pushnumber(L, 0);
  lua_setfield(L, -2, "GLFW_MOUSE_BUTTON_LEFT");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GLFW_MOUSE_BUTTON_RIGHT");

  lua_pushnumber(L, 2);
  lua_setfield(L, -2, "GLFW_MOUSE_BUTTON_MIDDLE");

  lua_pushnumber(L, 0);
  lua_setfield(L, -2, "GLFW_JOYSTICK_1");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GLFW_JOYSTICK_2");

  lua_pushnumber(L, 2);
  lua_setfield(L, -2, "GLFW_JOYSTICK_3");

  lua_pushnumber(L, 3);
  lua_setfield(L, -2, "GLFW_JOYSTICK_4");

  lua_pushnumber(L, 4);
  lua_setfield(L, -2, "GLFW_JOYSTICK_5");

  lua_pushnumber(L, 5);
  lua_setfield(L, -2, "GLFW_JOYSTICK_6");

  lua_pushnumber(L, 6);
  lua_setfield(L, -2, "GLFW_JOYSTICK_7");

  lua_pushnumber(L, 7);
  lua_setfield(L, -2, "GLFW_JOYSTICK_8");

  lua_pushnumber(L, 8);
  lua_setfield(L, -2, "GLFW_JOYSTICK_9");

  lua_pushnumber(L, 9);
  lua_setfield(L, -2, "GLFW_JOYSTICK_10");

  lua_pushnumber(L, 10);
  lua_setfield(L, -2, "GLFW_JOYSTICK_11");

  lua_pushnumber(L, 11);
  lua_setfield(L, -2, "GLFW_JOYSTICK_12");

  lua_pushnumber(L, 12);
  lua_setfield(L, -2, "GLFW_JOYSTICK_13");

  lua_pushnumber(L, 13);
  lua_setfield(L, -2, "GLFW_JOYSTICK_14");

  lua_pushnumber(L, 14);
  lua_setfield(L, -2, "GLFW_JOYSTICK_15");

  lua_pushnumber(L, 15);
  lua_setfield(L, -2, "GLFW_JOYSTICK_16");

  lua_pushnumber(L, 15);
  lua_setfield(L, -2, "GLFW_JOYSTICK_LAST");

  lua_pushnumber(L, 65537);
  lua_setfield(L, -2, "GLFW_WINDOW");

  lua_pushnumber(L, 65538);
  lua_setfield(L, -2, "GLFW_FULLSCREEN");

  lua_pushnumber(L, 131073);
  lua_setfield(L, -2, "GLFW_OPENED");

  lua_pushnumber(L, 131074);
  lua_setfield(L, -2, "GLFW_ACTIVE");

  lua_pushnumber(L, 131075);
  lua_setfield(L, -2, "GLFW_ICONIFIED");

  lua_pushnumber(L, 131076);
  lua_setfield(L, -2, "GLFW_ACCELERATED");

  lua_pushnumber(L, 131077);
  lua_setfield(L, -2, "GLFW_RED_BITS");

  lua_pushnumber(L, 131078);
  lua_setfield(L, -2, "GLFW_GREEN_BITS");

  lua_pushnumber(L, 131079);
  lua_setfield(L, -2, "GLFW_BLUE_BITS");

  lua_pushnumber(L, 131080);
  lua_setfield(L, -2, "GLFW_ALPHA_BITS");

  lua_pushnumber(L, 131081);
  lua_setfield(L, -2, "GLFW_DEPTH_BITS");

  lua_pushnumber(L, 131082);
  lua_setfield(L, -2, "GLFW_STENCIL_BITS");

  lua_pushnumber(L, 131083);
  lua_setfield(L, -2, "GLFW_REFRESH_RATE");

  lua_pushnumber(L, 131084);
  lua_setfield(L, -2, "GLFW_ACCUM_RED_BITS");

  lua_pushnumber(L, 131085);
  lua_setfield(L, -2, "GLFW_ACCUM_GREEN_BITS");

  lua_pushnumber(L, 131086);
  lua_setfield(L, -2, "GLFW_ACCUM_BLUE_BITS");

  lua_pushnumber(L, 131087);
  lua_setfield(L, -2, "GLFW_ACCUM_ALPHA_BITS");

  lua_pushnumber(L, 131088);
  lua_setfield(L, -2, "GLFW_AUX_BUFFERS");

  lua_pushnumber(L, 131089);
  lua_setfield(L, -2, "GLFW_STEREO");

  lua_pushnumber(L, 131090);
  lua_setfield(L, -2, "GLFW_WINDOW_NO_RESIZE");

  lua_pushnumber(L, 131091);
  lua_setfield(L, -2, "GLFW_FSAA_SAMPLES");

  lua_pushnumber(L, 131092);
  lua_setfield(L, -2, "GLFW_OPENGL_VERSION_MAJOR");

  lua_pushnumber(L, 131093);
  lua_setfield(L, -2, "GLFW_OPENGL_VERSION_MINOR");

  lua_pushnumber(L, 131094);
  lua_setfield(L, -2, "GLFW_OPENGL_FORWARD_COMPAT");

  lua_pushnumber(L, 131095);
  lua_setfield(L, -2, "GLFW_OPENGL_DEBUG_CONTEXT");

  lua_pushnumber(L, 131096);
  lua_setfield(L, -2, "GLFW_OPENGL_PROFILE");

  lua_pushnumber(L, 327681);
  lua_setfield(L, -2, "GLFW_OPENGL_CORE_PROFILE");

  lua_pushnumber(L, 327682);
  lua_setfield(L, -2, "GLFW_OPENGL_COMPAT_PROFILE");

  lua_pushnumber(L, 196609);
  lua_setfield(L, -2, "GLFW_MOUSE_CURSOR");

  lua_pushnumber(L, 196610);
  lua_setfield(L, -2, "GLFW_STICKY_KEYS");

  lua_pushnumber(L, 196611);
  lua_setfield(L, -2, "GLFW_STICKY_MOUSE_BUTTONS");

  lua_pushnumber(L, 196612);
  lua_setfield(L, -2, "GLFW_SYSTEM_KEYS");

  lua_pushnumber(L, 196613);
  lua_setfield(L, -2, "GLFW_KEY_REPEAT");

  lua_pushnumber(L, 196614);
  lua_setfield(L, -2, "GLFW_AUTO_POLL_EVENTS");

  lua_pushnumber(L, 262145);
  lua_setfield(L, -2, "GLFW_WAIT");

  lua_pushnumber(L, 262146);
  lua_setfield(L, -2, "GLFW_NOWAIT");

  lua_pushnumber(L, 327681);
  lua_setfield(L, -2, "GLFW_PRESENT");

  lua_pushnumber(L, 327682);
  lua_setfield(L, -2, "GLFW_AXES");

  lua_pushnumber(L, 327683);
  lua_setfield(L, -2, "GLFW_BUTTONS");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GLFW_NO_RESCALE_BIT");

  lua_pushnumber(L, 2);
  lua_setfield(L, -2, "GLFW_ORIGIN_UL_BIT");

  lua_pushnumber(L, 4);
  lua_setfield(L, -2, "GLFW_BUILD_MIPMAPS_BIT");

  lua_pushnumber(L, 8);
  lua_setfield(L, -2, "GLFW_ALPHA_MAP_BIT");

  lua_pushnumber(L, 100000);
  lua_setfield(L, -2, "GLFW_INFINITY");

	// pop table
	lua_pop(L, 1);

}// define_constants()


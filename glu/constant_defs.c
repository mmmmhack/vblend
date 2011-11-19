static void define_constants(lua_State* L) {
	// push table
  lua_getglobal(L, "glu");

	// pop table
	lua_pop(L, 1);

}// define_constants()


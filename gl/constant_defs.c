static void define_constants(lua_State* L) {
	// push table
  lua_getglobal(L, "gl");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_VERSION_1_1");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_VERSION_1_2");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_VERSION_1_3");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_ARB_imaging");

  lua_pushnumber(L, 0);
  lua_setfield(L, -2, "GL_FALSE");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_TRUE");

  lua_pushnumber(L, 5120);
  lua_setfield(L, -2, "GL_BYTE");

  lua_pushnumber(L, 5121);
  lua_setfield(L, -2, "GL_UNSIGNED_BYTE");

  lua_pushnumber(L, 5122);
  lua_setfield(L, -2, "GL_SHORT");

  lua_pushnumber(L, 5123);
  lua_setfield(L, -2, "GL_UNSIGNED_SHORT");

  lua_pushnumber(L, 5124);
  lua_setfield(L, -2, "GL_INT");

  lua_pushnumber(L, 5125);
  lua_setfield(L, -2, "GL_UNSIGNED_INT");

  lua_pushnumber(L, 5126);
  lua_setfield(L, -2, "GL_FLOAT");

  lua_pushnumber(L, 5127);
  lua_setfield(L, -2, "GL_2_BYTES");

  lua_pushnumber(L, 5128);
  lua_setfield(L, -2, "GL_3_BYTES");

  lua_pushnumber(L, 5129);
  lua_setfield(L, -2, "GL_4_BYTES");

  lua_pushnumber(L, 5130);
  lua_setfield(L, -2, "GL_DOUBLE");

  lua_pushnumber(L, 0);
  lua_setfield(L, -2, "GL_POINTS");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_LINES");

  lua_pushnumber(L, 2);
  lua_setfield(L, -2, "GL_LINE_LOOP");

  lua_pushnumber(L, 3);
  lua_setfield(L, -2, "GL_LINE_STRIP");

  lua_pushnumber(L, 4);
  lua_setfield(L, -2, "GL_TRIANGLES");

  lua_pushnumber(L, 5);
  lua_setfield(L, -2, "GL_TRIANGLE_STRIP");

  lua_pushnumber(L, 6);
  lua_setfield(L, -2, "GL_TRIANGLE_FAN");

  lua_pushnumber(L, 7);
  lua_setfield(L, -2, "GL_QUADS");

  lua_pushnumber(L, 8);
  lua_setfield(L, -2, "GL_QUAD_STRIP");

  lua_pushnumber(L, 9);
  lua_setfield(L, -2, "GL_POLYGON");

  lua_pushnumber(L, 32884);
  lua_setfield(L, -2, "GL_VERTEX_ARRAY");

  lua_pushnumber(L, 32885);
  lua_setfield(L, -2, "GL_NORMAL_ARRAY");

  lua_pushnumber(L, 32886);
  lua_setfield(L, -2, "GL_COLOR_ARRAY");

  lua_pushnumber(L, 32887);
  lua_setfield(L, -2, "GL_INDEX_ARRAY");

  lua_pushnumber(L, 32888);
  lua_setfield(L, -2, "GL_TEXTURE_COORD_ARRAY");

  lua_pushnumber(L, 32889);
  lua_setfield(L, -2, "GL_EDGE_FLAG_ARRAY");

  lua_pushnumber(L, 32890);
  lua_setfield(L, -2, "GL_VERTEX_ARRAY_SIZE");

  lua_pushnumber(L, 32891);
  lua_setfield(L, -2, "GL_VERTEX_ARRAY_TYPE");

  lua_pushnumber(L, 32892);
  lua_setfield(L, -2, "GL_VERTEX_ARRAY_STRIDE");

  lua_pushnumber(L, 32894);
  lua_setfield(L, -2, "GL_NORMAL_ARRAY_TYPE");

  lua_pushnumber(L, 32895);
  lua_setfield(L, -2, "GL_NORMAL_ARRAY_STRIDE");

  lua_pushnumber(L, 32897);
  lua_setfield(L, -2, "GL_COLOR_ARRAY_SIZE");

  lua_pushnumber(L, 32898);
  lua_setfield(L, -2, "GL_COLOR_ARRAY_TYPE");

  lua_pushnumber(L, 32899);
  lua_setfield(L, -2, "GL_COLOR_ARRAY_STRIDE");

  lua_pushnumber(L, 32901);
  lua_setfield(L, -2, "GL_INDEX_ARRAY_TYPE");

  lua_pushnumber(L, 32902);
  lua_setfield(L, -2, "GL_INDEX_ARRAY_STRIDE");

  lua_pushnumber(L, 32904);
  lua_setfield(L, -2, "GL_TEXTURE_COORD_ARRAY_SIZE");

  lua_pushnumber(L, 32905);
  lua_setfield(L, -2, "GL_TEXTURE_COORD_ARRAY_TYPE");

  lua_pushnumber(L, 32906);
  lua_setfield(L, -2, "GL_TEXTURE_COORD_ARRAY_STRIDE");

  lua_pushnumber(L, 32908);
  lua_setfield(L, -2, "GL_EDGE_FLAG_ARRAY_STRIDE");

  lua_pushnumber(L, 32910);
  lua_setfield(L, -2, "GL_VERTEX_ARRAY_POINTER");

  lua_pushnumber(L, 32911);
  lua_setfield(L, -2, "GL_NORMAL_ARRAY_POINTER");

  lua_pushnumber(L, 32912);
  lua_setfield(L, -2, "GL_COLOR_ARRAY_POINTER");

  lua_pushnumber(L, 32913);
  lua_setfield(L, -2, "GL_INDEX_ARRAY_POINTER");

  lua_pushnumber(L, 32914);
  lua_setfield(L, -2, "GL_TEXTURE_COORD_ARRAY_POINTER");

  lua_pushnumber(L, 32915);
  lua_setfield(L, -2, "GL_EDGE_FLAG_ARRAY_POINTER");

  lua_pushnumber(L, 10784);
  lua_setfield(L, -2, "GL_V2F");

  lua_pushnumber(L, 10785);
  lua_setfield(L, -2, "GL_V3F");

  lua_pushnumber(L, 10786);
  lua_setfield(L, -2, "GL_C4UB_V2F");

  lua_pushnumber(L, 10787);
  lua_setfield(L, -2, "GL_C4UB_V3F");

  lua_pushnumber(L, 10788);
  lua_setfield(L, -2, "GL_C3F_V3F");

  lua_pushnumber(L, 10789);
  lua_setfield(L, -2, "GL_N3F_V3F");

  lua_pushnumber(L, 10790);
  lua_setfield(L, -2, "GL_C4F_N3F_V3F");

  lua_pushnumber(L, 10791);
  lua_setfield(L, -2, "GL_T2F_V3F");

  lua_pushnumber(L, 10792);
  lua_setfield(L, -2, "GL_T4F_V4F");

  lua_pushnumber(L, 10793);
  lua_setfield(L, -2, "GL_T2F_C4UB_V3F");

  lua_pushnumber(L, 10794);
  lua_setfield(L, -2, "GL_T2F_C3F_V3F");

  lua_pushnumber(L, 10795);
  lua_setfield(L, -2, "GL_T2F_N3F_V3F");

  lua_pushnumber(L, 10796);
  lua_setfield(L, -2, "GL_T2F_C4F_N3F_V3F");

  lua_pushnumber(L, 10797);
  lua_setfield(L, -2, "GL_T4F_C4F_N3F_V4F");

  lua_pushnumber(L, 2976);
  lua_setfield(L, -2, "GL_MATRIX_MODE");

  lua_pushnumber(L, 5888);
  lua_setfield(L, -2, "GL_MODELVIEW");

  lua_pushnumber(L, 5889);
  lua_setfield(L, -2, "GL_PROJECTION");

  lua_pushnumber(L, 5890);
  lua_setfield(L, -2, "GL_TEXTURE");

  lua_pushnumber(L, 2832);
  lua_setfield(L, -2, "GL_POINT_SMOOTH");

  lua_pushnumber(L, 2833);
  lua_setfield(L, -2, "GL_POINT_SIZE");

  lua_pushnumber(L, 2835);
  lua_setfield(L, -2, "GL_POINT_SIZE_GRANULARITY");

  lua_pushnumber(L, 2834);
  lua_setfield(L, -2, "GL_POINT_SIZE_RANGE");

  lua_pushnumber(L, 2848);
  lua_setfield(L, -2, "GL_LINE_SMOOTH");

  lua_pushnumber(L, 2852);
  lua_setfield(L, -2, "GL_LINE_STIPPLE");

  lua_pushnumber(L, 2853);
  lua_setfield(L, -2, "GL_LINE_STIPPLE_PATTERN");

  lua_pushnumber(L, 2854);
  lua_setfield(L, -2, "GL_LINE_STIPPLE_REPEAT");

  lua_pushnumber(L, 2849);
  lua_setfield(L, -2, "GL_LINE_WIDTH");

  lua_pushnumber(L, 2851);
  lua_setfield(L, -2, "GL_LINE_WIDTH_GRANULARITY");

  lua_pushnumber(L, 2850);
  lua_setfield(L, -2, "GL_LINE_WIDTH_RANGE");

  lua_pushnumber(L, 6912);
  lua_setfield(L, -2, "GL_POINT");

  lua_pushnumber(L, 6913);
  lua_setfield(L, -2, "GL_LINE");

  lua_pushnumber(L, 6914);
  lua_setfield(L, -2, "GL_FILL");

  lua_pushnumber(L, 2304);
  lua_setfield(L, -2, "GL_CW");

  lua_pushnumber(L, 2305);
  lua_setfield(L, -2, "GL_CCW");

  lua_pushnumber(L, 1028);
  lua_setfield(L, -2, "GL_FRONT");

  lua_pushnumber(L, 1029);
  lua_setfield(L, -2, "GL_BACK");

  lua_pushnumber(L, 2880);
  lua_setfield(L, -2, "GL_POLYGON_MODE");

  lua_pushnumber(L, 2881);
  lua_setfield(L, -2, "GL_POLYGON_SMOOTH");

  lua_pushnumber(L, 2882);
  lua_setfield(L, -2, "GL_POLYGON_STIPPLE");

  lua_pushnumber(L, 2883);
  lua_setfield(L, -2, "GL_EDGE_FLAG");

  lua_pushnumber(L, 2884);
  lua_setfield(L, -2, "GL_CULL_FACE");

  lua_pushnumber(L, 2885);
  lua_setfield(L, -2, "GL_CULL_FACE_MODE");

  lua_pushnumber(L, 2886);
  lua_setfield(L, -2, "GL_FRONT_FACE");

  lua_pushnumber(L, 32824);
  lua_setfield(L, -2, "GL_POLYGON_OFFSET_FACTOR");

  lua_pushnumber(L, 10752);
  lua_setfield(L, -2, "GL_POLYGON_OFFSET_UNITS");

  lua_pushnumber(L, 10753);
  lua_setfield(L, -2, "GL_POLYGON_OFFSET_POINT");

  lua_pushnumber(L, 10754);
  lua_setfield(L, -2, "GL_POLYGON_OFFSET_LINE");

  lua_pushnumber(L, 32823);
  lua_setfield(L, -2, "GL_POLYGON_OFFSET_FILL");

  lua_pushnumber(L, 4864);
  lua_setfield(L, -2, "GL_COMPILE");

  lua_pushnumber(L, 4865);
  lua_setfield(L, -2, "GL_COMPILE_AND_EXECUTE");

  lua_pushnumber(L, 2866);
  lua_setfield(L, -2, "GL_LIST_BASE");

  lua_pushnumber(L, 2867);
  lua_setfield(L, -2, "GL_LIST_INDEX");

  lua_pushnumber(L, 2864);
  lua_setfield(L, -2, "GL_LIST_MODE");

  lua_pushnumber(L, 512);
  lua_setfield(L, -2, "GL_NEVER");

  lua_pushnumber(L, 513);
  lua_setfield(L, -2, "GL_LESS");

  lua_pushnumber(L, 514);
  lua_setfield(L, -2, "GL_EQUAL");

  lua_pushnumber(L, 515);
  lua_setfield(L, -2, "GL_LEQUAL");

  lua_pushnumber(L, 516);
  lua_setfield(L, -2, "GL_GREATER");

  lua_pushnumber(L, 517);
  lua_setfield(L, -2, "GL_NOTEQUAL");

  lua_pushnumber(L, 518);
  lua_setfield(L, -2, "GL_GEQUAL");

  lua_pushnumber(L, 519);
  lua_setfield(L, -2, "GL_ALWAYS");

  lua_pushnumber(L, 2929);
  lua_setfield(L, -2, "GL_DEPTH_TEST");

  lua_pushnumber(L, 3414);
  lua_setfield(L, -2, "GL_DEPTH_BITS");

  lua_pushnumber(L, 2931);
  lua_setfield(L, -2, "GL_DEPTH_CLEAR_VALUE");

  lua_pushnumber(L, 2932);
  lua_setfield(L, -2, "GL_DEPTH_FUNC");

  lua_pushnumber(L, 2928);
  lua_setfield(L, -2, "GL_DEPTH_RANGE");

  lua_pushnumber(L, 2930);
  lua_setfield(L, -2, "GL_DEPTH_WRITEMASK");

  lua_pushnumber(L, 6402);
  lua_setfield(L, -2, "GL_DEPTH_COMPONENT");

  lua_pushnumber(L, 2896);
  lua_setfield(L, -2, "GL_LIGHTING");

  lua_pushnumber(L, 16384);
  lua_setfield(L, -2, "GL_LIGHT0");

  lua_pushnumber(L, 16385);
  lua_setfield(L, -2, "GL_LIGHT1");

  lua_pushnumber(L, 16386);
  lua_setfield(L, -2, "GL_LIGHT2");

  lua_pushnumber(L, 16387);
  lua_setfield(L, -2, "GL_LIGHT3");

  lua_pushnumber(L, 16388);
  lua_setfield(L, -2, "GL_LIGHT4");

  lua_pushnumber(L, 16389);
  lua_setfield(L, -2, "GL_LIGHT5");

  lua_pushnumber(L, 16390);
  lua_setfield(L, -2, "GL_LIGHT6");

  lua_pushnumber(L, 16391);
  lua_setfield(L, -2, "GL_LIGHT7");

  lua_pushnumber(L, 4613);
  lua_setfield(L, -2, "GL_SPOT_EXPONENT");

  lua_pushnumber(L, 4614);
  lua_setfield(L, -2, "GL_SPOT_CUTOFF");

  lua_pushnumber(L, 4615);
  lua_setfield(L, -2, "GL_CONSTANT_ATTENUATION");

  lua_pushnumber(L, 4616);
  lua_setfield(L, -2, "GL_LINEAR_ATTENUATION");

  lua_pushnumber(L, 4617);
  lua_setfield(L, -2, "GL_QUADRATIC_ATTENUATION");

  lua_pushnumber(L, 4608);
  lua_setfield(L, -2, "GL_AMBIENT");

  lua_pushnumber(L, 4609);
  lua_setfield(L, -2, "GL_DIFFUSE");

  lua_pushnumber(L, 4610);
  lua_setfield(L, -2, "GL_SPECULAR");

  lua_pushnumber(L, 5633);
  lua_setfield(L, -2, "GL_SHININESS");

  lua_pushnumber(L, 5632);
  lua_setfield(L, -2, "GL_EMISSION");

  lua_pushnumber(L, 4611);
  lua_setfield(L, -2, "GL_POSITION");

  lua_pushnumber(L, 4612);
  lua_setfield(L, -2, "GL_SPOT_DIRECTION");

  lua_pushnumber(L, 5634);
  lua_setfield(L, -2, "GL_AMBIENT_AND_DIFFUSE");

  lua_pushnumber(L, 5635);
  lua_setfield(L, -2, "GL_COLOR_INDEXES");

  lua_pushnumber(L, 2898);
  lua_setfield(L, -2, "GL_LIGHT_MODEL_TWO_SIDE");

  lua_pushnumber(L, 2897);
  lua_setfield(L, -2, "GL_LIGHT_MODEL_LOCAL_VIEWER");

  lua_pushnumber(L, 2899);
  lua_setfield(L, -2, "GL_LIGHT_MODEL_AMBIENT");

  lua_pushnumber(L, 1032);
  lua_setfield(L, -2, "GL_FRONT_AND_BACK");

  lua_pushnumber(L, 2900);
  lua_setfield(L, -2, "GL_SHADE_MODEL");

  lua_pushnumber(L, 7424);
  lua_setfield(L, -2, "GL_FLAT");

  lua_pushnumber(L, 7425);
  lua_setfield(L, -2, "GL_SMOOTH");

  lua_pushnumber(L, 2903);
  lua_setfield(L, -2, "GL_COLOR_MATERIAL");

  lua_pushnumber(L, 2901);
  lua_setfield(L, -2, "GL_COLOR_MATERIAL_FACE");

  lua_pushnumber(L, 2902);
  lua_setfield(L, -2, "GL_COLOR_MATERIAL_PARAMETER");

  lua_pushnumber(L, 2977);
  lua_setfield(L, -2, "GL_NORMALIZE");

  lua_pushnumber(L, 12288);
  lua_setfield(L, -2, "GL_CLIP_PLANE0");

  lua_pushnumber(L, 12289);
  lua_setfield(L, -2, "GL_CLIP_PLANE1");

  lua_pushnumber(L, 12290);
  lua_setfield(L, -2, "GL_CLIP_PLANE2");

  lua_pushnumber(L, 12291);
  lua_setfield(L, -2, "GL_CLIP_PLANE3");

  lua_pushnumber(L, 12292);
  lua_setfield(L, -2, "GL_CLIP_PLANE4");

  lua_pushnumber(L, 12293);
  lua_setfield(L, -2, "GL_CLIP_PLANE5");

  lua_pushnumber(L, 3416);
  lua_setfield(L, -2, "GL_ACCUM_RED_BITS");

  lua_pushnumber(L, 3417);
  lua_setfield(L, -2, "GL_ACCUM_GREEN_BITS");

  lua_pushnumber(L, 3418);
  lua_setfield(L, -2, "GL_ACCUM_BLUE_BITS");

  lua_pushnumber(L, 3419);
  lua_setfield(L, -2, "GL_ACCUM_ALPHA_BITS");

  lua_pushnumber(L, 2944);
  lua_setfield(L, -2, "GL_ACCUM_CLEAR_VALUE");

  lua_pushnumber(L, 256);
  lua_setfield(L, -2, "GL_ACCUM");

  lua_pushnumber(L, 260);
  lua_setfield(L, -2, "GL_ADD");

  lua_pushnumber(L, 257);
  lua_setfield(L, -2, "GL_LOAD");

  lua_pushnumber(L, 259);
  lua_setfield(L, -2, "GL_MULT");

  lua_pushnumber(L, 258);
  lua_setfield(L, -2, "GL_RETURN");

  lua_pushnumber(L, 3008);
  lua_setfield(L, -2, "GL_ALPHA_TEST");

  lua_pushnumber(L, 3010);
  lua_setfield(L, -2, "GL_ALPHA_TEST_REF");

  lua_pushnumber(L, 3009);
  lua_setfield(L, -2, "GL_ALPHA_TEST_FUNC");

  lua_pushnumber(L, 3042);
  lua_setfield(L, -2, "GL_BLEND");

  lua_pushnumber(L, 3041);
  lua_setfield(L, -2, "GL_BLEND_SRC");

  lua_pushnumber(L, 3040);
  lua_setfield(L, -2, "GL_BLEND_DST");

  lua_pushnumber(L, 0);
  lua_setfield(L, -2, "GL_ZERO");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_ONE");

  lua_pushnumber(L, 768);
  lua_setfield(L, -2, "GL_SRC_COLOR");

  lua_pushnumber(L, 769);
  lua_setfield(L, -2, "GL_ONE_MINUS_SRC_COLOR");

  lua_pushnumber(L, 770);
  lua_setfield(L, -2, "GL_SRC_ALPHA");

  lua_pushnumber(L, 771);
  lua_setfield(L, -2, "GL_ONE_MINUS_SRC_ALPHA");

  lua_pushnumber(L, 772);
  lua_setfield(L, -2, "GL_DST_ALPHA");

  lua_pushnumber(L, 773);
  lua_setfield(L, -2, "GL_ONE_MINUS_DST_ALPHA");

  lua_pushnumber(L, 774);
  lua_setfield(L, -2, "GL_DST_COLOR");

  lua_pushnumber(L, 775);
  lua_setfield(L, -2, "GL_ONE_MINUS_DST_COLOR");

  lua_pushnumber(L, 776);
  lua_setfield(L, -2, "GL_SRC_ALPHA_SATURATE");

  lua_pushnumber(L, 7169);
  lua_setfield(L, -2, "GL_FEEDBACK");

  lua_pushnumber(L, 7168);
  lua_setfield(L, -2, "GL_RENDER");

  lua_pushnumber(L, 7170);
  lua_setfield(L, -2, "GL_SELECT");

  lua_pushnumber(L, 1536);
  lua_setfield(L, -2, "GL_2D");

  lua_pushnumber(L, 1537);
  lua_setfield(L, -2, "GL_3D");

  lua_pushnumber(L, 1538);
  lua_setfield(L, -2, "GL_3D_COLOR");

  lua_pushnumber(L, 1539);
  lua_setfield(L, -2, "GL_3D_COLOR_TEXTURE");

  lua_pushnumber(L, 1540);
  lua_setfield(L, -2, "GL_4D_COLOR_TEXTURE");

  lua_pushnumber(L, 1793);
  lua_setfield(L, -2, "GL_POINT_TOKEN");

  lua_pushnumber(L, 1794);
  lua_setfield(L, -2, "GL_LINE_TOKEN");

  lua_pushnumber(L, 1799);
  lua_setfield(L, -2, "GL_LINE_RESET_TOKEN");

  lua_pushnumber(L, 1795);
  lua_setfield(L, -2, "GL_POLYGON_TOKEN");

  lua_pushnumber(L, 1796);
  lua_setfield(L, -2, "GL_BITMAP_TOKEN");

  lua_pushnumber(L, 1797);
  lua_setfield(L, -2, "GL_DRAW_PIXEL_TOKEN");

  lua_pushnumber(L, 1798);
  lua_setfield(L, -2, "GL_COPY_PIXEL_TOKEN");

  lua_pushnumber(L, 1792);
  lua_setfield(L, -2, "GL_PASS_THROUGH_TOKEN");

  lua_pushnumber(L, 3568);
  lua_setfield(L, -2, "GL_FEEDBACK_BUFFER_POINTER");

  lua_pushnumber(L, 3569);
  lua_setfield(L, -2, "GL_FEEDBACK_BUFFER_SIZE");

  lua_pushnumber(L, 3570);
  lua_setfield(L, -2, "GL_FEEDBACK_BUFFER_TYPE");

  lua_pushnumber(L, 3571);
  lua_setfield(L, -2, "GL_SELECTION_BUFFER_POINTER");

  lua_pushnumber(L, 3572);
  lua_setfield(L, -2, "GL_SELECTION_BUFFER_SIZE");

  lua_pushnumber(L, 2912);
  lua_setfield(L, -2, "GL_FOG");

  lua_pushnumber(L, 2917);
  lua_setfield(L, -2, "GL_FOG_MODE");

  lua_pushnumber(L, 2914);
  lua_setfield(L, -2, "GL_FOG_DENSITY");

  lua_pushnumber(L, 2918);
  lua_setfield(L, -2, "GL_FOG_COLOR");

  lua_pushnumber(L, 2913);
  lua_setfield(L, -2, "GL_FOG_INDEX");

  lua_pushnumber(L, 2915);
  lua_setfield(L, -2, "GL_FOG_START");

  lua_pushnumber(L, 2916);
  lua_setfield(L, -2, "GL_FOG_END");

  lua_pushnumber(L, 9729);
  lua_setfield(L, -2, "GL_LINEAR");

  lua_pushnumber(L, 2048);
  lua_setfield(L, -2, "GL_EXP");

  lua_pushnumber(L, 2049);
  lua_setfield(L, -2, "GL_EXP2");

  lua_pushnumber(L, 3057);
  lua_setfield(L, -2, "GL_LOGIC_OP");

  lua_pushnumber(L, 3057);
  lua_setfield(L, -2, "GL_INDEX_LOGIC_OP");

  lua_pushnumber(L, 3058);
  lua_setfield(L, -2, "GL_COLOR_LOGIC_OP");

  lua_pushnumber(L, 3056);
  lua_setfield(L, -2, "GL_LOGIC_OP_MODE");

  lua_pushnumber(L, 5376);
  lua_setfield(L, -2, "GL_CLEAR");

  lua_pushnumber(L, 5391);
  lua_setfield(L, -2, "GL_SET");

  lua_pushnumber(L, 5379);
  lua_setfield(L, -2, "GL_COPY");

  lua_pushnumber(L, 5388);
  lua_setfield(L, -2, "GL_COPY_INVERTED");

  lua_pushnumber(L, 5381);
  lua_setfield(L, -2, "GL_NOOP");

  lua_pushnumber(L, 5386);
  lua_setfield(L, -2, "GL_INVERT");

  lua_pushnumber(L, 5377);
  lua_setfield(L, -2, "GL_AND");

  lua_pushnumber(L, 5390);
  lua_setfield(L, -2, "GL_NAND");

  lua_pushnumber(L, 5383);
  lua_setfield(L, -2, "GL_OR");

  lua_pushnumber(L, 5384);
  lua_setfield(L, -2, "GL_NOR");

  lua_pushnumber(L, 5382);
  lua_setfield(L, -2, "GL_XOR");

  lua_pushnumber(L, 5385);
  lua_setfield(L, -2, "GL_EQUIV");

  lua_pushnumber(L, 5378);
  lua_setfield(L, -2, "GL_AND_REVERSE");

  lua_pushnumber(L, 5380);
  lua_setfield(L, -2, "GL_AND_INVERTED");

  lua_pushnumber(L, 5387);
  lua_setfield(L, -2, "GL_OR_REVERSE");

  lua_pushnumber(L, 5389);
  lua_setfield(L, -2, "GL_OR_INVERTED");

  lua_pushnumber(L, 3415);
  lua_setfield(L, -2, "GL_STENCIL_BITS");

  lua_pushnumber(L, 2960);
  lua_setfield(L, -2, "GL_STENCIL_TEST");

  lua_pushnumber(L, 2961);
  lua_setfield(L, -2, "GL_STENCIL_CLEAR_VALUE");

  lua_pushnumber(L, 2962);
  lua_setfield(L, -2, "GL_STENCIL_FUNC");

  lua_pushnumber(L, 2963);
  lua_setfield(L, -2, "GL_STENCIL_VALUE_MASK");

  lua_pushnumber(L, 2964);
  lua_setfield(L, -2, "GL_STENCIL_FAIL");

  lua_pushnumber(L, 2965);
  lua_setfield(L, -2, "GL_STENCIL_PASS_DEPTH_FAIL");

  lua_pushnumber(L, 2966);
  lua_setfield(L, -2, "GL_STENCIL_PASS_DEPTH_PASS");

  lua_pushnumber(L, 2967);
  lua_setfield(L, -2, "GL_STENCIL_REF");

  lua_pushnumber(L, 2968);
  lua_setfield(L, -2, "GL_STENCIL_WRITEMASK");

  lua_pushnumber(L, 6401);
  lua_setfield(L, -2, "GL_STENCIL_INDEX");

  lua_pushnumber(L, 7680);
  lua_setfield(L, -2, "GL_KEEP");

  lua_pushnumber(L, 7681);
  lua_setfield(L, -2, "GL_REPLACE");

  lua_pushnumber(L, 7682);
  lua_setfield(L, -2, "GL_INCR");

  lua_pushnumber(L, 7683);
  lua_setfield(L, -2, "GL_DECR");

  lua_pushnumber(L, 0);
  lua_setfield(L, -2, "GL_NONE");

  lua_pushnumber(L, 1030);
  lua_setfield(L, -2, "GL_LEFT");

  lua_pushnumber(L, 1031);
  lua_setfield(L, -2, "GL_RIGHT");

  lua_pushnumber(L, 1024);
  lua_setfield(L, -2, "GL_FRONT_LEFT");

  lua_pushnumber(L, 1025);
  lua_setfield(L, -2, "GL_FRONT_RIGHT");

  lua_pushnumber(L, 1026);
  lua_setfield(L, -2, "GL_BACK_LEFT");

  lua_pushnumber(L, 1027);
  lua_setfield(L, -2, "GL_BACK_RIGHT");

  lua_pushnumber(L, 1033);
  lua_setfield(L, -2, "GL_AUX0");

  lua_pushnumber(L, 1034);
  lua_setfield(L, -2, "GL_AUX1");

  lua_pushnumber(L, 1035);
  lua_setfield(L, -2, "GL_AUX2");

  lua_pushnumber(L, 1036);
  lua_setfield(L, -2, "GL_AUX3");

  lua_pushnumber(L, 6400);
  lua_setfield(L, -2, "GL_COLOR_INDEX");

  lua_pushnumber(L, 6403);
  lua_setfield(L, -2, "GL_RED");

  lua_pushnumber(L, 6404);
  lua_setfield(L, -2, "GL_GREEN");

  lua_pushnumber(L, 6405);
  lua_setfield(L, -2, "GL_BLUE");

  lua_pushnumber(L, 6406);
  lua_setfield(L, -2, "GL_ALPHA");

  lua_pushnumber(L, 6409);
  lua_setfield(L, -2, "GL_LUMINANCE");

  lua_pushnumber(L, 6410);
  lua_setfield(L, -2, "GL_LUMINANCE_ALPHA");

  lua_pushnumber(L, 3413);
  lua_setfield(L, -2, "GL_ALPHA_BITS");

  lua_pushnumber(L, 3410);
  lua_setfield(L, -2, "GL_RED_BITS");

  lua_pushnumber(L, 3411);
  lua_setfield(L, -2, "GL_GREEN_BITS");

  lua_pushnumber(L, 3412);
  lua_setfield(L, -2, "GL_BLUE_BITS");

  lua_pushnumber(L, 3409);
  lua_setfield(L, -2, "GL_INDEX_BITS");

  lua_pushnumber(L, 3408);
  lua_setfield(L, -2, "GL_SUBPIXEL_BITS");

  lua_pushnumber(L, 3072);
  lua_setfield(L, -2, "GL_AUX_BUFFERS");

  lua_pushnumber(L, 3074);
  lua_setfield(L, -2, "GL_READ_BUFFER");

  lua_pushnumber(L, 3073);
  lua_setfield(L, -2, "GL_DRAW_BUFFER");

  lua_pushnumber(L, 3122);
  lua_setfield(L, -2, "GL_DOUBLEBUFFER");

  lua_pushnumber(L, 3123);
  lua_setfield(L, -2, "GL_STEREO");

  lua_pushnumber(L, 6656);
  lua_setfield(L, -2, "GL_BITMAP");

  lua_pushnumber(L, 6144);
  lua_setfield(L, -2, "GL_COLOR");

  lua_pushnumber(L, 6145);
  lua_setfield(L, -2, "GL_DEPTH");

  lua_pushnumber(L, 6146);
  lua_setfield(L, -2, "GL_STENCIL");

  lua_pushnumber(L, 3024);
  lua_setfield(L, -2, "GL_DITHER");

  lua_pushnumber(L, 6407);
  lua_setfield(L, -2, "GL_RGB");

  lua_pushnumber(L, 6408);
  lua_setfield(L, -2, "GL_RGBA");

  lua_pushnumber(L, 2865);
  lua_setfield(L, -2, "GL_MAX_LIST_NESTING");

  lua_pushnumber(L, 3376);
  lua_setfield(L, -2, "GL_MAX_EVAL_ORDER");

  lua_pushnumber(L, 3377);
  lua_setfield(L, -2, "GL_MAX_LIGHTS");

  lua_pushnumber(L, 3378);
  lua_setfield(L, -2, "GL_MAX_CLIP_PLANES");

  lua_pushnumber(L, 3379);
  lua_setfield(L, -2, "GL_MAX_TEXTURE_SIZE");

  lua_pushnumber(L, 3380);
  lua_setfield(L, -2, "GL_MAX_PIXEL_MAP_TABLE");

  lua_pushnumber(L, 3381);
  lua_setfield(L, -2, "GL_MAX_ATTRIB_STACK_DEPTH");

  lua_pushnumber(L, 3382);
  lua_setfield(L, -2, "GL_MAX_MODELVIEW_STACK_DEPTH");

  lua_pushnumber(L, 3383);
  lua_setfield(L, -2, "GL_MAX_NAME_STACK_DEPTH");

  lua_pushnumber(L, 3384);
  lua_setfield(L, -2, "GL_MAX_PROJECTION_STACK_DEPTH");

  lua_pushnumber(L, 3385);
  lua_setfield(L, -2, "GL_MAX_TEXTURE_STACK_DEPTH");

  lua_pushnumber(L, 3386);
  lua_setfield(L, -2, "GL_MAX_VIEWPORT_DIMS");

  lua_pushnumber(L, 3387);
  lua_setfield(L, -2, "GL_MAX_CLIENT_ATTRIB_STACK_DEPTH");

  lua_pushnumber(L, 2992);
  lua_setfield(L, -2, "GL_ATTRIB_STACK_DEPTH");

  lua_pushnumber(L, 2993);
  lua_setfield(L, -2, "GL_CLIENT_ATTRIB_STACK_DEPTH");

  lua_pushnumber(L, 3106);
  lua_setfield(L, -2, "GL_COLOR_CLEAR_VALUE");

  lua_pushnumber(L, 3107);
  lua_setfield(L, -2, "GL_COLOR_WRITEMASK");

  lua_pushnumber(L, 2817);
  lua_setfield(L, -2, "GL_CURRENT_INDEX");

  lua_pushnumber(L, 2816);
  lua_setfield(L, -2, "GL_CURRENT_COLOR");

  lua_pushnumber(L, 2818);
  lua_setfield(L, -2, "GL_CURRENT_NORMAL");

  lua_pushnumber(L, 2820);
  lua_setfield(L, -2, "GL_CURRENT_RASTER_COLOR");

  lua_pushnumber(L, 2825);
  lua_setfield(L, -2, "GL_CURRENT_RASTER_DISTANCE");

  lua_pushnumber(L, 2821);
  lua_setfield(L, -2, "GL_CURRENT_RASTER_INDEX");

  lua_pushnumber(L, 2823);
  lua_setfield(L, -2, "GL_CURRENT_RASTER_POSITION");

  lua_pushnumber(L, 2822);
  lua_setfield(L, -2, "GL_CURRENT_RASTER_TEXTURE_COORDS");

  lua_pushnumber(L, 2824);
  lua_setfield(L, -2, "GL_CURRENT_RASTER_POSITION_VALID");

  lua_pushnumber(L, 2819);
  lua_setfield(L, -2, "GL_CURRENT_TEXTURE_COORDS");

  lua_pushnumber(L, 3104);
  lua_setfield(L, -2, "GL_INDEX_CLEAR_VALUE");

  lua_pushnumber(L, 3120);
  lua_setfield(L, -2, "GL_INDEX_MODE");

  lua_pushnumber(L, 3105);
  lua_setfield(L, -2, "GL_INDEX_WRITEMASK");

  lua_pushnumber(L, 2982);
  lua_setfield(L, -2, "GL_MODELVIEW_MATRIX");

  lua_pushnumber(L, 2979);
  lua_setfield(L, -2, "GL_MODELVIEW_STACK_DEPTH");

  lua_pushnumber(L, 3440);
  lua_setfield(L, -2, "GL_NAME_STACK_DEPTH");

  lua_pushnumber(L, 2983);
  lua_setfield(L, -2, "GL_PROJECTION_MATRIX");

  lua_pushnumber(L, 2980);
  lua_setfield(L, -2, "GL_PROJECTION_STACK_DEPTH");

  lua_pushnumber(L, 3136);
  lua_setfield(L, -2, "GL_RENDER_MODE");

  lua_pushnumber(L, 3121);
  lua_setfield(L, -2, "GL_RGBA_MODE");

  lua_pushnumber(L, 2984);
  lua_setfield(L, -2, "GL_TEXTURE_MATRIX");

  lua_pushnumber(L, 2981);
  lua_setfield(L, -2, "GL_TEXTURE_STACK_DEPTH");

  lua_pushnumber(L, 2978);
  lua_setfield(L, -2, "GL_VIEWPORT");

  lua_pushnumber(L, 3456);
  lua_setfield(L, -2, "GL_AUTO_NORMAL");

  lua_pushnumber(L, 3472);
  lua_setfield(L, -2, "GL_MAP1_COLOR_4");

  lua_pushnumber(L, 3473);
  lua_setfield(L, -2, "GL_MAP1_INDEX");

  lua_pushnumber(L, 3474);
  lua_setfield(L, -2, "GL_MAP1_NORMAL");

  lua_pushnumber(L, 3475);
  lua_setfield(L, -2, "GL_MAP1_TEXTURE_COORD_1");

  lua_pushnumber(L, 3476);
  lua_setfield(L, -2, "GL_MAP1_TEXTURE_COORD_2");

  lua_pushnumber(L, 3477);
  lua_setfield(L, -2, "GL_MAP1_TEXTURE_COORD_3");

  lua_pushnumber(L, 3478);
  lua_setfield(L, -2, "GL_MAP1_TEXTURE_COORD_4");

  lua_pushnumber(L, 3479);
  lua_setfield(L, -2, "GL_MAP1_VERTEX_3");

  lua_pushnumber(L, 3480);
  lua_setfield(L, -2, "GL_MAP1_VERTEX_4");

  lua_pushnumber(L, 3504);
  lua_setfield(L, -2, "GL_MAP2_COLOR_4");

  lua_pushnumber(L, 3505);
  lua_setfield(L, -2, "GL_MAP2_INDEX");

  lua_pushnumber(L, 3506);
  lua_setfield(L, -2, "GL_MAP2_NORMAL");

  lua_pushnumber(L, 3507);
  lua_setfield(L, -2, "GL_MAP2_TEXTURE_COORD_1");

  lua_pushnumber(L, 3508);
  lua_setfield(L, -2, "GL_MAP2_TEXTURE_COORD_2");

  lua_pushnumber(L, 3509);
  lua_setfield(L, -2, "GL_MAP2_TEXTURE_COORD_3");

  lua_pushnumber(L, 3510);
  lua_setfield(L, -2, "GL_MAP2_TEXTURE_COORD_4");

  lua_pushnumber(L, 3511);
  lua_setfield(L, -2, "GL_MAP2_VERTEX_3");

  lua_pushnumber(L, 3512);
  lua_setfield(L, -2, "GL_MAP2_VERTEX_4");

  lua_pushnumber(L, 3536);
  lua_setfield(L, -2, "GL_MAP1_GRID_DOMAIN");

  lua_pushnumber(L, 3537);
  lua_setfield(L, -2, "GL_MAP1_GRID_SEGMENTS");

  lua_pushnumber(L, 3538);
  lua_setfield(L, -2, "GL_MAP2_GRID_DOMAIN");

  lua_pushnumber(L, 3539);
  lua_setfield(L, -2, "GL_MAP2_GRID_SEGMENTS");

  lua_pushnumber(L, 2560);
  lua_setfield(L, -2, "GL_COEFF");

  lua_pushnumber(L, 2561);
  lua_setfield(L, -2, "GL_ORDER");

  lua_pushnumber(L, 2562);
  lua_setfield(L, -2, "GL_DOMAIN");

  lua_pushnumber(L, 3152);
  lua_setfield(L, -2, "GL_PERSPECTIVE_CORRECTION_HINT");

  lua_pushnumber(L, 3153);
  lua_setfield(L, -2, "GL_POINT_SMOOTH_HINT");

  lua_pushnumber(L, 3154);
  lua_setfield(L, -2, "GL_LINE_SMOOTH_HINT");

  lua_pushnumber(L, 3155);
  lua_setfield(L, -2, "GL_POLYGON_SMOOTH_HINT");

  lua_pushnumber(L, 3156);
  lua_setfield(L, -2, "GL_FOG_HINT");

  lua_pushnumber(L, 4352);
  lua_setfield(L, -2, "GL_DONT_CARE");

  lua_pushnumber(L, 4353);
  lua_setfield(L, -2, "GL_FASTEST");

  lua_pushnumber(L, 4354);
  lua_setfield(L, -2, "GL_NICEST");

  lua_pushnumber(L, 3088);
  lua_setfield(L, -2, "GL_SCISSOR_BOX");

  lua_pushnumber(L, 3089);
  lua_setfield(L, -2, "GL_SCISSOR_TEST");

  lua_pushnumber(L, 3344);
  lua_setfield(L, -2, "GL_MAP_COLOR");

  lua_pushnumber(L, 3345);
  lua_setfield(L, -2, "GL_MAP_STENCIL");

  lua_pushnumber(L, 3346);
  lua_setfield(L, -2, "GL_INDEX_SHIFT");

  lua_pushnumber(L, 3347);
  lua_setfield(L, -2, "GL_INDEX_OFFSET");

  lua_pushnumber(L, 3348);
  lua_setfield(L, -2, "GL_RED_SCALE");

  lua_pushnumber(L, 3349);
  lua_setfield(L, -2, "GL_RED_BIAS");

  lua_pushnumber(L, 3352);
  lua_setfield(L, -2, "GL_GREEN_SCALE");

  lua_pushnumber(L, 3353);
  lua_setfield(L, -2, "GL_GREEN_BIAS");

  lua_pushnumber(L, 3354);
  lua_setfield(L, -2, "GL_BLUE_SCALE");

  lua_pushnumber(L, 3355);
  lua_setfield(L, -2, "GL_BLUE_BIAS");

  lua_pushnumber(L, 3356);
  lua_setfield(L, -2, "GL_ALPHA_SCALE");

  lua_pushnumber(L, 3357);
  lua_setfield(L, -2, "GL_ALPHA_BIAS");

  lua_pushnumber(L, 3358);
  lua_setfield(L, -2, "GL_DEPTH_SCALE");

  lua_pushnumber(L, 3359);
  lua_setfield(L, -2, "GL_DEPTH_BIAS");

  lua_pushnumber(L, 3249);
  lua_setfield(L, -2, "GL_PIXEL_MAP_S_TO_S_SIZE");

  lua_pushnumber(L, 3248);
  lua_setfield(L, -2, "GL_PIXEL_MAP_I_TO_I_SIZE");

  lua_pushnumber(L, 3250);
  lua_setfield(L, -2, "GL_PIXEL_MAP_I_TO_R_SIZE");

  lua_pushnumber(L, 3251);
  lua_setfield(L, -2, "GL_PIXEL_MAP_I_TO_G_SIZE");

  lua_pushnumber(L, 3252);
  lua_setfield(L, -2, "GL_PIXEL_MAP_I_TO_B_SIZE");

  lua_pushnumber(L, 3253);
  lua_setfield(L, -2, "GL_PIXEL_MAP_I_TO_A_SIZE");

  lua_pushnumber(L, 3254);
  lua_setfield(L, -2, "GL_PIXEL_MAP_R_TO_R_SIZE");

  lua_pushnumber(L, 3255);
  lua_setfield(L, -2, "GL_PIXEL_MAP_G_TO_G_SIZE");

  lua_pushnumber(L, 3256);
  lua_setfield(L, -2, "GL_PIXEL_MAP_B_TO_B_SIZE");

  lua_pushnumber(L, 3257);
  lua_setfield(L, -2, "GL_PIXEL_MAP_A_TO_A_SIZE");

  lua_pushnumber(L, 3185);
  lua_setfield(L, -2, "GL_PIXEL_MAP_S_TO_S");

  lua_pushnumber(L, 3184);
  lua_setfield(L, -2, "GL_PIXEL_MAP_I_TO_I");

  lua_pushnumber(L, 3186);
  lua_setfield(L, -2, "GL_PIXEL_MAP_I_TO_R");

  lua_pushnumber(L, 3187);
  lua_setfield(L, -2, "GL_PIXEL_MAP_I_TO_G");

  lua_pushnumber(L, 3188);
  lua_setfield(L, -2, "GL_PIXEL_MAP_I_TO_B");

  lua_pushnumber(L, 3189);
  lua_setfield(L, -2, "GL_PIXEL_MAP_I_TO_A");

  lua_pushnumber(L, 3190);
  lua_setfield(L, -2, "GL_PIXEL_MAP_R_TO_R");

  lua_pushnumber(L, 3191);
  lua_setfield(L, -2, "GL_PIXEL_MAP_G_TO_G");

  lua_pushnumber(L, 3192);
  lua_setfield(L, -2, "GL_PIXEL_MAP_B_TO_B");

  lua_pushnumber(L, 3193);
  lua_setfield(L, -2, "GL_PIXEL_MAP_A_TO_A");

  lua_pushnumber(L, 3333);
  lua_setfield(L, -2, "GL_PACK_ALIGNMENT");

  lua_pushnumber(L, 3329);
  lua_setfield(L, -2, "GL_PACK_LSB_FIRST");

  lua_pushnumber(L, 3330);
  lua_setfield(L, -2, "GL_PACK_ROW_LENGTH");

  lua_pushnumber(L, 3332);
  lua_setfield(L, -2, "GL_PACK_SKIP_PIXELS");

  lua_pushnumber(L, 3331);
  lua_setfield(L, -2, "GL_PACK_SKIP_ROWS");

  lua_pushnumber(L, 3328);
  lua_setfield(L, -2, "GL_PACK_SWAP_BYTES");

  lua_pushnumber(L, 3317);
  lua_setfield(L, -2, "GL_UNPACK_ALIGNMENT");

  lua_pushnumber(L, 3313);
  lua_setfield(L, -2, "GL_UNPACK_LSB_FIRST");

  lua_pushnumber(L, 3314);
  lua_setfield(L, -2, "GL_UNPACK_ROW_LENGTH");

  lua_pushnumber(L, 3316);
  lua_setfield(L, -2, "GL_UNPACK_SKIP_PIXELS");

  lua_pushnumber(L, 3315);
  lua_setfield(L, -2, "GL_UNPACK_SKIP_ROWS");

  lua_pushnumber(L, 3312);
  lua_setfield(L, -2, "GL_UNPACK_SWAP_BYTES");

  lua_pushnumber(L, 3350);
  lua_setfield(L, -2, "GL_ZOOM_X");

  lua_pushnumber(L, 3351);
  lua_setfield(L, -2, "GL_ZOOM_Y");

  lua_pushnumber(L, 8960);
  lua_setfield(L, -2, "GL_TEXTURE_ENV");

  lua_pushnumber(L, 8704);
  lua_setfield(L, -2, "GL_TEXTURE_ENV_MODE");

  lua_pushnumber(L, 3552);
  lua_setfield(L, -2, "GL_TEXTURE_1D");

  lua_pushnumber(L, 3553);
  lua_setfield(L, -2, "GL_TEXTURE_2D");

  lua_pushnumber(L, 10242);
  lua_setfield(L, -2, "GL_TEXTURE_WRAP_S");

  lua_pushnumber(L, 10243);
  lua_setfield(L, -2, "GL_TEXTURE_WRAP_T");

  lua_pushnumber(L, 10240);
  lua_setfield(L, -2, "GL_TEXTURE_MAG_FILTER");

  lua_pushnumber(L, 10241);
  lua_setfield(L, -2, "GL_TEXTURE_MIN_FILTER");

  lua_pushnumber(L, 8705);
  lua_setfield(L, -2, "GL_TEXTURE_ENV_COLOR");

  lua_pushnumber(L, 3168);
  lua_setfield(L, -2, "GL_TEXTURE_GEN_S");

  lua_pushnumber(L, 3169);
  lua_setfield(L, -2, "GL_TEXTURE_GEN_T");

  lua_pushnumber(L, 9472);
  lua_setfield(L, -2, "GL_TEXTURE_GEN_MODE");

  lua_pushnumber(L, 4100);
  lua_setfield(L, -2, "GL_TEXTURE_BORDER_COLOR");

  lua_pushnumber(L, 4096);
  lua_setfield(L, -2, "GL_TEXTURE_WIDTH");

  lua_pushnumber(L, 4097);
  lua_setfield(L, -2, "GL_TEXTURE_HEIGHT");

  lua_pushnumber(L, 4101);
  lua_setfield(L, -2, "GL_TEXTURE_BORDER");

  lua_pushnumber(L, 4099);
  lua_setfield(L, -2, "GL_TEXTURE_COMPONENTS");

  lua_pushnumber(L, 32860);
  lua_setfield(L, -2, "GL_TEXTURE_RED_SIZE");

  lua_pushnumber(L, 32861);
  lua_setfield(L, -2, "GL_TEXTURE_GREEN_SIZE");

  lua_pushnumber(L, 32862);
  lua_setfield(L, -2, "GL_TEXTURE_BLUE_SIZE");

  lua_pushnumber(L, 32863);
  lua_setfield(L, -2, "GL_TEXTURE_ALPHA_SIZE");

  lua_pushnumber(L, 32864);
  lua_setfield(L, -2, "GL_TEXTURE_LUMINANCE_SIZE");

  lua_pushnumber(L, 32865);
  lua_setfield(L, -2, "GL_TEXTURE_INTENSITY_SIZE");

  lua_pushnumber(L, 9984);
  lua_setfield(L, -2, "GL_NEAREST_MIPMAP_NEAREST");

  lua_pushnumber(L, 9986);
  lua_setfield(L, -2, "GL_NEAREST_MIPMAP_LINEAR");

  lua_pushnumber(L, 9985);
  lua_setfield(L, -2, "GL_LINEAR_MIPMAP_NEAREST");

  lua_pushnumber(L, 9987);
  lua_setfield(L, -2, "GL_LINEAR_MIPMAP_LINEAR");

  lua_pushnumber(L, 9217);
  lua_setfield(L, -2, "GL_OBJECT_LINEAR");

  lua_pushnumber(L, 9473);
  lua_setfield(L, -2, "GL_OBJECT_PLANE");

  lua_pushnumber(L, 9216);
  lua_setfield(L, -2, "GL_EYE_LINEAR");

  lua_pushnumber(L, 9474);
  lua_setfield(L, -2, "GL_EYE_PLANE");

  lua_pushnumber(L, 9218);
  lua_setfield(L, -2, "GL_SPHERE_MAP");

  lua_pushnumber(L, 8449);
  lua_setfield(L, -2, "GL_DECAL");

  lua_pushnumber(L, 8448);
  lua_setfield(L, -2, "GL_MODULATE");

  lua_pushnumber(L, 9728);
  lua_setfield(L, -2, "GL_NEAREST");

  lua_pushnumber(L, 10497);
  lua_setfield(L, -2, "GL_REPEAT");

  lua_pushnumber(L, 10496);
  lua_setfield(L, -2, "GL_CLAMP");

  lua_pushnumber(L, 8192);
  lua_setfield(L, -2, "GL_S");

  lua_pushnumber(L, 8193);
  lua_setfield(L, -2, "GL_T");

  lua_pushnumber(L, 8194);
  lua_setfield(L, -2, "GL_R");

  lua_pushnumber(L, 8195);
  lua_setfield(L, -2, "GL_Q");

  lua_pushnumber(L, 3170);
  lua_setfield(L, -2, "GL_TEXTURE_GEN_R");

  lua_pushnumber(L, 3171);
  lua_setfield(L, -2, "GL_TEXTURE_GEN_Q");

  lua_pushnumber(L, 7936);
  lua_setfield(L, -2, "GL_VENDOR");

  lua_pushnumber(L, 7937);
  lua_setfield(L, -2, "GL_RENDERER");

  lua_pushnumber(L, 7938);
  lua_setfield(L, -2, "GL_VERSION");

  lua_pushnumber(L, 7939);
  lua_setfield(L, -2, "GL_EXTENSIONS");

  lua_pushnumber(L, 0);
  lua_setfield(L, -2, "GL_NO_ERROR");

  lua_pushnumber(L, 1280);
  lua_setfield(L, -2, "GL_INVALID_ENUM");

  lua_pushnumber(L, 1281);
  lua_setfield(L, -2, "GL_INVALID_VALUE");

  lua_pushnumber(L, 1282);
  lua_setfield(L, -2, "GL_INVALID_OPERATION");

  lua_pushnumber(L, 1283);
  lua_setfield(L, -2, "GL_STACK_OVERFLOW");

  lua_pushnumber(L, 1284);
  lua_setfield(L, -2, "GL_STACK_UNDERFLOW");

  lua_pushnumber(L, 1285);
  lua_setfield(L, -2, "GL_OUT_OF_MEMORY");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_CURRENT_BIT");

  lua_pushnumber(L, 2);
  lua_setfield(L, -2, "GL_POINT_BIT");

  lua_pushnumber(L, 4);
  lua_setfield(L, -2, "GL_LINE_BIT");

  lua_pushnumber(L, 8);
  lua_setfield(L, -2, "GL_POLYGON_BIT");

  lua_pushnumber(L, 16);
  lua_setfield(L, -2, "GL_POLYGON_STIPPLE_BIT");

  lua_pushnumber(L, 32);
  lua_setfield(L, -2, "GL_PIXEL_MODE_BIT");

  lua_pushnumber(L, 64);
  lua_setfield(L, -2, "GL_LIGHTING_BIT");

  lua_pushnumber(L, 128);
  lua_setfield(L, -2, "GL_FOG_BIT");

  lua_pushnumber(L, 256);
  lua_setfield(L, -2, "GL_DEPTH_BUFFER_BIT");

  lua_pushnumber(L, 512);
  lua_setfield(L, -2, "GL_ACCUM_BUFFER_BIT");

  lua_pushnumber(L, 1024);
  lua_setfield(L, -2, "GL_STENCIL_BUFFER_BIT");

  lua_pushnumber(L, 2048);
  lua_setfield(L, -2, "GL_VIEWPORT_BIT");

  lua_pushnumber(L, 4096);
  lua_setfield(L, -2, "GL_TRANSFORM_BIT");

  lua_pushnumber(L, 8192);
  lua_setfield(L, -2, "GL_ENABLE_BIT");

  lua_pushnumber(L, 16384);
  lua_setfield(L, -2, "GL_COLOR_BUFFER_BIT");

  lua_pushnumber(L, 32768);
  lua_setfield(L, -2, "GL_HINT_BIT");

  lua_pushnumber(L, 65536);
  lua_setfield(L, -2, "GL_EVAL_BIT");

  lua_pushnumber(L, 131072);
  lua_setfield(L, -2, "GL_LIST_BIT");

  lua_pushnumber(L, 262144);
  lua_setfield(L, -2, "GL_TEXTURE_BIT");

  lua_pushnumber(L, 524288);
  lua_setfield(L, -2, "GL_SCISSOR_BIT");

  lua_pushnumber(L, 1048575);
  lua_setfield(L, -2, "GL_ALL_ATTRIB_BITS");

  lua_pushnumber(L, 32867);
  lua_setfield(L, -2, "GL_PROXY_TEXTURE_1D");

  lua_pushnumber(L, 32868);
  lua_setfield(L, -2, "GL_PROXY_TEXTURE_2D");

  lua_pushnumber(L, 32870);
  lua_setfield(L, -2, "GL_TEXTURE_PRIORITY");

  lua_pushnumber(L, 32871);
  lua_setfield(L, -2, "GL_TEXTURE_RESIDENT");

  lua_pushnumber(L, 32872);
  lua_setfield(L, -2, "GL_TEXTURE_BINDING_1D");

  lua_pushnumber(L, 32873);
  lua_setfield(L, -2, "GL_TEXTURE_BINDING_2D");

  lua_pushnumber(L, 4099);
  lua_setfield(L, -2, "GL_TEXTURE_INTERNAL_FORMAT");

  lua_pushnumber(L, 32827);
  lua_setfield(L, -2, "GL_ALPHA4");

  lua_pushnumber(L, 32828);
  lua_setfield(L, -2, "GL_ALPHA8");

  lua_pushnumber(L, 32829);
  lua_setfield(L, -2, "GL_ALPHA12");

  lua_pushnumber(L, 32830);
  lua_setfield(L, -2, "GL_ALPHA16");

  lua_pushnumber(L, 32831);
  lua_setfield(L, -2, "GL_LUMINANCE4");

  lua_pushnumber(L, 32832);
  lua_setfield(L, -2, "GL_LUMINANCE8");

  lua_pushnumber(L, 32833);
  lua_setfield(L, -2, "GL_LUMINANCE12");

  lua_pushnumber(L, 32834);
  lua_setfield(L, -2, "GL_LUMINANCE16");

  lua_pushnumber(L, 32835);
  lua_setfield(L, -2, "GL_LUMINANCE4_ALPHA4");

  lua_pushnumber(L, 32836);
  lua_setfield(L, -2, "GL_LUMINANCE6_ALPHA2");

  lua_pushnumber(L, 32837);
  lua_setfield(L, -2, "GL_LUMINANCE8_ALPHA8");

  lua_pushnumber(L, 32838);
  lua_setfield(L, -2, "GL_LUMINANCE12_ALPHA4");

  lua_pushnumber(L, 32839);
  lua_setfield(L, -2, "GL_LUMINANCE12_ALPHA12");

  lua_pushnumber(L, 32840);
  lua_setfield(L, -2, "GL_LUMINANCE16_ALPHA16");

  lua_pushnumber(L, 32841);
  lua_setfield(L, -2, "GL_INTENSITY");

  lua_pushnumber(L, 32842);
  lua_setfield(L, -2, "GL_INTENSITY4");

  lua_pushnumber(L, 32843);
  lua_setfield(L, -2, "GL_INTENSITY8");

  lua_pushnumber(L, 32844);
  lua_setfield(L, -2, "GL_INTENSITY12");

  lua_pushnumber(L, 32845);
  lua_setfield(L, -2, "GL_INTENSITY16");

  lua_pushnumber(L, 10768);
  lua_setfield(L, -2, "GL_R3_G3_B2");

  lua_pushnumber(L, 32847);
  lua_setfield(L, -2, "GL_RGB4");

  lua_pushnumber(L, 32848);
  lua_setfield(L, -2, "GL_RGB5");

  lua_pushnumber(L, 32849);
  lua_setfield(L, -2, "GL_RGB8");

  lua_pushnumber(L, 32850);
  lua_setfield(L, -2, "GL_RGB10");

  lua_pushnumber(L, 32851);
  lua_setfield(L, -2, "GL_RGB12");

  lua_pushnumber(L, 32852);
  lua_setfield(L, -2, "GL_RGB16");

  lua_pushnumber(L, 32853);
  lua_setfield(L, -2, "GL_RGBA2");

  lua_pushnumber(L, 32854);
  lua_setfield(L, -2, "GL_RGBA4");

  lua_pushnumber(L, 32855);
  lua_setfield(L, -2, "GL_RGB5_A1");

  lua_pushnumber(L, 32856);
  lua_setfield(L, -2, "GL_RGBA8");

  lua_pushnumber(L, 32857);
  lua_setfield(L, -2, "GL_RGB10_A2");

  lua_pushnumber(L, 32858);
  lua_setfield(L, -2, "GL_RGBA12");

  lua_pushnumber(L, 32859);
  lua_setfield(L, -2, "GL_RGBA16");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_CLIENT_PIXEL_STORE_BIT");

  lua_pushnumber(L, 2);
  lua_setfield(L, -2, "GL_CLIENT_VERTEX_ARRAY_BIT");

  lua_pushnumber(L, 4294967295);
  lua_setfield(L, -2, "GL_ALL_CLIENT_ATTRIB_BITS");

  lua_pushnumber(L, 4294967295);
  lua_setfield(L, -2, "GL_CLIENT_ALL_ATTRIB_BITS");

  lua_pushnumber(L, 32826);
  lua_setfield(L, -2, "GL_RESCALE_NORMAL");

  lua_pushnumber(L, 33071);
  lua_setfield(L, -2, "GL_CLAMP_TO_EDGE");

  lua_pushnumber(L, 33000);
  lua_setfield(L, -2, "GL_MAX_ELEMENTS_VERTICES");

  lua_pushnumber(L, 33001);
  lua_setfield(L, -2, "GL_MAX_ELEMENTS_INDICES");

  lua_pushnumber(L, 32992);
  lua_setfield(L, -2, "GL_BGR");

  lua_pushnumber(L, 32993);
  lua_setfield(L, -2, "GL_BGRA");

  lua_pushnumber(L, 32818);
  lua_setfield(L, -2, "GL_UNSIGNED_BYTE_3_3_2");

  lua_pushnumber(L, 33634);
  lua_setfield(L, -2, "GL_UNSIGNED_BYTE_2_3_3_REV");

  lua_pushnumber(L, 33635);
  lua_setfield(L, -2, "GL_UNSIGNED_SHORT_5_6_5");

  lua_pushnumber(L, 33636);
  lua_setfield(L, -2, "GL_UNSIGNED_SHORT_5_6_5_REV");

  lua_pushnumber(L, 32819);
  lua_setfield(L, -2, "GL_UNSIGNED_SHORT_4_4_4_4");

  lua_pushnumber(L, 33637);
  lua_setfield(L, -2, "GL_UNSIGNED_SHORT_4_4_4_4_REV");

  lua_pushnumber(L, 32820);
  lua_setfield(L, -2, "GL_UNSIGNED_SHORT_5_5_5_1");

  lua_pushnumber(L, 33638);
  lua_setfield(L, -2, "GL_UNSIGNED_SHORT_1_5_5_5_REV");

  lua_pushnumber(L, 32821);
  lua_setfield(L, -2, "GL_UNSIGNED_INT_8_8_8_8");

  lua_pushnumber(L, 33639);
  lua_setfield(L, -2, "GL_UNSIGNED_INT_8_8_8_8_REV");

  lua_pushnumber(L, 32822);
  lua_setfield(L, -2, "GL_UNSIGNED_INT_10_10_10_2");

  lua_pushnumber(L, 33640);
  lua_setfield(L, -2, "GL_UNSIGNED_INT_2_10_10_10_REV");

  lua_pushnumber(L, 33272);
  lua_setfield(L, -2, "GL_LIGHT_MODEL_COLOR_CONTROL");

  lua_pushnumber(L, 33273);
  lua_setfield(L, -2, "GL_SINGLE_COLOR");

  lua_pushnumber(L, 33274);
  lua_setfield(L, -2, "GL_SEPARATE_SPECULAR_COLOR");

  lua_pushnumber(L, 33082);
  lua_setfield(L, -2, "GL_TEXTURE_MIN_LOD");

  lua_pushnumber(L, 33083);
  lua_setfield(L, -2, "GL_TEXTURE_MAX_LOD");

  lua_pushnumber(L, 33084);
  lua_setfield(L, -2, "GL_TEXTURE_BASE_LEVEL");

  lua_pushnumber(L, 33085);
  lua_setfield(L, -2, "GL_TEXTURE_MAX_LEVEL");

  lua_pushnumber(L, 2834);
  lua_setfield(L, -2, "GL_SMOOTH_POINT_SIZE_RANGE");

  lua_pushnumber(L, 2835);
  lua_setfield(L, -2, "GL_SMOOTH_POINT_SIZE_GRANULARITY");

  lua_pushnumber(L, 2850);
  lua_setfield(L, -2, "GL_SMOOTH_LINE_WIDTH_RANGE");

  lua_pushnumber(L, 2851);
  lua_setfield(L, -2, "GL_SMOOTH_LINE_WIDTH_GRANULARITY");

  lua_pushnumber(L, 33901);
  lua_setfield(L, -2, "GL_ALIASED_POINT_SIZE_RANGE");

  lua_pushnumber(L, 33902);
  lua_setfield(L, -2, "GL_ALIASED_LINE_WIDTH_RANGE");

  lua_pushnumber(L, 32875);
  lua_setfield(L, -2, "GL_PACK_SKIP_IMAGES");

  lua_pushnumber(L, 32876);
  lua_setfield(L, -2, "GL_PACK_IMAGE_HEIGHT");

  lua_pushnumber(L, 32877);
  lua_setfield(L, -2, "GL_UNPACK_SKIP_IMAGES");

  lua_pushnumber(L, 32878);
  lua_setfield(L, -2, "GL_UNPACK_IMAGE_HEIGHT");

  lua_pushnumber(L, 32879);
  lua_setfield(L, -2, "GL_TEXTURE_3D");

  lua_pushnumber(L, 32880);
  lua_setfield(L, -2, "GL_PROXY_TEXTURE_3D");

  lua_pushnumber(L, 32881);
  lua_setfield(L, -2, "GL_TEXTURE_DEPTH");

  lua_pushnumber(L, 32882);
  lua_setfield(L, -2, "GL_TEXTURE_WRAP_R");

  lua_pushnumber(L, 32883);
  lua_setfield(L, -2, "GL_MAX_3D_TEXTURE_SIZE");

  lua_pushnumber(L, 32874);
  lua_setfield(L, -2, "GL_TEXTURE_BINDING_3D");

  lua_pushnumber(L, 32769);
  lua_setfield(L, -2, "GL_CONSTANT_COLOR");

  lua_pushnumber(L, 32770);
  lua_setfield(L, -2, "GL_ONE_MINUS_CONSTANT_COLOR");

  lua_pushnumber(L, 32771);
  lua_setfield(L, -2, "GL_CONSTANT_ALPHA");

  lua_pushnumber(L, 32772);
  lua_setfield(L, -2, "GL_ONE_MINUS_CONSTANT_ALPHA");

  lua_pushnumber(L, 32976);
  lua_setfield(L, -2, "GL_COLOR_TABLE");

  lua_pushnumber(L, 32977);
  lua_setfield(L, -2, "GL_POST_CONVOLUTION_COLOR_TABLE");

  lua_pushnumber(L, 32978);
  lua_setfield(L, -2, "GL_POST_COLOR_MATRIX_COLOR_TABLE");

  lua_pushnumber(L, 32979);
  lua_setfield(L, -2, "GL_PROXY_COLOR_TABLE");

  lua_pushnumber(L, 32980);
  lua_setfield(L, -2, "GL_PROXY_POST_CONVOLUTION_COLOR_TABLE");

  lua_pushnumber(L, 32981);
  lua_setfield(L, -2, "GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE");

  lua_pushnumber(L, 32982);
  lua_setfield(L, -2, "GL_COLOR_TABLE_SCALE");

  lua_pushnumber(L, 32983);
  lua_setfield(L, -2, "GL_COLOR_TABLE_BIAS");

  lua_pushnumber(L, 32984);
  lua_setfield(L, -2, "GL_COLOR_TABLE_FORMAT");

  lua_pushnumber(L, 32985);
  lua_setfield(L, -2, "GL_COLOR_TABLE_WIDTH");

  lua_pushnumber(L, 32986);
  lua_setfield(L, -2, "GL_COLOR_TABLE_RED_SIZE");

  lua_pushnumber(L, 32987);
  lua_setfield(L, -2, "GL_COLOR_TABLE_GREEN_SIZE");

  lua_pushnumber(L, 32988);
  lua_setfield(L, -2, "GL_COLOR_TABLE_BLUE_SIZE");

  lua_pushnumber(L, 32989);
  lua_setfield(L, -2, "GL_COLOR_TABLE_ALPHA_SIZE");

  lua_pushnumber(L, 32990);
  lua_setfield(L, -2, "GL_COLOR_TABLE_LUMINANCE_SIZE");

  lua_pushnumber(L, 32991);
  lua_setfield(L, -2, "GL_COLOR_TABLE_INTENSITY_SIZE");

  lua_pushnumber(L, 32784);
  lua_setfield(L, -2, "GL_CONVOLUTION_1D");

  lua_pushnumber(L, 32785);
  lua_setfield(L, -2, "GL_CONVOLUTION_2D");

  lua_pushnumber(L, 32786);
  lua_setfield(L, -2, "GL_SEPARABLE_2D");

  lua_pushnumber(L, 32787);
  lua_setfield(L, -2, "GL_CONVOLUTION_BORDER_MODE");

  lua_pushnumber(L, 32788);
  lua_setfield(L, -2, "GL_CONVOLUTION_FILTER_SCALE");

  lua_pushnumber(L, 32789);
  lua_setfield(L, -2, "GL_CONVOLUTION_FILTER_BIAS");

  lua_pushnumber(L, 32790);
  lua_setfield(L, -2, "GL_REDUCE");

  lua_pushnumber(L, 32791);
  lua_setfield(L, -2, "GL_CONVOLUTION_FORMAT");

  lua_pushnumber(L, 32792);
  lua_setfield(L, -2, "GL_CONVOLUTION_WIDTH");

  lua_pushnumber(L, 32793);
  lua_setfield(L, -2, "GL_CONVOLUTION_HEIGHT");

  lua_pushnumber(L, 32794);
  lua_setfield(L, -2, "GL_MAX_CONVOLUTION_WIDTH");

  lua_pushnumber(L, 32795);
  lua_setfield(L, -2, "GL_MAX_CONVOLUTION_HEIGHT");

  lua_pushnumber(L, 32796);
  lua_setfield(L, -2, "GL_POST_CONVOLUTION_RED_SCALE");

  lua_pushnumber(L, 32797);
  lua_setfield(L, -2, "GL_POST_CONVOLUTION_GREEN_SCALE");

  lua_pushnumber(L, 32798);
  lua_setfield(L, -2, "GL_POST_CONVOLUTION_BLUE_SCALE");

  lua_pushnumber(L, 32799);
  lua_setfield(L, -2, "GL_POST_CONVOLUTION_ALPHA_SCALE");

  lua_pushnumber(L, 32800);
  lua_setfield(L, -2, "GL_POST_CONVOLUTION_RED_BIAS");

  lua_pushnumber(L, 32801);
  lua_setfield(L, -2, "GL_POST_CONVOLUTION_GREEN_BIAS");

  lua_pushnumber(L, 32802);
  lua_setfield(L, -2, "GL_POST_CONVOLUTION_BLUE_BIAS");

  lua_pushnumber(L, 32803);
  lua_setfield(L, -2, "GL_POST_CONVOLUTION_ALPHA_BIAS");

  lua_pushnumber(L, 33105);
  lua_setfield(L, -2, "GL_CONSTANT_BORDER");

  lua_pushnumber(L, 33107);
  lua_setfield(L, -2, "GL_REPLICATE_BORDER");

  lua_pushnumber(L, 33108);
  lua_setfield(L, -2, "GL_CONVOLUTION_BORDER_COLOR");

  lua_pushnumber(L, 32945);
  lua_setfield(L, -2, "GL_COLOR_MATRIX");

  lua_pushnumber(L, 32946);
  lua_setfield(L, -2, "GL_COLOR_MATRIX_STACK_DEPTH");

  lua_pushnumber(L, 32947);
  lua_setfield(L, -2, "GL_MAX_COLOR_MATRIX_STACK_DEPTH");

  lua_pushnumber(L, 32948);
  lua_setfield(L, -2, "GL_POST_COLOR_MATRIX_RED_SCALE");

  lua_pushnumber(L, 32949);
  lua_setfield(L, -2, "GL_POST_COLOR_MATRIX_GREEN_SCALE");

  lua_pushnumber(L, 32950);
  lua_setfield(L, -2, "GL_POST_COLOR_MATRIX_BLUE_SCALE");

  lua_pushnumber(L, 32951);
  lua_setfield(L, -2, "GL_POST_COLOR_MATRIX_ALPHA_SCALE");

  lua_pushnumber(L, 32952);
  lua_setfield(L, -2, "GL_POST_COLOR_MATRIX_RED_BIAS");

  lua_pushnumber(L, 32953);
  lua_setfield(L, -2, "GL_POST_COLOR_MATRIX_GREEN_BIAS");

  lua_pushnumber(L, 32954);
  lua_setfield(L, -2, "GL_POST_COLOR_MATRIX_BLUE_BIAS");

  lua_pushnumber(L, 32955);
  lua_setfield(L, -2, "GL_POST_COLOR_MATRIX_ALPHA_BIAS");

  lua_pushnumber(L, 32804);
  lua_setfield(L, -2, "GL_HISTOGRAM");

  lua_pushnumber(L, 32805);
  lua_setfield(L, -2, "GL_PROXY_HISTOGRAM");

  lua_pushnumber(L, 32806);
  lua_setfield(L, -2, "GL_HISTOGRAM_WIDTH");

  lua_pushnumber(L, 32807);
  lua_setfield(L, -2, "GL_HISTOGRAM_FORMAT");

  lua_pushnumber(L, 32808);
  lua_setfield(L, -2, "GL_HISTOGRAM_RED_SIZE");

  lua_pushnumber(L, 32809);
  lua_setfield(L, -2, "GL_HISTOGRAM_GREEN_SIZE");

  lua_pushnumber(L, 32810);
  lua_setfield(L, -2, "GL_HISTOGRAM_BLUE_SIZE");

  lua_pushnumber(L, 32811);
  lua_setfield(L, -2, "GL_HISTOGRAM_ALPHA_SIZE");

  lua_pushnumber(L, 32812);
  lua_setfield(L, -2, "GL_HISTOGRAM_LUMINANCE_SIZE");

  lua_pushnumber(L, 32813);
  lua_setfield(L, -2, "GL_HISTOGRAM_SINK");

  lua_pushnumber(L, 32814);
  lua_setfield(L, -2, "GL_MINMAX");

  lua_pushnumber(L, 32815);
  lua_setfield(L, -2, "GL_MINMAX_FORMAT");

  lua_pushnumber(L, 32816);
  lua_setfield(L, -2, "GL_MINMAX_SINK");

  lua_pushnumber(L, 32817);
  lua_setfield(L, -2, "GL_TABLE_TOO_LARGE");

  lua_pushnumber(L, 32777);
  lua_setfield(L, -2, "GL_BLEND_EQUATION");

  lua_pushnumber(L, 32775);
  lua_setfield(L, -2, "GL_MIN");

  lua_pushnumber(L, 32776);
  lua_setfield(L, -2, "GL_MAX");

  lua_pushnumber(L, 32774);
  lua_setfield(L, -2, "GL_FUNC_ADD");

  lua_pushnumber(L, 32778);
  lua_setfield(L, -2, "GL_FUNC_SUBTRACT");

  lua_pushnumber(L, 32779);
  lua_setfield(L, -2, "GL_FUNC_REVERSE_SUBTRACT");

  lua_pushnumber(L, 32773);
  lua_setfield(L, -2, "GL_BLEND_COLOR");

  lua_pushnumber(L, 33984);
  lua_setfield(L, -2, "GL_TEXTURE0");

  lua_pushnumber(L, 33985);
  lua_setfield(L, -2, "GL_TEXTURE1");

  lua_pushnumber(L, 33986);
  lua_setfield(L, -2, "GL_TEXTURE2");

  lua_pushnumber(L, 33987);
  lua_setfield(L, -2, "GL_TEXTURE3");

  lua_pushnumber(L, 33988);
  lua_setfield(L, -2, "GL_TEXTURE4");

  lua_pushnumber(L, 33989);
  lua_setfield(L, -2, "GL_TEXTURE5");

  lua_pushnumber(L, 33990);
  lua_setfield(L, -2, "GL_TEXTURE6");

  lua_pushnumber(L, 33991);
  lua_setfield(L, -2, "GL_TEXTURE7");

  lua_pushnumber(L, 33992);
  lua_setfield(L, -2, "GL_TEXTURE8");

  lua_pushnumber(L, 33993);
  lua_setfield(L, -2, "GL_TEXTURE9");

  lua_pushnumber(L, 33994);
  lua_setfield(L, -2, "GL_TEXTURE10");

  lua_pushnumber(L, 33995);
  lua_setfield(L, -2, "GL_TEXTURE11");

  lua_pushnumber(L, 33996);
  lua_setfield(L, -2, "GL_TEXTURE12");

  lua_pushnumber(L, 33997);
  lua_setfield(L, -2, "GL_TEXTURE13");

  lua_pushnumber(L, 33998);
  lua_setfield(L, -2, "GL_TEXTURE14");

  lua_pushnumber(L, 33999);
  lua_setfield(L, -2, "GL_TEXTURE15");

  lua_pushnumber(L, 34000);
  lua_setfield(L, -2, "GL_TEXTURE16");

  lua_pushnumber(L, 34001);
  lua_setfield(L, -2, "GL_TEXTURE17");

  lua_pushnumber(L, 34002);
  lua_setfield(L, -2, "GL_TEXTURE18");

  lua_pushnumber(L, 34003);
  lua_setfield(L, -2, "GL_TEXTURE19");

  lua_pushnumber(L, 34004);
  lua_setfield(L, -2, "GL_TEXTURE20");

  lua_pushnumber(L, 34005);
  lua_setfield(L, -2, "GL_TEXTURE21");

  lua_pushnumber(L, 34006);
  lua_setfield(L, -2, "GL_TEXTURE22");

  lua_pushnumber(L, 34007);
  lua_setfield(L, -2, "GL_TEXTURE23");

  lua_pushnumber(L, 34008);
  lua_setfield(L, -2, "GL_TEXTURE24");

  lua_pushnumber(L, 34009);
  lua_setfield(L, -2, "GL_TEXTURE25");

  lua_pushnumber(L, 34010);
  lua_setfield(L, -2, "GL_TEXTURE26");

  lua_pushnumber(L, 34011);
  lua_setfield(L, -2, "GL_TEXTURE27");

  lua_pushnumber(L, 34012);
  lua_setfield(L, -2, "GL_TEXTURE28");

  lua_pushnumber(L, 34013);
  lua_setfield(L, -2, "GL_TEXTURE29");

  lua_pushnumber(L, 34014);
  lua_setfield(L, -2, "GL_TEXTURE30");

  lua_pushnumber(L, 34015);
  lua_setfield(L, -2, "GL_TEXTURE31");

  lua_pushnumber(L, 34016);
  lua_setfield(L, -2, "GL_ACTIVE_TEXTURE");

  lua_pushnumber(L, 34017);
  lua_setfield(L, -2, "GL_CLIENT_ACTIVE_TEXTURE");

  lua_pushnumber(L, 34018);
  lua_setfield(L, -2, "GL_MAX_TEXTURE_UNITS");

  lua_pushnumber(L, 34065);
  lua_setfield(L, -2, "GL_NORMAL_MAP");

  lua_pushnumber(L, 34066);
  lua_setfield(L, -2, "GL_REFLECTION_MAP");

  lua_pushnumber(L, 34067);
  lua_setfield(L, -2, "GL_TEXTURE_CUBE_MAP");

  lua_pushnumber(L, 34068);
  lua_setfield(L, -2, "GL_TEXTURE_BINDING_CUBE_MAP");

  lua_pushnumber(L, 34069);
  lua_setfield(L, -2, "GL_TEXTURE_CUBE_MAP_POSITIVE_X");

  lua_pushnumber(L, 34070);
  lua_setfield(L, -2, "GL_TEXTURE_CUBE_MAP_NEGATIVE_X");

  lua_pushnumber(L, 34071);
  lua_setfield(L, -2, "GL_TEXTURE_CUBE_MAP_POSITIVE_Y");

  lua_pushnumber(L, 34072);
  lua_setfield(L, -2, "GL_TEXTURE_CUBE_MAP_NEGATIVE_Y");

  lua_pushnumber(L, 34073);
  lua_setfield(L, -2, "GL_TEXTURE_CUBE_MAP_POSITIVE_Z");

  lua_pushnumber(L, 34074);
  lua_setfield(L, -2, "GL_TEXTURE_CUBE_MAP_NEGATIVE_Z");

  lua_pushnumber(L, 34075);
  lua_setfield(L, -2, "GL_PROXY_TEXTURE_CUBE_MAP");

  lua_pushnumber(L, 34076);
  lua_setfield(L, -2, "GL_MAX_CUBE_MAP_TEXTURE_SIZE");

  lua_pushnumber(L, 34025);
  lua_setfield(L, -2, "GL_COMPRESSED_ALPHA");

  lua_pushnumber(L, 34026);
  lua_setfield(L, -2, "GL_COMPRESSED_LUMINANCE");

  lua_pushnumber(L, 34027);
  lua_setfield(L, -2, "GL_COMPRESSED_LUMINANCE_ALPHA");

  lua_pushnumber(L, 34028);
  lua_setfield(L, -2, "GL_COMPRESSED_INTENSITY");

  lua_pushnumber(L, 34029);
  lua_setfield(L, -2, "GL_COMPRESSED_RGB");

  lua_pushnumber(L, 34030);
  lua_setfield(L, -2, "GL_COMPRESSED_RGBA");

  lua_pushnumber(L, 34031);
  lua_setfield(L, -2, "GL_TEXTURE_COMPRESSION_HINT");

  lua_pushnumber(L, 34464);
  lua_setfield(L, -2, "GL_TEXTURE_COMPRESSED_IMAGE_SIZE");

  lua_pushnumber(L, 34465);
  lua_setfield(L, -2, "GL_TEXTURE_COMPRESSED");

  lua_pushnumber(L, 34466);
  lua_setfield(L, -2, "GL_NUM_COMPRESSED_TEXTURE_FORMATS");

  lua_pushnumber(L, 34467);
  lua_setfield(L, -2, "GL_COMPRESSED_TEXTURE_FORMATS");

  lua_pushnumber(L, 32925);
  lua_setfield(L, -2, "GL_MULTISAMPLE");

  lua_pushnumber(L, 32926);
  lua_setfield(L, -2, "GL_SAMPLE_ALPHA_TO_COVERAGE");

  lua_pushnumber(L, 32927);
  lua_setfield(L, -2, "GL_SAMPLE_ALPHA_TO_ONE");

  lua_pushnumber(L, 32928);
  lua_setfield(L, -2, "GL_SAMPLE_COVERAGE");

  lua_pushnumber(L, 32936);
  lua_setfield(L, -2, "GL_SAMPLE_BUFFERS");

  lua_pushnumber(L, 32937);
  lua_setfield(L, -2, "GL_SAMPLES");

  lua_pushnumber(L, 32938);
  lua_setfield(L, -2, "GL_SAMPLE_COVERAGE_VALUE");

  lua_pushnumber(L, 32939);
  lua_setfield(L, -2, "GL_SAMPLE_COVERAGE_INVERT");

  lua_pushnumber(L, 536870912);
  lua_setfield(L, -2, "GL_MULTISAMPLE_BIT");

  lua_pushnumber(L, 34019);
  lua_setfield(L, -2, "GL_TRANSPOSE_MODELVIEW_MATRIX");

  lua_pushnumber(L, 34020);
  lua_setfield(L, -2, "GL_TRANSPOSE_PROJECTION_MATRIX");

  lua_pushnumber(L, 34021);
  lua_setfield(L, -2, "GL_TRANSPOSE_TEXTURE_MATRIX");

  lua_pushnumber(L, 34022);
  lua_setfield(L, -2, "GL_TRANSPOSE_COLOR_MATRIX");

  lua_pushnumber(L, 34160);
  lua_setfield(L, -2, "GL_COMBINE");

  lua_pushnumber(L, 34161);
  lua_setfield(L, -2, "GL_COMBINE_RGB");

  lua_pushnumber(L, 34162);
  lua_setfield(L, -2, "GL_COMBINE_ALPHA");

  lua_pushnumber(L, 34176);
  lua_setfield(L, -2, "GL_SOURCE0_RGB");

  lua_pushnumber(L, 34177);
  lua_setfield(L, -2, "GL_SOURCE1_RGB");

  lua_pushnumber(L, 34178);
  lua_setfield(L, -2, "GL_SOURCE2_RGB");

  lua_pushnumber(L, 34184);
  lua_setfield(L, -2, "GL_SOURCE0_ALPHA");

  lua_pushnumber(L, 34185);
  lua_setfield(L, -2, "GL_SOURCE1_ALPHA");

  lua_pushnumber(L, 34186);
  lua_setfield(L, -2, "GL_SOURCE2_ALPHA");

  lua_pushnumber(L, 34192);
  lua_setfield(L, -2, "GL_OPERAND0_RGB");

  lua_pushnumber(L, 34193);
  lua_setfield(L, -2, "GL_OPERAND1_RGB");

  lua_pushnumber(L, 34194);
  lua_setfield(L, -2, "GL_OPERAND2_RGB");

  lua_pushnumber(L, 34200);
  lua_setfield(L, -2, "GL_OPERAND0_ALPHA");

  lua_pushnumber(L, 34201);
  lua_setfield(L, -2, "GL_OPERAND1_ALPHA");

  lua_pushnumber(L, 34202);
  lua_setfield(L, -2, "GL_OPERAND2_ALPHA");

  lua_pushnumber(L, 34163);
  lua_setfield(L, -2, "GL_RGB_SCALE");

  lua_pushnumber(L, 34164);
  lua_setfield(L, -2, "GL_ADD_SIGNED");

  lua_pushnumber(L, 34165);
  lua_setfield(L, -2, "GL_INTERPOLATE");

  lua_pushnumber(L, 34023);
  lua_setfield(L, -2, "GL_SUBTRACT");

  lua_pushnumber(L, 34166);
  lua_setfield(L, -2, "GL_CONSTANT");

  lua_pushnumber(L, 34167);
  lua_setfield(L, -2, "GL_PRIMARY_COLOR");

  lua_pushnumber(L, 34168);
  lua_setfield(L, -2, "GL_PREVIOUS");

  lua_pushnumber(L, 34478);
  lua_setfield(L, -2, "GL_DOT3_RGB");

  lua_pushnumber(L, 34479);
  lua_setfield(L, -2, "GL_DOT3_RGBA");

  lua_pushnumber(L, 33069);
  lua_setfield(L, -2, "GL_CLAMP_TO_BORDER");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_ARB_multitexture");

  lua_pushnumber(L, 33984);
  lua_setfield(L, -2, "GL_TEXTURE0_ARB");

  lua_pushnumber(L, 33985);
  lua_setfield(L, -2, "GL_TEXTURE1_ARB");

  lua_pushnumber(L, 33986);
  lua_setfield(L, -2, "GL_TEXTURE2_ARB");

  lua_pushnumber(L, 33987);
  lua_setfield(L, -2, "GL_TEXTURE3_ARB");

  lua_pushnumber(L, 33988);
  lua_setfield(L, -2, "GL_TEXTURE4_ARB");

  lua_pushnumber(L, 33989);
  lua_setfield(L, -2, "GL_TEXTURE5_ARB");

  lua_pushnumber(L, 33990);
  lua_setfield(L, -2, "GL_TEXTURE6_ARB");

  lua_pushnumber(L, 33991);
  lua_setfield(L, -2, "GL_TEXTURE7_ARB");

  lua_pushnumber(L, 33992);
  lua_setfield(L, -2, "GL_TEXTURE8_ARB");

  lua_pushnumber(L, 33993);
  lua_setfield(L, -2, "GL_TEXTURE9_ARB");

  lua_pushnumber(L, 33994);
  lua_setfield(L, -2, "GL_TEXTURE10_ARB");

  lua_pushnumber(L, 33995);
  lua_setfield(L, -2, "GL_TEXTURE11_ARB");

  lua_pushnumber(L, 33996);
  lua_setfield(L, -2, "GL_TEXTURE12_ARB");

  lua_pushnumber(L, 33997);
  lua_setfield(L, -2, "GL_TEXTURE13_ARB");

  lua_pushnumber(L, 33998);
  lua_setfield(L, -2, "GL_TEXTURE14_ARB");

  lua_pushnumber(L, 33999);
  lua_setfield(L, -2, "GL_TEXTURE15_ARB");

  lua_pushnumber(L, 34000);
  lua_setfield(L, -2, "GL_TEXTURE16_ARB");

  lua_pushnumber(L, 34001);
  lua_setfield(L, -2, "GL_TEXTURE17_ARB");

  lua_pushnumber(L, 34002);
  lua_setfield(L, -2, "GL_TEXTURE18_ARB");

  lua_pushnumber(L, 34003);
  lua_setfield(L, -2, "GL_TEXTURE19_ARB");

  lua_pushnumber(L, 34004);
  lua_setfield(L, -2, "GL_TEXTURE20_ARB");

  lua_pushnumber(L, 34005);
  lua_setfield(L, -2, "GL_TEXTURE21_ARB");

  lua_pushnumber(L, 34006);
  lua_setfield(L, -2, "GL_TEXTURE22_ARB");

  lua_pushnumber(L, 34007);
  lua_setfield(L, -2, "GL_TEXTURE23_ARB");

  lua_pushnumber(L, 34008);
  lua_setfield(L, -2, "GL_TEXTURE24_ARB");

  lua_pushnumber(L, 34009);
  lua_setfield(L, -2, "GL_TEXTURE25_ARB");

  lua_pushnumber(L, 34010);
  lua_setfield(L, -2, "GL_TEXTURE26_ARB");

  lua_pushnumber(L, 34011);
  lua_setfield(L, -2, "GL_TEXTURE27_ARB");

  lua_pushnumber(L, 34012);
  lua_setfield(L, -2, "GL_TEXTURE28_ARB");

  lua_pushnumber(L, 34013);
  lua_setfield(L, -2, "GL_TEXTURE29_ARB");

  lua_pushnumber(L, 34014);
  lua_setfield(L, -2, "GL_TEXTURE30_ARB");

  lua_pushnumber(L, 34015);
  lua_setfield(L, -2, "GL_TEXTURE31_ARB");

  lua_pushnumber(L, 34016);
  lua_setfield(L, -2, "GL_ACTIVE_TEXTURE_ARB");

  lua_pushnumber(L, 34017);
  lua_setfield(L, -2, "GL_CLIENT_ACTIVE_TEXTURE_ARB");

  lua_pushnumber(L, 34018);
  lua_setfield(L, -2, "GL_MAX_TEXTURE_UNITS_ARB");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_MESA_shader_debug");

  lua_pushnumber(L, 34649);
  lua_setfield(L, -2, "GL_DEBUG_OBJECT_MESA");

  lua_pushnumber(L, 34650);
  lua_setfield(L, -2, "GL_DEBUG_PRINT_MESA");

  lua_pushnumber(L, 34651);
  lua_setfield(L, -2, "GL_DEBUG_ASSERT_MESA");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_MESA_packed_depth_stencil");

  lua_pushnumber(L, 34640);
  lua_setfield(L, -2, "GL_DEPTH_STENCIL_MESA");

  lua_pushnumber(L, 34641);
  lua_setfield(L, -2, "GL_UNSIGNED_INT_24_8_MESA");

  lua_pushnumber(L, 34642);
  lua_setfield(L, -2, "GL_UNSIGNED_INT_8_24_REV_MESA");

  lua_pushnumber(L, 34643);
  lua_setfield(L, -2, "GL_UNSIGNED_SHORT_15_1_MESA");

  lua_pushnumber(L, 34644);
  lua_setfield(L, -2, "GL_UNSIGNED_SHORT_1_15_REV_MESA");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_MESA_program_debug");

  lua_pushnumber(L, 35760);
  lua_setfield(L, -2, "GL_FRAGMENT_PROGRAM_POSITION_MESA");

  lua_pushnumber(L, 35761);
  lua_setfield(L, -2, "GL_FRAGMENT_PROGRAM_CALLBACK_MESA");

  lua_pushnumber(L, 35762);
  lua_setfield(L, -2, "GL_FRAGMENT_PROGRAM_CALLBACK_FUNC_MESA");

  lua_pushnumber(L, 35763);
  lua_setfield(L, -2, "GL_FRAGMENT_PROGRAM_CALLBACK_DATA_MESA");

  lua_pushnumber(L, 35764);
  lua_setfield(L, -2, "GL_VERTEX_PROGRAM_POSITION_MESA");

  lua_pushnumber(L, 35765);
  lua_setfield(L, -2, "GL_VERTEX_PROGRAM_CALLBACK_MESA");

  lua_pushnumber(L, 35766);
  lua_setfield(L, -2, "GL_VERTEX_PROGRAM_CALLBACK_FUNC_MESA");

  lua_pushnumber(L, 35767);
  lua_setfield(L, -2, "GL_VERTEX_PROGRAM_CALLBACK_DATA_MESA");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_MESA_texture_array");

  lua_pushnumber(L, 35864);
  lua_setfield(L, -2, "GL_TEXTURE_1D_ARRAY_EXT");

  lua_pushnumber(L, 35865);
  lua_setfield(L, -2, "GL_PROXY_TEXTURE_1D_ARRAY_EXT");

  lua_pushnumber(L, 35866);
  lua_setfield(L, -2, "GL_TEXTURE_2D_ARRAY_EXT");

  lua_pushnumber(L, 35867);
  lua_setfield(L, -2, "GL_PROXY_TEXTURE_2D_ARRAY_EXT");

  lua_pushnumber(L, 35868);
  lua_setfield(L, -2, "GL_TEXTURE_BINDING_1D_ARRAY_EXT");

  lua_pushnumber(L, 35869);
  lua_setfield(L, -2, "GL_TEXTURE_BINDING_2D_ARRAY_EXT");

  lua_pushnumber(L, 35071);
  lua_setfield(L, -2, "GL_MAX_ARRAY_TEXTURE_LAYERS_EXT");

  lua_pushnumber(L, 36052);
  lua_setfield(L, -2, "GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER_EXT");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_ATI_blend_equation_separate");

  lua_pushnumber(L, 34877);
  lua_setfield(L, -2, "GL_ALPHA_BLEND_EQUATION_ATI");

  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "GL_OES_EGL_image");

	// pop table
	lua_pop(L, 1);

}// define_constants()


-- lua_glfw_ifdef_defines.lua : table of defines for parse/filter_ifdefs.lua processing of glfw hdr file
return {
  ["#ifndef __glfw_h_"] = true,
}

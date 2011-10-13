glfw_hdr=~/swtools/opengl/glfw/include/GL/glfw.h
cat $glfw_hdr | lua ../parse/strip_c_comments.lua > glfw_hdr_no_comments.i

glfw_hdr=~/swtools/opengl/glfw/include/GL/glfw.h
cat $glfw_hdr | \
lua ../parse/strip_c_comments.lua | \
lua ../parse/join_continued_lines.lua | \
lua ../parse/filter_ifdefs.lua --defines lua_glfw_ifdef_defines.lua | \
lua ../parse/macro_sub.lua lua_glfw_macro_subs.lua | \
lua ../parse/strip_defines.lua | \
lua ../parse/strip_blank_lines.lua \
> glfw.i

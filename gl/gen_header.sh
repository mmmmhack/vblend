# gen_header.sh  : script to generate pre-processed opengl header file gl.i for input to gen_wrappers.sh script

gl_hdr=/usr/X11/include/GL/gl.h
cat $gl_hdr | \
lua ../parse/strip_c_comments.lua | \
lua ../parse/join_continued_lines.lua | \
lua ../parse/filter_ifdefs.lua --defines lua_gl_ifdef_defines.lua | \
lua ../parse/macro_sub.lua lua_gl_macro_subs.lua | \
lua ../parse/strip_defines.lua | \
lua ../parse/strip_blank_lines.lua \
> gl.i

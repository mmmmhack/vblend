gl_hdr=/usr/X11/include/GL/gl.h
cat $gl_hdr | lua ../parse/strip_c_comments.lua > gl_hdr_no_comments.i

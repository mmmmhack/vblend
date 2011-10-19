# lua_tfont_gen_header.sh  : script to generate pre-processed header file lua_tfont.i for input to lua_tfont_gen_wrappers.sh script

#lua ../parse/macro_sub.lua lua_tfont_macro_subs.lua 

hdr_file=sys.h
cat $hdr_file | \
lua ../parse/strip_cpp_comments.lua | \
lua ../parse/join_continued_lines.lua | \
lua ../parse/filter_ifdefs.lua --defines lua_sys_ifdef_defines.lua | \
lua ../parse/strip_defines.lua | \
lua ../parse/strip_includes.lua | \
lua ../parse/strip_blank_lines.lua \
> sys.i

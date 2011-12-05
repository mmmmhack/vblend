# lua_edit_gen_header.sh  : script to generate pre-processed header file lua_edit.i for input to lua_edit_gen_wrappers.sh script

#lua ../parse/macro_sub.lua lua_edit_macro_subs.lua 

hdr_file=edit.h
cat $hdr_file | \
lua ../parse/strip_cpp_comments.lua | \
lua ../parse/join_continued_lines.lua | \
lua ../parse/filter_ifdefs.lua --defines lua_edit_ifdef_defines.lua | \
lua ../parse/strip_defines.lua | \
lua ../parse/strip_blank_lines.lua \
> edit.i

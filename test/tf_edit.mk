include common.mk

tf_edit: tf_edit.app/Contents/MacOS/tf_edit
	-ln -s $< $@

tf_edit.app/Contents/MacOS/tf_edit: $(font_lib) $(edit_lib) $(util_lib) lua_util.o tf8036_common.o tf_edit.o
	/bin/sh bundle.sh tf_edit
	$(CC) $(CFLAGS) -o $@ tf8036_common.o lua_util.o tf_edit.o $(font_lib) $(edit_lib) $(util_lib) -L$(libpng_dir)/lib -lpng $(lua_libs) $(os_libs)



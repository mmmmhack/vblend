include common.mk

lua_dir = $(HOME)/swtools/lua

includes += -I$(lua_dir)/include 

lua_libs = -L$(lua_dir)/lib -llua

tf_edit: tf_edit.app/Contents/MacOS/tf_edit
	-ln -s $< $@

tf_edit.app/Contents/MacOS/tf_edit: $(font_lib) $(edit_lib) $(util_lib) tf8036_common.o tf_edit.o
	/bin/sh bundle.sh tf_edit
	$(CC) $(CFLAGS) -o $@ tf8036_common.o tf_edit.o $(font_lib) $(edit_lib) $(util_lib) -L$(libpng_dir)/lib -lpng $(lua_libs) $(os_libs)



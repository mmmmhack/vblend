include common.mk

tf8036_xt: tf8036_xt.app/Contents/MacOS/tf8036_xt
	-ln -s $< $@

tf8036_xt.app/Contents/MacOS/tf8036_xt: tf8036_common.o tf8036_xt.o
	/bin/sh bundle.sh tf8036_xt
	$(CC) $(CFLAGS) -o $@ tf8036_common.o tf8036_xt.o $(font_lib) $(util_lib) -L$(libpng_dir)/lib -lpng $(os_libs)



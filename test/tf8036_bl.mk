include common.mk

tf8036_bl: tf8036_bl.app/Contents/MacOS/tf8036_bl
	-ln -s $< $@

tf8036_bl.app/Contents/MacOS/tf8036_bl: tf8036_common.o tf8036_bl.o 
	/bin/sh bundle.sh tf8036_bl
	$(CC) $(CFLAGS) -o $@ tf8036_common.o tf8036_bl.o $(font_lib) $(util_lib) -L$(libpng_dir)/lib -lpng $(os_libs)



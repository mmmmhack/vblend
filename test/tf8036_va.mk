include common.mk

tf8036_va: tf8036_va.app/Contents/MacOS/tf8036_va
	-ln -s $< $@

#objs = tf8036_common.o tf8036_va.o

tf8036_va.app/Contents/MacOS/tf8036_va: tf8036_va.o tf8036_common.o 
	/bin/sh bundle.sh tf8036_va
	$(CC) $(CFLAGS) -o $@ tf8036_common.o tf8036_va.o $(font_lib) $(util_lib) -L$(libpng_dir)/lib -lpng $(os_libs)



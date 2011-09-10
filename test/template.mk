include common.mk

template: template.app/Contents/MacOS/template
	-ln -s $< $@

template.app/Contents/MacOS/template: tf8036_common.o template.o
	/bin/sh bundle.sh template
	$(CC) $(CFLAGS) -o $@ tf8036_common.o template.o $(font_lib) $(util_lib) -L$(libpng_dir)/lib -lpng $(os_libs)



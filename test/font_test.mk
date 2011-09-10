include common.mk

font_test: font_test.app/Contents/MacOS/font_test
	-ln -s $< $@

font_test.app/Contents/MacOS/font_test: font_test.o
	/bin/sh bundle.sh font_test
	$(CC) $(CFLAGS) -o $@ $< $(font_lib) $(util_lib) $(os_libs)



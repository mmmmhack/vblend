include common.mk

fps_test: fps_test.app/Contents/MacOS/fps_test
	ln -s $< $@

fps_test.app/Contents/MacOS/fps_test: fps_test.o
	/bin/sh bundle.sh fps_test
	$(CC) $(CFLAGS) -o $@ $< $(font_lib) $(util_lib) $(os_libs)



include common.mk

font_perf: font_perf.app/Contents/MacOS/font_perf
	-ln -s $< $@

font_perf.app/Contents/MacOS/font_perf: font_perf.o
	/bin/sh bundle.sh font_perf
	$(CC) $(CFLAGS) -o $@ $< $(font_lib) $(util_lib) $(os_libs)



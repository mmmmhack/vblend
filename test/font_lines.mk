include common.mk

font_lines: font_lines.app/Contents/MacOS/font_lines
	-ln -s $< $@

font_lines.app/Contents/MacOS/font_lines: font_lines.o
	/bin/sh bundle.sh font_lines
	$(CC) $(CFLAGS) -o $@ $< $(font_lib) $(util_lib) $(os_libs)



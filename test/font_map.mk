include common.mk

font_map: font_map.app/Contents/MacOS/font_map
	-ln -s $< $@

font_map.app/Contents/MacOS/font_map: font_map.o
	/bin/sh bundle.sh font_map
	$(CC) $(CFLAGS) -o $@ $< $(font_lib) $(util_lib) $(os_libs)


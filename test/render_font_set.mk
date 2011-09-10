include common.mk

render_font_set: render_font_set.app/Contents/MacOS/render_font_set
	-ln -s $< $@

render_font_set.app/Contents/MacOS/render_font_set: render_font_set.o
	/bin/sh bundle.sh render_font_set
	$(CC) $(CFLAGS) -o $@ $< $(font_lib) $(util_lib) $(os_libs)



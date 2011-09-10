include common.mk

includes += -I$(libpng_dir)/include

draw_tex_font: draw_tex_font.app/Contents/MacOS/draw_tex_font
	-ln -s $< $@

draw_tex_font.app/Contents/MacOS/draw_tex_font: draw_tex_font.o
	/bin/sh bundle.sh draw_tex_font
	$(CC) $(CFLAGS) -o $@ $< $(font_lib) $(util_lib) -L$(libpng_dir)/lib -lpng $(os_libs)



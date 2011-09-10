include common.mk

includes += -I$(libpng_dir)/include

write_9x15_font_png: write_9x15_font_png.app/Contents/MacOS/write_9x15_font_png
	-ln -s $< $@

write_9x15_font_png.app/Contents/MacOS/write_9x15_font_png: write_9x15_font_png.o
	/bin/sh bundle.sh write_9x15_font_png
	$(CC) $(CFLAGS) -o $@ $< $(font_lib) $(util_lib) -L$(libpng_dir)/lib -lpng $(os_libs)


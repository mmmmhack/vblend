include common.mk

bitmap_letter: bitmap_letter.app/Contents/MacOS/bitmap_letter
	-ln -s $< $@

bitmap_letter.app/Contents/MacOS/bitmap_letter: bitmap_letter.o
	/bin/sh bundle.sh bitmap_letter
	$(CC) $(CFLAGS) -o $@ $< $(font_lib) $(util_lib) $(os_libs)



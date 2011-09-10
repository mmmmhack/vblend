include common.mk

howdy: howdy.app/Contents/MacOS/howdy
	ln -s $< $@

howdy.app/Contents/MacOS/howdy: howdy.o
	/bin/sh bundle.sh howdy
	$(CC) $(CFLAGS) -o $@ howdy.o $(os_libs)



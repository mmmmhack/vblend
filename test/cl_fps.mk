include common.mk

cl_fps: cl_fps.app/Contents/MacOS/cl_fps
	-ln -s $< $@

cl_fps.app/Contents/MacOS/cl_fps: cl_fps.o
	/bin/sh bundle.sh cl_fps
	$(CC) $(CFLAGS) -o $@ $< $(font_lib) $(util_lib) $(os_libs)



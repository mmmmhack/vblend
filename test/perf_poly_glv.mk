include common.mk

perf_poly_glv: perf_poly_glv.app/Contents/MacOS/perf_poly_glv
	-ln -s $< $@

perf_poly_glv.app/Contents/MacOS/perf_poly_glv: perf_poly_glv.o
	/bin/sh bundle.sh perf_poly_glv
	$(CC) $(CFLAGS) -o $@ $< $(font_lib) $(util_lib) $(os_libs)



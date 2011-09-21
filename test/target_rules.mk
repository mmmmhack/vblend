howdy:
	make -f howdy.mk

font_test:
	make -f font_test.mk

fps_test:
	make -f fps_test.mk

font_lines:
	make -f font_lines.mk

font_map:
	make -f font_map.mk

bitmap_letter:
	make -f bitmap_letter.mk

cl_fps:
	make -f cl_fps.mk

font_perf:
	make -f font_perf.mk

perf_poly_glv:
	make -f perf_poly_glv.mk

render_font_set:
	make -f render_font_set.mk

write_9x15_font_png:
	make -f write_9x15_font_png.mk

draw_tex_font:
	make -f draw_tex_font.mk

tf8036_bl:
	make -f tf8036_bl.mk

tf8036_va:
	make -f tf8036_va.mk

tf8036_xt:
	make -f tf8036_xt.mk

tf_edit:
	make -f tf_edit.mk

lua_sinterp:
	make -f lua_sinterp.mk

test_lua_pcall:
	make -f test_lua_pcall.mk

include tlua_reg.mk

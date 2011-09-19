lua_dir = $(HOME)/swtools/lua
glfw_dir = $(HOME)/swtools/opengl/glfw
libpng_dir = $(HOME)/swtools/graphics/libpng

CC = gcc
CFLAGS += -g -Wall

includes = \
 -I.. \
 -I$(glfw_dir)/include \
 -I$(lua_dir)/include

font_lib = ../font/libfont.a
edit_lib = ../edit/libedit.a
util_lib = ../util/libutil.a

lua_libs = -L$(lua_dir)/lib -llua

os_libs = \
 $(glfw_dir)/lib/libglfw.a -framework Cocoa -framework OpenGL

%.o: %.c
	$(CC) $(CFLAGS) $(includes) -MM -MT '$@' -MF $(basename $@).d $<
	$(CC) $(CFLAGS) -o $@ $(includes) -c $<

-include $(objs:.o=.d)



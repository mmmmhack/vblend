glfw_dir = $(HOME)/swtools/opengl/glfw
libpng_dir = $(HOME)/swtools/graphics/libpng

includes = -I$(glfw_dir)/include 
includes += -I$(libpng_dir)/include

CC = gcc
CFLAGS += -g -Wall
OS = $(shell uname -s)

objs = \
 StrIntMap.o \
 strmap.o \
 str.o \
 sys.o \
 fps.o \
 img.o \
 perf.o \
 win.o

all: libutil.a

libutil.a: $(objs)
	ar rv $@ $(objs)
	ranlib $@

%.o: %.c
	$(CC) $(CFLAGS) $(includes) -MM -MT '$@' -MF $(basename $@).d $<
	$(CC) -o $@ $(CFLAGS) $(includes) -c $<

-include $(objs:.o=.d)

clean:
	-rm *.a *.o

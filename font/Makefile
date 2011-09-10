glfw_dir = $(HOME)/swtools/opengl/glfw

includes = \
 -I$(glfw_dir)/include \
 -I.. \

CC = gcc
CFLAGS += -g -Wall
OS = $(shell uname -s)

objs = \
 font.o \
 font-9x15.o \
 tfont.o 

all: libfont.a

libfont.a: $(objs)
	ar rv $@ $(objs)
	ranlib $@

%.o: %.c
	$(CC) $(CFLAGS) $(includes) -MM -MT '$@' -MF $(basename $@).d $<
	$(CC) -o $@ $(CFLAGS) $(includes) -c $<

-include $(objs:.o=.d)

clean:
	-rm *.a *.o

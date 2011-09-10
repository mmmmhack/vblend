CC = gcc
CFLAGS += -Wall -g

lua_dir = $(HOME)/swtools/lua

includes = -I$(lua_dir)/include 

libs = -L$(lua_dir)/lib -llua

all: lua_sinterp

lua_sinterp: lua_sinterp.o
	$(CC) $(CFLAGS) -o $@ $(libs) $<

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $(includes) $<

clean:
	-rm *.o lua_sinterp

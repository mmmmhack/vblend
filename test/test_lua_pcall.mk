CC = gcc
CFLAGS = -g -O0 -Wall

lua_dir = $(HOME)/swtools/lua

includes += -I$(lua_dir)/include 

lua_libs = -L$(lua_dir)/lib -llua

test_lua_pcall: lua_util.o test_lua_pcall.o
	$(CC) $(CFLAGS) -o $@ test_lua_pcall.o lua_util.o $(lua_libs)

%.o: %.c
	$(CC) $(CFLAGS) -o $@ $(includes) -c $<

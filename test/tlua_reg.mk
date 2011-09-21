include common.mk

LD = ld

tlua_reg: lua_util.o tlr.so tlua_reg.o
	$(CC) $(CFLAGS) -o $@ tlua_reg.o lua_util.o $(lua_libs)

#tlr.so: tlr.o
#	$(CC) -dynamiclib -o tlr.so $< $(lua_libs)

tlr.so: tlr.o
	$(CC) -bundle -undefined dynamic_lookup -o tlr.so $< 

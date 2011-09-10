OS = $(shell uname -s)

ifeq ($(OS),Darwin)
$(info "building for mac os $(OS)")
include Makefile.osx
else
$(info "building for linux os $(OS)")
include Makefile.linux  
endif


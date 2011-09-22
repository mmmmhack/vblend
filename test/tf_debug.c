// debug.c	:	simple lua debugger
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "lua.h" 
#include "lauxlib.h" 
#include "lualib.h" 

#include "tf_debug.h"

static char _break_src[FILENAME_MAX] = "";
static int _break_line = 0;

static void print_prompt() {
	printf("> ");
}

static void chomp(char* ln) {
	int n = strlen(ln);
	if(n)
		ln[n-1] = '\0';
}

static void print_help() {
	printf("--- commands:\n");
	printf("  b FILE:LINE   :    set breakpoint\n");
	printf("  c             :    continue program execution\n");
	printf("  q             :    quit program\n");
	printf("  h             :    show this help\n");
	printf("\n");
}

static void set_breakpoint(lua_State* L, const char* args) {
	// skip leading whitespace
	const char* p = args;
	while(*p && isspace(*p))
		++p;
	if(!*p){
		fprintf(stderr, "Error: missing breakpoint arg\n");
		return;
	}
	const char* sep = strchr(p, ':');
	if(!sep) {
		fprintf(stderr, "Error: invalid breakpoint arg\n");
		return;
	}
	strncpy(_break_src, p, sep-p);
	_break_src[sep-p] = '\0';
	p += sep - p;
	p++;
	if(!*p) {
		fprintf(stderr, "Error: invalid breakpoint arg\n");
		return;
	}	
	_break_line = atoi(p);
	if(!_break_line) {
		fprintf(stderr, "Error: invalid breakpoint arg\n");
		return;
	}
	printf("breaking at %s:%d\n", _break_src, _break_line);
	lua_getglobal(L, "set_breakpoint");
	lua_pushstring(L, _break_src);
	lua_pushnumber(L, _break_line);
	lua_pcall(L, 2, 0, 0);
	printf("breakpoint set\n");
}

void debug_enter(lua_State* L) {
	int get_input = 1;
	while(get_input) {
		print_prompt();

		// get input
		char ln[256] = "";
		fgets(ln, sizeof(ln), stdin);
		chomp(ln);

//		printf("you entered: [%s]\n", ln);
		int n = strlen(ln);
		if(n== 0)
			continue;
		char c = ln[0];
		switch(c) {
		case 'c':
			get_input = 0;
			break;
		case 'b':
		  set_breakpoint(L, ln+1);	
			break;
		case 'h':
			print_help();
			break;
		case 'q':
			exit(0);
		default:
			printf("unknown command '%c'\n", c);
			break;
		}
	}
	printf("continuing program execution\n");
}



#include <string.h>

#include "str.h"

int sstrncpy(char* dst, const char* src, size_t dst_size) {
	strncpy(dst, src, dst_size - 1);
	dst[dst_size-1] = '\0';
	return 0;
}

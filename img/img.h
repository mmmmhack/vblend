#ifndef util_img_h
#define util_img_h

#include <stdio.h>	// for size_t

typedef struct _RgbaImage {
	size_t width;
	size_t height;
	size_t bytes_per_pixel;
	unsigned char* pixels;
} RgbaImage;

RgbaImage* img_read_png_rgba(const char* image_filename);

#endif

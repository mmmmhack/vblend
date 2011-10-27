// img.c	: image utility functions

#include <stdlib.h>
#include <stdio.h>

#include "png.h"

#include "img.h"

typedef struct {
	jmp_buf jump_buf;
} AppInfo;

static void error_handler(png_structp png_ptr, png_const_charp msg) {
}

RgbaImage* img_read_png_rgba(const char* png_file) {
  png_uint_32 row;
  int rc;
	png_byte header[8] = {0};
	FILE* fin;
	AppInfo app_info;
	png_structp png_ptr;
	png_infop info_ptr;
	png_bytep* row_pointers;
	png_uint_32 width;
	png_uint_32 height;
	png_byte bit_depth;
	png_uint_32 color_type;
	RgbaImage* img;
	size_t k;

	char err_msg[1024];
	int cb_err_msg = sizeof(err_msg);
  err_msg[cb_err_msg-1] = '\0';

	fin = fopen(png_file, "rb");
	if(!fin) {
		snprintf(err_msg, cb_err_msg, "failed opening file: %s\n", png_file);
fprintf(stderr, err_msg);
getcwd(err_msg, sizeof(err_msg));
fprintf(stderr, "cwd: %s\n", err_msg);
		return NULL;
	}
	fread(header, 1, sizeof(header), fin);
	rc = png_sig_cmp(header, 0, sizeof(header));
	if(rc) {
		snprintf(err_msg, cb_err_msg, "not a png file: %s\n", png_file);
fprintf(stderr, err_msg);
		return NULL;
	}

	// create png struct
	memset(&app_info, 0, sizeof(app_info));
	png_ptr =  png_create_read_struct(
		PNG_LIBPNG_VER_STRING,
		(png_voidp) &app_info,
		error_handler,
		0);
	if(!png_ptr) {
		fclose(fin);
		snprintf(err_msg, cb_err_msg, "failed creating png struct\n");
fprintf(stderr, err_msg);
		return NULL;
	}

	// create info struct
	info_ptr =  png_create_info_struct(png_ptr);
	if(!info_ptr) {
		fclose(fin);
		png_destroy_read_struct(&png_ptr, 0, 0);
		snprintf(err_msg, cb_err_msg, "failed creating png struct\n");
fprintf(stderr, err_msg);
		return NULL;
	}

	// set error handler
	if(setjmp(png_jmpbuf(png_ptr))) {
		fclose(fin);
		png_destroy_read_struct(&png_ptr, &info_ptr, 0);
		snprintf(err_msg, cb_err_msg, "error reading png, error detail: ?\n");
fprintf(stderr, err_msg);
		return NULL;
	}

	// setup i/o
	png_init_io(png_ptr, fin);
	png_set_sig_bytes(png_ptr, sizeof(header));

	// read it
	png_read_png(png_ptr, info_ptr, PNG_TRANSFORM_IDENTITY, 0);

	// close input file
	fclose(fin);

	// get rows
	row_pointers = png_get_rows(png_ptr, info_ptr);

	// get image props
	width = png_get_image_width(png_ptr, info_ptr);
	height = png_get_image_height(png_ptr, info_ptr);
	bit_depth = png_get_bit_depth(png_ptr, info_ptr);
	color_type = png_get_color_type(png_ptr, info_ptr);

	// check format
	if(color_type != PNG_COLOR_TYPE_RGBA || bit_depth != 8) {
    char c_bit_depth[32];
		png_destroy_read_struct(&png_ptr, &info_ptr, 0);
    sprintf(c_bit_depth, "%02x",(char) bit_depth);
		snprintf(err_msg, cb_err_msg, "unsupported color_type (%zu) or bit_depth (%s)\n", color_type, c_bit_depth);
fprintf(stderr, err_msg);
		return NULL;
	}

	// create img
	img = (RgbaImage*) malloc(sizeof(RgbaImage));
	img->width = width;
	img->height = height;
	img->bytes_per_pixel = 4;
	img->pixels = (unsigned char*) malloc(width*height*4);

  // store pixels in reverse-row order (bottom row is top of image)
	k = 0;
	for(row = height - 1; row > 0; --row) {
		png_bytep row_data = row_pointers[row];
    png_uint_32 col;
		for(col = 0; col < width; ++col) {
			png_byte r = row_data[col*4];
			png_byte g = row_data[col*4 + 1];
			png_byte b = row_data[col*4 + 2];
			png_byte a = row_data[col*4 + 3];
			img->pixels[k++] = r;
			img->pixels[k++] = g;
			img->pixels[k++] = b;
			img->pixels[k++] = a;
    }
  }
	// cleanup
	png_destroy_read_struct(&png_ptr, &info_ptr, 0);

	return img;
}



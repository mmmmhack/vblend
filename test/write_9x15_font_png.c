// write_test_image.c	:	writes a test image using libpng functions

#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "png.h"

#include "font/font.h"

const char* TEST_FILE = "9x15_font.png";
const int IMG_W = 256;
const int IMG_H = 256;

static void sys_err(const char* msg) {
	fprintf(stderr, "%s: %s\n", msg, strerror(errno));
	exit(1);
}
/*
png_error_ptr user_error_fn() {
}

png_error_ptr user_warn_fn() {
}
*/

int main(int argc, char* argv[]) {

  // alloc image array
	unsigned char* img_data = NULL;
	// rgba, 8 bpp
	size_t cb_img_data = IMG_W * IMG_H * 4;
	img_data = (unsigned char*) malloc(cb_img_data);
	if(img_data == NULL)
		sys_err("failed alloc img_data buffer");

  size_t num_img_data_col_bytes = 16 * 4;
  size_t num_img_data_row_bytes = 16 * 16 * 4;

  // define image data from font set
  size_t num_chars = 256;
  size_t nch;
  size_t i = 0;
	for(nch = 0; nch < num_chars; ++nch) {
    const GLubyte* char_bytes = font9x15_char_bitmap(nch);
    size_t ch_row = nch / 16;
    size_t ch_col = nch % 16;
    // get the offset to the first png byte in img_data array for nch character
    size_t img_data_offset = (ch_row * num_img_data_row_bytes * 16) + (ch_col * num_img_data_col_bytes);
    int bit_row, bit_col, bit;
    for(bit_row = 0; bit_row < 16; ++bit_row) {
      // calc offset for bit row
      // adjust the output offsets so rows are output from bottom to top
      i = img_data_offset + (15 - bit_row) * num_img_data_row_bytes;

      // also have to flip from left-to-right for some reason
      for(bit_col = 0; bit_col< 2; ++bit_col) {
        GLubyte ch = char_bytes[bit_row * 2 + bit_col];
        unsigned char mask = 0x80;
        for(bit = 7; bit >= 0; --bit) {
          unsigned char bit_val = ch & mask;
          mask >>= 1;
          GLubyte c = bit_val ? 0xff : 0x00;
          GLubyte a = c ? 0xff : 0x00;
          // overrun check
          if(i > cb_img_data - 4) {
            printf("ch %02lu: i: %04lu, bit_row: %02d bit_col: %02d bit: %d bit_val: %d\n", nch, i, bit_row, bit_col, bit, bit_val);
            sys_err("overrun!!!");
          }
          img_data[i++] = c;
          img_data[i++] = c;
          img_data[i++] = c;
          img_data[i++] = a;
        }
      }
    }
  }
  if(i > cb_img_data) {
    printf("cb_img_data: %lu, i: %lu\n", cb_img_data, i);
    sys_err("urk!");
  }

	// open output file
	FILE* fp = fopen(TEST_FILE, "wb");
	if(!fp) 
		sys_err("failed opening output file");

	// init png lib
	png_voidp user_error_ptr = NULL;
	png_error_ptr user_error_fn = NULL;
	png_error_ptr user_warning_fn = NULL;
	png_structp png_ptr = png_create_write_struct(
		PNG_LIBPNG_VER_STRING,
		user_error_ptr,
		user_error_fn, 
		user_warning_fn
	);
	if(!png_ptr)
		sys_err("png_create_write_struct returned NULL");
	png_infop info_ptr = png_create_info_struct(png_ptr);
	if(!info_ptr) {
		png_destroy_write_struct(&png_ptr, NULL);
		sys_err("png_create_info_struct returned NULL");
	}
	// ALERT!! this doesn't work here
//	png_init_io(png_ptr, fp);

	png_init_io(png_ptr, fp);

	// set info
	png_uint_32 w = IMG_W;
	png_uint_32 h = IMG_H;
	int bit_depth = 8;
	int color_type = PNG_COLOR_TYPE_RGB_ALPHA;
	int interlace_type = PNG_INTERLACE_NONE;
	int comp_type = PNG_COMPRESSION_TYPE_DEFAULT;
	int filter = PNG_FILTER_TYPE_DEFAULT;
	png_set_IHDR(png_ptr, info_ptr, w, h, bit_depth, color_type, interlace_type, comp_type, filter);

	// write image (use low-level interface)
	// hdr
	png_write_info(png_ptr, info_ptr);
	// data
	size_t num_rows = IMG_H;
  size_t row;
	for(row = 0; row < num_rows; ++row) {
	  size_t offset = row * IMG_W * 4; // row offset = row width in pixels * 4 bytes per pixel
		png_bytep rowp = img_data + offset;
		png_write_row(png_ptr, rowp);
	}

	// finish
	png_write_end(png_ptr, info_ptr);

	// cleanup
	fclose(fp);
	png_destroy_write_struct(&png_ptr, &info_ptr);

	free(img_data);
	return 0;
}

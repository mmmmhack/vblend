#ifndef __tfont_h_
#define __tfont_h_

// initializes font drawing for this module
int tfont_init(); 

// does immediate-mode drawing of param text to the display
void tfont_draw_string(const char* s);

// free resources used by this module
void tfont_cleanup(); 

// returns texture coordinate indicies 
void tfont_get_tex_idx(int ichar, float* tex_ret);

// returns number of rows in font screen buffer
int tfont_num_rows();

// returns number of columns in font screen buffer
int tfont_num_cols();

// returns width in pixels of a font char
int tfont_char_width();

// returns height in pixels of a font char
int tfont_char_height();

// sets the content of font text buffer at param row and column to param string
void tfont_set_text_buf(int row, int col, const char* s);

// draws the font text buffer to the display
void tfont_draw_text_buf();

#endif

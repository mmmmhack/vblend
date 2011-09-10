#ifndef tfont_h
#define tfont_h

int tfont_init(); 
void tfont_draw_string(const char* s);
void tfont_cleanup(); 
void tfont_get_tex_idx(int ichar, float* tex_ret);

int tfont_num_rows();
int tfont_num_cols();
int tfont_char_width();
int tfont_char_height();
void tfont_set_text_buf(int row, int col, const char* s);
void tfont_draw_text_buf();

#endif

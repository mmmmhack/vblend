#ifndef _vblend_edit_h
#define _vblend_edit_h

void edit_set_cursor(int row, int col);
void edit_get_cursor(int* row_ret, int* col_ret);
void edit_draw_cursor();

#endif

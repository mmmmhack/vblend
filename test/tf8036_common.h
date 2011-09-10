#ifndef tf8036_common_h
#define tf8036_common_h

void init(const char* title);
void set_projection();
void report_fps();
const char* test_line(int line_num);
void error_check();
void exit_check(int* run_ret);

#endif

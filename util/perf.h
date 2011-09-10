#ifndef perf_h
#define perf_h

int perf_init();
int perf_mark_beg(const char* mark_name);
int perf_mark_end(const char* mark_name);
int perf_report();
int perf_terminate();
#endif

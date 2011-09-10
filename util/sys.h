#ifndef sys_h
#define sys_h
#include <time.h>

void sys_err(const char* msg);
void sys_errno(int errn, const char* msg);

// returns a time in seconds, relative to first call, with time resolution in microseconds
float sys_float_time(void);
double sys_double_time(void);

struct timeval sys_timeval_now();
int sys_timeval_greater(const struct timeval* x, const struct timeval* y);
struct timeval sys_timeval_add(const struct timeval* x, const struct timeval* y);
struct timeval sys_timeval_sub(const struct timeval* x, const struct timeval* y);
struct timeval sys_timeval_min(const struct timeval* x, const struct timeval* y);
struct timeval sys_timeval_max(const struct timeval* x, const struct timeval* y);

struct timespec sys_timespec_now();
int sys_timespec_greater(const struct timespec* x, const struct timespec* y);
struct timespec sys_timespec_add(const struct timespec* x, const struct timespec* y);
struct timespec sys_timespec_sub(const struct timespec* x, const struct timespec* y);
struct timespec sys_timespec_min(const struct timespec* x, const struct timespec* y);
struct timespec sys_timespec_max(const struct timespec* x, const struct timespec* y);

#endif

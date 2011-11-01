// sys.c : system routines

#ifdef __MACH__ // for sys_timeval_nano()
#include <mach/clock.h>
#include <mach/mach_host.h>
#include <mach/mach_port.h>
#endif

#include <sys/time.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "sys.h"

int sys_chdir(const char* path) {
  int rc = chdir(path);  
  return rc;
}

void sys_err(const char* msg) {
  perror(msg);
  exit(1);
}

void sys_errno(int errn, const char* msg) {
  errno = errn;
  perror(msg);
  exit(1);
}

double sys_double_time() {
  struct timeval tp;
  struct timezone tzp;
  static int secbase = 0;
  gettimeofday(&tp, &tzp);

  if (!secbase) {
    secbase = tp.tv_sec;
    return tp.tv_usec/1000000.0;
  }
  return (tp.tv_sec - secbase) + tp.tv_usec/1000000.0;
}

float sys_float_time() {
	return (float) sys_double_time();
}

const char* sys_getcwd() {
  static char buf[1024];
  const char* ret = getcwd(buf, sizeof(buf));
  if(ret == NULL)
    return NULL;
  return buf;
}

struct timeval sys_timeval_now() {
  struct timeval t = {0, 0};
  gettimeofday(&t, NULL);
  return t;
}

// returns 1 if x > y, else 0
int sys_timeval_greater(const struct timeval* x, const struct timeval* y) {
  if(x->tv_sec > y->tv_sec)
    return 1;
  else if(y->tv_sec > x->tv_sec)
    return 0;
  return x->tv_usec > y->tv_usec;
}

// returns sum = x + y
struct timeval sys_timeval_add(const struct timeval* x, const struct timeval* y) {
  struct timeval result;
  result.tv_sec = x->tv_sec + y->tv_sec;
  result.tv_usec = x->tv_usec + y->tv_usec;
  if(result.tv_usec > 1e6) {
    result.tv_sec++;
    result.tv_usec -= 1e6;
  }
  return result;
}

// returns diff = x - y
struct timeval sys_timeval_sub(const struct timeval* xp, const struct timeval* yp) {
  struct timeval xl, yl;
  memcpy(&xl, xp, sizeof(xl));
  memcpy(&yl, yp, sizeof(yl));
  struct timeval* x = &xl;
  struct timeval* y = &yl;

  // subtract lesser from greater
  int neg_result = 0;
  if(sys_timeval_greater(y, x)) {
    neg_result = 1;
    x = &yl;
    y = &xl;
  }
  struct timeval result;
  // subtract usec, borrow if needed
  if(x->tv_usec < y->tv_usec) {
    x->tv_sec -= 1;
    x->tv_usec += 1e6;
  }
  result.tv_usec = x->tv_usec - y->tv_usec;
  result.tv_sec = x->tv_sec - y->tv_sec;
  if(neg_result) {
    result.tv_sec = -result.tv_sec;
    result.tv_usec = -result.tv_usec;
  }
  return result;
}

// returns min(x, y)
struct timeval sys_timeval_min(const struct timeval* x, const struct timeval* y) {
  if(x->tv_sec < y->tv_sec)
    return *x;
  else if(y->tv_sec < x->tv_sec)
    return *y;
  else if(x->tv_usec < y->tv_usec)
    return *x;
  else
    return *y;
}

// returns max(x, y)
struct timeval sys_timeval_max(const struct timeval* x, const struct timeval* y) {
  if(x->tv_sec > y->tv_sec)
    return *x;
  else if(y->tv_sec > x->tv_sec)
    return *y;
  else if(x->tv_usec > y->tv_usec)
    return *x;
  else
    return *y;
}

#ifdef HAVE_TIMESPEC
// ---- timespec functions
struct timespec sys_timespec_now() {
  struct timespec ts;
#ifdef __MACH__ // OS X does not have clock_gettime, use clock_get_time
  clock_serv_t cclock;
  mach_timespec_t mts;
  host_get_clock_service(mach_host_self(), CALENDAR_CLOCK, &cclock);
  clock_get_time(cclock, &mts);
  mach_port_deallocate(mach_task_self(), cclock);
  ts.tv_sec = mts.tv_sec;
  ts.tv_nsec = mts.tv_nsec;
#else
  clock_gettime(CLOCK_REALTIME, &ts);
#endif
  return ts;
}

// returns 1 if x > y, else 0
int sys_timespec_greater(const struct timespec* x, const struct timespec* y) {
  if(x->tv_sec > y->tv_sec)
    return 1;
  else if(y->tv_sec > x->tv_sec)
    return 0;
  return x->tv_nsec > y->tv_nsec;
}

// returns sum = x + y
struct timespec sys_timespec_add(const struct timespec* x, const struct timespec* y) {
  struct timespec result;
  result.tv_sec = x->tv_sec + y->tv_sec;
  result.tv_nsec = x->tv_nsec + y->tv_nsec;
  if(result.tv_nsec > 1000000000LL) {
    result.tv_sec++;
    result.tv_nsec -= 1000000000LL;
  }
  return result;
}

// returns diff = x - y
struct timespec sys_timespec_sub(const struct timespec* xp, const struct timespec* yp) {
  struct timespec xl, yl;
  memcpy(&xl, xp, sizeof(xl));
  memcpy(&yl, yp, sizeof(yl));
  struct timespec* x = &xl;
  struct timespec* y = &yl;

  // subtract lesser from greater
  int neg_result = 0;
  if(sys_timespec_greater(y, x)) {
    neg_result = 1;
    x = &yl;
    y = &xl;
  }
  struct timespec result;
  // subtract usec, borrow if needed
  if(x->tv_nsec < y->tv_nsec) {
    x->tv_sec -= 1;
    x->tv_nsec += 1000000000LL;
  }
  result.tv_nsec = x->tv_nsec - y->tv_nsec;
  result.tv_sec = x->tv_sec - y->tv_sec;
  if(neg_result) {
    result.tv_sec = -result.tv_sec;
    result.tv_nsec = -result.tv_nsec;
  }
  return result;
}

// returns min(x, y)
struct timespec sys_timespec_min(const struct timespec* x, const struct timespec* y) {
  if(x->tv_sec < y->tv_sec)
    return *x;
  else if(y->tv_sec < x->tv_sec)
    return *y;
  else if(x->tv_nsec < y->tv_nsec)
    return *x;
  else
    return *y;
}

// returns max(x, y)
struct timespec sys_timespec_max(const struct timespec* x, const struct timespec* y) {
  if(x->tv_sec > y->tv_sec)
    return *x;
  else if(y->tv_sec > x->tv_sec)
    return *y;
  else if(x->tv_nsec > y->tv_nsec)
    return *x;
  else
    return *y;
}
#endif // HAVE_TIMESPEC

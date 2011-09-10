#include <math.h>
#include <stdio.h>

#include "StrIntMap.h"
#include "str.h"
#include "sys.h"
#include "perf.h"

typedef struct PerfRec PerfRec;

static float _report_interval_time = 1.0f; // every second
static float _prev_report_time = -1.0f;
static const size_t INIT_MAX_RECORDS = 1000;
static size_t _max_records = 0;
static size_t _num_records = 0;
static struct PerfRec* _records = NULL;
static struct StrIntMap* _mark_name_index_map = NULL;

struct PerfRec {
  char mark_name[256];
  size_t num_intervals;
  struct timespec beg_time;
  struct timespec total_time;
  struct timespec min_time;
  struct timespec max_time;
};

int perf_init() {
  // allocate mark name_id map
  if(_mark_name_index_map != NULL)
    sim_delete(_mark_name_index_map);
  _mark_name_index_map = sim_new(64);

  // allocate record buffer
  free(_records);
  _max_records = INIT_MAX_RECORDS;
  _num_records = 0;
  _records = (PerfRec*) malloc(sizeof(PerfRec) * _max_records);
  if(_records == NULL)
    return -1;
  return 0;
}

/*
  Begins measurement of a named time interval
*/
int perf_mark_beg(const char* mark_name) {

  // get mark index
  int mark_index = -1;
  if(!sim_get(_mark_name_index_map, mark_name, &mark_index)) {
    mark_index = sim_get_count(_mark_name_index_map);
    sim_put(_mark_name_index_map, mark_name, mark_index);
  }

  // if mark index is not in records array yet and is bigger than next index, something went wrong
  if(mark_index > _num_records) {
    sys_err("bad mark_index");
  }

  // create perf record if needed
  if(mark_index == _num_records) {
    PerfRec new_rec = { "", 0, {0,0}, {0,0}, {0,0}, {0,0} };
    sstrncpy(new_rec.mark_name, mark_name, sizeof(new_rec.mark_name));
    if(_num_records == _max_records) {
      int new_max = _max_records * 2;
      PerfRec* new_records = realloc(_records, sizeof(PerfRec) * new_max);
      if(new_records == NULL)
        sys_err("out of memory");
      _max_records = new_max;
      _records = new_records;
    }
    mark_index = _num_records++;
    _records[mark_index] = new_rec;
  }

  // update perf record
  PerfRec* rec = _records + mark_index;
  rec->beg_time = sys_timespec_now();
//rec->beg_time_nsec = (unsigned long long)rec->beg_time.tv_sec * (unsigned long long)1000000000LL + (unsigned long long)rec->beg_time.tv_nsec;
  return 0;
}

int perf_mark_end(const char* mark_name) {
//  float cur_time = sys_float_time();
  struct timespec cur_time = sys_timespec_now();
  int mark_index = -1;
  if(!sim_get(_mark_name_index_map, mark_name, &mark_index)) {
    fprintf(stderr, "mark_name not found: %s", mark_name);
    exit(1);
  }
  PerfRec* rec = _records + mark_index;
  struct timespec interval_time = sys_timespec_sub(&cur_time, &rec->beg_time);
  if(rec->num_intervals == 0) {
    rec->min_time = interval_time;
    rec->max_time = interval_time;
  }
  else {
    rec->min_time = sys_timespec_min(&interval_time, &rec->min_time);
    rec->max_time = sys_timespec_max(&interval_time, &rec->max_time);
  }
  rec->total_time = sys_timespec_add(&interval_time, &rec->total_time);
  rec->num_intervals++;

//unsigned long long end_time_nsec = (unsigned long long)cur_time.tv_sec * (unsigned long long)1000000000LL + cur_time.tv_nsec;
//unsigned long long diff_time_nsec = end_time_nsec - rec->beg_time_nsec;
//rec->total_time_nsec += diff_time_nsec;
  return 0;
}

int perf_report_rec(PerfRec* rec) {
  long tv_avg_secs;
  long tv_avg_nsecs;
  if(rec->num_intervals) {
   unsigned long total_nsecs = 1000000000LL * rec->total_time.tv_sec;
   total_nsecs += rec->total_time.tv_nsec;
   unsigned long avg_nsecs = total_nsecs / rec->num_intervals;
   unsigned long ul_tv_avg_secs =  avg_nsecs / 1000000000LL;
   unsigned long ul_tv_avg_nsecs = avg_nsecs % 1000000000LL;
   tv_avg_secs = ul_tv_avg_secs; 
   tv_avg_nsecs = ul_tv_avg_nsecs; 
  }
  printf("  avg: %3ld.%09ld, min: %3ld.%09ld, max: %3ld.%09ld, total: %3ld.%09ld, num_intervals: %6lu, %s\n", 
    tv_avg_secs, tv_avg_nsecs,
    rec->min_time.tv_sec, rec->min_time.tv_nsec,
    rec->max_time.tv_sec, rec->max_time.tv_nsec,
    rec->total_time.tv_sec, rec->total_time.tv_nsec,
    rec->num_intervals,
    rec->mark_name);

  // clear perf record
  rec->num_intervals = 0;
  rec->beg_time.tv_sec = rec->beg_time.tv_nsec = 0;
  rec->total_time.tv_sec = rec->total_time.tv_nsec = 0;
  rec->min_time.tv_sec = rec->min_time.tv_nsec = 0;
  rec->max_time.tv_sec = rec->max_time.tv_nsec = 0;
  return 0;
}

int perf_report() {
  float cur_time = sys_float_time();
  if(_prev_report_time < 0) {
    _prev_report_time = cur_time;
    return 0;
  }
  float delta_time = cur_time - _prev_report_time;
  if(delta_time >= _report_interval_time) {
    printf("%10.6f: perf report: %lu perf records\n", cur_time, _num_records);
    int i = 0;
    for(i = 0; i < _num_records; ++i) {
      PerfRec* rec = _records + i;
      perf_report_rec(rec);
    }
    _prev_report_time = cur_time;
  }
  return -1;
}

int perf_terminate() {
  free(_records);
  _records = NULL;
  sim_delete(_mark_name_index_map);
  _mark_name_index_map = NULL;
  return 0;
}


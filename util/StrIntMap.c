/*
 *    StrIntMap version 2.0.0
 *
 */
#include "StrIntMap.h"

typedef struct Pair Pair;
typedef struct Bucket Bucket;

struct Pair {
	char *key;
	int value;
};

struct Bucket {
	unsigned int count;
	Pair* pairs;
};

struct StrIntMap {
	unsigned int count;
	Bucket* buckets;
};


static Pair* get_pair(Bucket* bucket, const char *key);
static unsigned long hash(const char *str);

StrIntMap* sim_new(unsigned int capacity) {
	StrIntMap* map;
	
	map = malloc(sizeof(StrIntMap));
	if (map == NULL) {
		return NULL;
	}
	map->count = capacity;
	map->buckets = malloc(map->count * sizeof(Bucket));
	if (map->buckets == NULL) {
		free(map);
		return NULL;
	}
	memset(map->buckets, 0, map->count * sizeof(Bucket));
	return map;
}

void sim_delete(StrIntMap *map) {
	unsigned int i, j, n, m;
	Bucket *bucket;
	Pair *pair;

	if (map == NULL) {
		return;
	}
	n = map->count;
	bucket = map->buckets;
	i = 0;
	while (i < n) {
		m = bucket->count;
		pair = bucket->pairs;
		j = 0;
		while(j < m) {
			free(pair->key);
//			free(pair->value);
			pair++;
			j++;
		}
		free(bucket->pairs);
		bucket++;
		i++;
	}
	free(map->buckets);
	free(map);
}

int sim_get(const StrIntMap* map, const char* key, int* out_buf) {
	unsigned int index;
	Bucket *bucket;
	Pair *pair;

	if (map == NULL) {
		return 0;
	}
	if (key == NULL) {
		return 0;
	}
	index = hash(key) % map->count;
	bucket = &(map->buckets[index]);
	pair = get_pair(bucket, key);
	if (pair == NULL) {
		return 0;
	}
/*
	if (out_buf == NULL && n_out_buf == 0) {
		return strlen(pair->value) + 1;
	}
*/
	if (out_buf == NULL) {
		return 0;
	}
/*
	if (strlen(pair->value) >= n_out_buf) {
		return 0;
	}
	strcpy(out_buf, pair->value);
*/
  *out_buf = pair->value;
	return 1;
}

int sim_exists(const StrIntMap* map, const char* key) {
	unsigned int index;
	Bucket *bucket;
	Pair *pair;

	if (map == NULL) {
		return 0;
	}
	if (key == NULL) {
		return 0;
	}
	index = hash(key) % map->count;
	bucket = &(map->buckets[index]);
	pair = get_pair(bucket, key);
	if (pair == NULL) {
		return 0;
	}
	return 1;
}

int sim_put(StrIntMap *map, const char *key, int value) {
	unsigned int key_len, /*value_len, */index;
	Bucket* bucket;
	Pair* tmp_pairs, *pair;
//	char *tmp_value;
	char* new_key/*, *new_value */;

	if (map == NULL) {
		return 0;
	}
	if (key == NULL) {
		return 0;
	}
	key_len = strlen(key);
//	value_len = strlen(value);
	/* Get a pointer to the bucket the key string hashes to */
	index = hash(key) % map->count;
	bucket = &(map->buckets[index]);
	/* Check if we can handle insertion by simply replacing
	 * an existing value in a key-value pair in the bucket.
	 */
	if ((pair = get_pair(bucket, key)) != NULL) {
		/* The bucket contains a pair that matches the provided key,
		 * change the value for that pair to the new value.
		 */
/*
		if (strlen(pair->value) < value_len) {
			/ * If the new value is larger than the old value, re-allocate
			 * space for the new larger value.
			 * /
			tmp_value = realloc(pair->value, (value_len + 1) * sizeof(char));
			if (tmp_value == NULL) {
				return 0;
			}
			pair->value = tmp_value;
		}
*/      
		/* Copy the new value into the pair that matches the key */
//		strcpy(pair->value, value);
    pair->value = value;
		return 1;
	}
	/* Allocate space for a new key and value */
	new_key = malloc((key_len + 1) * sizeof(char));
	if (new_key == NULL) {
		return 0;
	}
/*
	new_value = malloc((value_len + 1) * sizeof(char));
	if (new_value == NULL) {
		free(new_key);
		return 0;
	}
*/
	/* Create a key-value pair */
	if (bucket->count == 0) {
		/* The bucket is empty, lazily allocate space for a single
		 * key-value pair.
		 */
		bucket->pairs = malloc(sizeof(Pair));
		if (bucket->pairs == NULL) {
			free(new_key);
//			free(new_value);
			return 0;
		}
		bucket->count = 1;
	}
	else {
		/* The bucket wasn't empty but no pair existed that matches the provided
		 * key, so create a new key-value pair.
		 */
		tmp_pairs = realloc(bucket->pairs, (bucket->count + 1) * sizeof(Pair));
		if (tmp_pairs == NULL) {
			free(new_key);
//			free(new_value);
			return 0;
		}
		bucket->pairs = tmp_pairs;
		bucket->count++;
	}
	/* Get the last pair in the chain for the bucket */
	pair = &(bucket->pairs[bucket->count - 1]);
	pair->key = new_key;
//	pair->value = new_value;
	/* Copy the key and its value into the key-value pair */
	strcpy(pair->key, key);
//	strcpy(pair->value, value);
  pair->value = value;
	return 1;
}

int sim_get_count(const StrIntMap *map) {
	unsigned int i, j, n, m;
	unsigned int count;
	Bucket* bucket;
	Pair* pair;

	if (map == NULL) {
		return 0;
	}
	bucket = map->buckets;
	n = map->count;
	i = 0;
	count = 0;
	while (i < n) {
		pair = bucket->pairs;
		m = bucket->count;
		j = 0;
		while (j < m) {
			count++;
			pair++;
			j++;
		}
		bucket++;
		i++;
	}
	return count;
}

int sim_enum(const StrIntMap* map, sim_enum_func enum_func, const void* obj) {
	unsigned int i, j, n, m;
	Bucket* bucket;
	Pair* pair;

	if (map == NULL) {
		return 0;
	}
	if (enum_func == NULL) {
		return 0;
	}
	bucket = map->buckets;
	n = map->count;
	i = 0;
	while (i < n) {
		pair = bucket->pairs;
		m = bucket->count;
		j = 0;
		while (j < m) {
			enum_func(pair->key, pair->value, obj);
			pair++;
			j++;
		}
		bucket++;
		i++;
	}
	return 1;
}

/*
 * Returns a pair from the bucket that matches the provided key,
 * or null if no such pair exist.
 */
static Pair* get_pair(Bucket* bucket, const char* key) {
	unsigned int i, n;
	Pair* pair;

	n = bucket->count;
	if (n == 0) {
		return NULL;
	}
	pair = bucket->pairs;
	i = 0;
	while (i < n) {
		if (pair->key != NULL) {
			if (strcmp(pair->key, key) == 0) {
				return pair;
			}
		}
		pair++;
		i++;
	}
	return NULL;
}

/*
 * Returns a hash code for the provided string.
 */
static unsigned long hash(const char *str) {
	unsigned long hash = 5381;
	int c;

	while (c = *str++) {
		hash = ((hash << 5) + hash) + c;
	}
	return hash;
}


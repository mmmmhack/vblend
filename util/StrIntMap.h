/*
 *    StrIntMap : modified from strmap by Per Ola Kristensson <pok21@cam.ac.uk> 
 */
#ifndef StrIntMap_h
#define StrIntMap_h

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdlib.h>
#include <string.h>

typedef struct StrIntMap StrIntMap;

/*
 * This callback function is called once per key-value when enumerating
 * all keys associated to values.
 *
 * Parameters:
 *
 * key: A pointer to a null-terminated C string. The string must not
 * be modified by the client.
 *
 * value: A pointer to a null-terminated C string. The string must
 * not be modified by the client.
 *
 * obj: A pointer to a client-specific object. This parameter may be
 * null.
 *
 * Return value: None.
 */
typedef void(*sim_enum_func)(const char *key, int value, const void *obj);

/*
 * Creates a string map.
 *
 * Parameters:
 *
 * capacity: The number of top-level slots this string map
 * should allocate. This parameter must be > 0.
 *
 * Return value: A pointer to a string map object, 
 * or null if a new string map could not be allocated.
 */
StrIntMap* sim_new(unsigned int capacity);

/*
 * Releases all memory held by a string map object.
 *
 * Parameters:
 *
 * map: A pointer to a string map. This parameter cannot be null.
 * If the supplied string map has been previously released, the
 * behaviour of this function is undefined.
 *
 * Return value: None.
 */
void sim_delete(StrIntMap* map);

/*
 * Returns the value associated with the supplied key.
 *
 * Parameters:
 *
 * map: A pointer to a string map. This parameter cannot be null.
 *
 * key: A pointer to a null-terminated C string. This parameter cannot
 * be null.
 *
 * out_buf: A pointer to an output buffer which will contain the value,
 * if it exists and fits into the buffer.
 *
 * n_out_buf: The size of the output buffer in bytes.
 *
 * Return value: If out_buf is set to null and n_out_buf is set to 0 the return
 * value will be the number of bytes required to store the value (if it exists)
 * and its null-terminator. For all other parameter configurations the return value
 * is 1 if an associated value was found and completely copied into the output buffer,
 * 0 otherwise.
 */
int sim_get(const StrIntMap* map, const char* key, int* out_val);

/*
 * Queries the existence of a key.
 *
 * Parameters:
 *
 * map: A pointer to a string map. This parameter cannot be null.
 *
 * key: A pointer to a null-terminated C string. This parameter cannot
 * be null.
 *
 * Return value: 1 if the key exists, 0 otherwise.
 */
int sim_exists(const StrIntMap *map, const char *key);

/*
 * Associates a value with the supplied key. If the key is already
 * associated with a value, the previous value is replaced.
 *
 * Parameters:
 *
 * map: A pointer to a string map. This parameter cannot be null.
 *
 * key: A pointer to a null-terminated C string. This parameter
 * cannot be null. The string must have a string length > 0. The
 * string will be copied.
 *
 * value: A pointer to a null-terminated C string. This parameter
 * cannot be null. The string must have a string length > 0. The
 * string will be copied.
 *
 * Return value: 1 if the association succeeded, 0 otherwise.
 */
int sim_put(StrIntMap* map, const char* key, int value);

/*
 * Returns the number of associations between keys and values.
 *
 * Parameters:
 *
 * map: A pointer to a string map. This parameter cannot be null.
 *
 * Return value: The number of associations between keys and values.
 */

int sim_get_count(const StrIntMap* map);

/*
 * Enumerates all associations between keys and values.
 *
 * Parameters:
 *
 * map: A pointer to a string map. This parameter cannot be null.
 *
 * enum_func: A pointer to a callback function that will be
 * called by this procedure once for every key associated
 * with a value. This parameter cannot be null.
 *
 * obj: A pointer to a client-specific object. This parameter will be
 * passed back to the client's callback function. This parameter can
 * be null.
 *
 * Return value: 1 if enumeration completed, 0 otherwise.
 */
int sim_enum(const StrIntMap* map, sim_enum_func enum_func, const void* obj);

#ifdef __cplusplus
}
#endif

#endif


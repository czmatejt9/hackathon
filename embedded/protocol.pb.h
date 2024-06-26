/* Automatically generated nanopb header */
/* Generated by nanopb-0.4.9-dev */

#ifndef PB_PROTOCOL_PB_H_INCLUDED
#define PB_PROTOCOL_PB_H_INCLUDED
#include <pb.h>

#if PB_PROTO_HEADER_VERSION != 40
#error Regenerate this file with the current version of nanopb generator.
#endif

/* Struct definitions */
typedef struct _PushSensorState {
    char device_id[32];
    char sensor_id[32];
    char sensor_type[32];
    char state[128];
    int64_t messageid;
} PushSensorState;

typedef struct _PushDeviceState {
    pb_callback_t device_id;
    pb_callback_t field;
    pb_callback_t state;
} PushDeviceState;


#ifdef __cplusplus
extern "C" {
#endif

/* Initializer values for message structs */
#define PushSensorState_init_default             {"", "", "", "", 0}
#define PushDeviceState_init_default             {{{NULL}, NULL}, {{NULL}, NULL}, {{NULL}, NULL}}
#define PushSensorState_init_zero                {"", "", "", "", 0}
#define PushDeviceState_init_zero                {{{NULL}, NULL}, {{NULL}, NULL}, {{NULL}, NULL}}

/* Field tags (for use in manual encoding/decoding) */
#define PushSensorState_device_id_tag            1
#define PushSensorState_sensor_id_tag            2
#define PushSensorState_sensor_type_tag          3
#define PushSensorState_state_tag                4
#define PushSensorState_messageid_tag            5
#define PushDeviceState_device_id_tag            1
#define PushDeviceState_field_tag                2
#define PushDeviceState_state_tag                3

/* Struct field encoding specification for nanopb */
#define PushSensorState_FIELDLIST(X, a) \
X(a, STATIC,   SINGULAR, STRING,   device_id,         1) \
X(a, STATIC,   SINGULAR, STRING,   sensor_id,         2) \
X(a, STATIC,   SINGULAR, STRING,   sensor_type,       3) \
X(a, STATIC,   SINGULAR, STRING,   state,             4) \
X(a, STATIC,   SINGULAR, INT64,    messageid,         5)
#define PushSensorState_CALLBACK NULL
#define PushSensorState_DEFAULT NULL

#define PushDeviceState_FIELDLIST(X, a) \
X(a, CALLBACK, SINGULAR, STRING,   device_id,         1) \
X(a, CALLBACK, SINGULAR, STRING,   field,             2) \
X(a, CALLBACK, SINGULAR, STRING,   state,             3)
#define PushDeviceState_CALLBACK pb_default_field_callback
#define PushDeviceState_DEFAULT NULL

extern const pb_msgdesc_t PushSensorState_msg;
extern const pb_msgdesc_t PushDeviceState_msg;

/* Defines for backwards compatibility with code written before nanopb-0.4.0 */
#define PushSensorState_fields &PushSensorState_msg
#define PushDeviceState_fields &PushDeviceState_msg

/* Maximum encoded size of messages (where known) */
/* PushDeviceState_size depends on runtime parameters */
#define PROTOCOL_PB_H_MAX_SIZE                   PushSensorState_size
#define PushSensorState_size                     240

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif

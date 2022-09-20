INTERFACE zif_otlp_model_logs
  PUBLIC .

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
* this file corresponds to
* https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/logs/v1/logs.proto

* message ResourceLogs {
  TYPES: BEGIN OF ty_resource_logs,
           resource TYPE zif_otlp_model_resource=>ty_resource,
         END OF ty_resource_logs.

  TYPES ty_severity_number TYPE i.
  CONSTANTS: BEGIN OF gc_severity_number,
               severity_number_unspecified TYPE ty_severity_number VALUE 0,
               severity_number_trace       TYPE ty_severity_number VALUE 1,
               severity_number_trace2      TYPE ty_severity_number VALUE 2,
               severity_number_trace3      TYPE ty_severity_number VALUE 3,
               severity_number_trace4      TYPE ty_severity_number VALUE 4,
               severity_number_debug       TYPE ty_severity_number VALUE 5,
               severity_number_debug2      TYPE ty_severity_number VALUE 6,
               severity_number_debug3      TYPE ty_severity_number VALUE 7,
               severity_number_debug4      TYPE ty_severity_number VALUE 8,
               severity_number_info        TYPE ty_severity_number VALUE 9,
               severity_number_info2       TYPE ty_severity_number VALUE 10,
               severity_number_info3       TYPE ty_severity_number VALUE 11,
               severity_number_info4       TYPE ty_severity_number VALUE 12,
               severity_number_warn        TYPE ty_severity_number VALUE 13,
               severity_number_warn2       TYPE ty_severity_number VALUE 14,
               severity_number_warn3       TYPE ty_severity_number VALUE 15,
               severity_number_warn4       TYPE ty_severity_number VALUE 16,
               severity_number_error       TYPE ty_severity_number VALUE 17,
               severity_number_error2      TYPE ty_severity_number VALUE 18,
               severity_number_error3      TYPE ty_severity_number VALUE 19,
               severity_number_error4      TYPE ty_severity_number VALUE 20,
               severity_number_fatal       TYPE ty_severity_number VALUE 21,
               severity_number_fatal2      TYPE ty_severity_number VALUE 22,
               severity_number_fatal3      TYPE ty_severity_number VALUE 23,
               severity_number_fatal4      TYPE ty_severity_number VALUE 24,
             END OF gc_severity_number.

* message LogRecord {
  TYPES: BEGIN OF ty_log_record,
           time_unix_nano          TYPE int8,
           observed_time_unix_nano TYPE int8,
           severity_number         TYPE ty_severity_number,
           severity_text           TYPE string,
           body                    TYPE zif_otlp_model_common=>ty_any_value,
           attributes              TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
           dropped_attributes      TYPE i,
           flags                   TYPE i,
           trace_id                TYPE xstring,
           span_id                 TYPE xstring,
         END OF ty_log_record.

* message ScopeLogs {
  TYPES: BEGIN OF ty_scope_logs,
           scope       TYPE zif_otlp_model_common=>ty_instrumentation_scope,
           log_records TYPE STANDARD TABLE OF ty_log_record WITH EMPTY KEY,
           schema_url  TYPE string,
         END OF ty_scope_logs.

* message LogsData {
  TYPES: BEGIN OF ty_logs_data,
           resource_logs TYPE STANDARD TABLE OF ty_resource_logs WITH EMPTY KEY,
           scope_logs    TYPE STANDARD TABLE OF ty_scope_logs WITH EMPTY KEY,
           schema_url    TYPE string,
         END OF ty_logs_data.

ENDINTERFACE.

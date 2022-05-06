INTERFACE zif_otlp_model_trace
  PUBLIC .


* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
* this file corresponds to
* https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/trace/v1/trace.proto

  TYPES:
*   message Event {
    BEGIN OF ty_event,
      time_unix_nano           TYPE int8,
      name                     TYPE string,
      attributes               TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
      dropped_attributes_count TYPE i,
    END OF ty_event .
  TYPES:
*   message Link {
    BEGIN OF ty_link,
      trace_id                 TYPE xstring,
      span_id                  TYPE xstring,
      trace_state              TYPE string,
      attributes               TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
      dropped_attributes_count TYPE i,
    END OF ty_link .
*  enum StatusCode {
  TYPES ty_status_code TYPE i .
  TYPES:
* message Status {
    BEGIN OF ty_status,
      message TYPE string,
      code    TYPE ty_status_code,
    END OF ty_status .
*  enum SpanKind {
  TYPES ty_span_kind TYPE i .
  TYPES:
* message Span {
    BEGIN OF ty_span,
      trace_id                 TYPE xstring,
      span_id                  TYPE xstring,
      trace_state              TYPE string,
      parent_span_id           TYPE xstring,
      name                     TYPE string,
      kind                     TYPE ty_span_kind,
      start_time_unix_nano     TYPE int8,
      end_time_unix_nano       TYPE int8,
      attributes               TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
      dropped_attributes_count TYPE i,
      events                   TYPE STANDARD TABLE OF ty_event WITH EMPTY KEY,
      dropped_events_count     TYPE i,
      links                    TYPE STANDARD TABLE OF ty_link WITH EMPTY KEY,
      dropped_links_count      TYPE i,
      status                   TYPE ty_status,
    END OF ty_span .
  TYPES:
* message ScopeSpans {
    BEGIN OF ty_scope_spans,
      scope      TYPE zif_otlp_model_common=>ty_instrumentation_scope,
      spans      TYPE STANDARD TABLE OF ty_span WITH EMPTY KEY,
      schema_url TYPE string,
    END OF ty_scope_spans .
  TYPES:
* message ResourceSpans {
    BEGIN OF ty_resource_span,
      resource    TYPE zif_otlp_model_resource=>ty_resource,
      scope_spans TYPE STANDARD TABLE OF ty_scope_spans WITH EMPTY KEY,
      schema_url  TYPE string,
    END OF ty_resource_span .
  TYPES:
* special, top level
    ty_resource_spans TYPE STANDARD TABLE OF ty_resource_span WITH EMPTY KEY .

  CONSTANTS:
    BEGIN OF gc_status_code,
      unset TYPE ty_status_code VALUE 0,
      ok    TYPE ty_status_code VALUE 1,
      error TYPE ty_status_code VALUE 2,
    END OF gc_status_code .
  CONSTANTS:
    BEGIN OF gc_span_kind,
      unspecified TYPE ty_span_kind VALUE 0,
      internal    TYPE ty_span_kind VALUE 1,
      server      TYPE ty_span_kind VALUE 2,
      client      TYPE ty_span_kind VALUE 3,
      producer    TYPE ty_span_kind VALUE 4,
      consumer    TYPE ty_span_kind VALUE 5,
    END OF gc_span_kind .
ENDINTERFACE.

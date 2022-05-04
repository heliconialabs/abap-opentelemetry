INTERFACE zif_otlp_trace_model
  PUBLIC .

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry

  TYPES:
* message AnyValue {
    BEGIN OF ty_any_value,
      string_value TYPE string,
      bool_value   TYPE abap_bool,
      int_value    TYPE i,
      double_value TYPE string, " out of scope
      array_value  TYPE string, " out of scope
      kvlist_value TYPE string, " out of scope
      bytes_value  TYPE xstring,
    END OF ty_any_value .
  TYPES:
* message KeyValue {
    BEGIN OF ty_key_value,
      key   TYPE string,
      value TYPE ty_any_value,
    END OF ty_key_value .
  TYPES:
* message Resource {
    BEGIN OF ty_resource,
      attributes               TYPE STANDARD TABLE OF ty_key_value WITH EMPTY KEY,
      dropped_attributes_count TYPE i,
    END OF ty_resource .
  TYPES:
*   message Event {
    BEGIN OF ty_event,
      time_unix_nano           TYPE int8,
      name                     TYPE string,
      attributes               TYPE STANDARD TABLE OF ty_key_value WITH EMPTY KEY,
      dropped_attributes_count TYPE i,
    END OF ty_event .
  TYPES:
*   message Link {
    BEGIN OF ty_link,
      trace_id                 TYPE xstring,
      span_id                  TYPE xstring,
      trace_state              TYPE string,
      attributes               TYPE STANDARD TABLE OF ty_key_value WITH EMPTY KEY,
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
      attributes               TYPE STANDARD TABLE OF ty_key_value WITH EMPTY KEY,
      dropped_attributes_count TYPE i,
      events                   TYPE STANDARD TABLE OF ty_event WITH EMPTY KEY,
      dropped_events_count     TYPE i,
      links                    TYPE STANDARD TABLE OF ty_link WITH EMPTY KEY,
      dropped_links_count      TYPE i,
      status                   TYPE ty_status,
    END OF ty_span .
  TYPES:
* message InstrumentationScope {
    BEGIN OF ty_instrumentation_scope,
      name    TYPE string,
      version TYPE string,
    END OF ty_instrumentation_scope .
  TYPES:
* message ScopeSpans {
    BEGIN OF ty_scope_spans,
      scope      TYPE ty_instrumentation_scope,
      spans      TYPE STANDARD TABLE OF ty_span WITH EMPTY KEY,
      schema_url TYPE string,
    END OF ty_scope_spans .
  TYPES:
* message ResourceSpans {
    BEGIN OF ty_resource_span,
      resource    TYPE ty_resource,
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

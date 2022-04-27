CLASS zcl_otlp_trace DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
* message AnyValue {
      BEGIN OF ty_any_value,
        string_value TYPE string,
        bool_value   TYPE abap_bool,
        int_value    TYPE i,
        double_value TYPE string, " todo
        array_value  TYPE string, " todo
        kvlist_value TYPE string, " todo
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
    TYPES:
* message Status {
      BEGIN OF ty_status,
        message TYPE string,
        code    TYPE i, " todo, enum?
      END OF ty_status .
    TYPES:
* message Span {
      BEGIN OF ty_span,
        trace_id                 TYPE xstring,
        span_id                  TYPE xstring,
        trace_state              TYPE xstring,
        parent_span_id           TYPE xstring,
        name                     TYPE string,
        kind                     TYPE i, " todo, enum?
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
        name       TYPE string,
        version    TYPE string,
        spans      TYPE STANDARD TABLE OF ty_span WITH EMPTY KEY,
        schema_url TYPE string,
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
      ty_resource_spans TYPE STANDARD TABLE OF ty_resource_span WITH EMPTY KEY .

    CLASS-METHODS encode
      IMPORTING
        !it_resource_spans TYPE ty_resource_spans
      RETURNING
        VALUE(rv_hex)      TYPE xstring .

    CLASS-METHODS encode_resource_spans
      IMPORTING
        !it_resource_spans TYPE ty_resource_spans
      RETURNING
        VALUE(rv_hex)      TYPE xstring .
    CLASS-METHODS encode_scope_spans
      IMPORTING
        !is_scope_spans TYPE ty_scope_spans
      RETURNING
        VALUE(rv_hex)   TYPE xstring .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OTLP_TRACE IMPLEMENTATION.


  METHOD encode.

    DATA(lo_stream) = NEW zcl_protobuf_stream( ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 1
      wire_type    = zcl_protobuf_stream=>gc_wire_type-length_delimited ) ).

    DATA(lv_resource_spans) = encode_resource_spans( it_resource_spans ).

    lo_stream->encode_delimited( lv_resource_spans ).

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD encode_resource_spans.

    DATA(lo_stream) = NEW zcl_protobuf_stream( ).

    LOOP AT it_resource_spans INTO DATA(ls_resource_span).
* todo,     DATA(lv_resource) = encode_resource( ls_resource_span-resource ).

      LOOP AT ls_resource_span-scope_spans INTO DATA(ls_scope_spans).
        lo_stream->encode_field_and_type( VALUE #(
          field_number = 2
          wire_type    = zcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
        lo_stream->encode_delimited( encode_scope_spans( ls_scope_spans ) ).
      ENDLOOP.

      IF ls_resource_span-schema_url IS NOT INITIAL.
        lo_stream->encode_field_and_type( VALUE #(
          field_number = 3
          wire_type    = zcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
        lo_stream->encode_delimited( cl_abap_codepage=>convert_to( ls_resource_span-schema_url ) ).
      ENDIF.
    ENDLOOP.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD encode_scope_spans.

    DATA(lo_stream) = NEW zcl_protobuf_stream( ).

    IF is_scope_spans-schema_url IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( cl_abap_codepage=>convert_to( is_scope_spans-schema_url ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.
ENDCLASS.

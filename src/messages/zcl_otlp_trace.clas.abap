CLASS zcl_otlp_trace DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry

    CLASS-METHODS encode
      IMPORTING
        !it_resource_spans TYPE zif_otlp_model_trace=>ty_resource_spans
      RETURNING
        VALUE(rv_hex)      TYPE xstring .

    CLASS-METHODS decode
      IMPORTING
        iv_hex      TYPE xstring
      RETURNING
        VALUE(rt_resource_spans) TYPE zif_otlp_model_trace=>ty_resource_spans.
  PROTECTED SECTION.

    CLASS-METHODS encode_event
      IMPORTING
        !is_event     TYPE zif_otlp_model_trace=>ty_event
      RETURNING
        VALUE(rv_hex) TYPE xstring .
    CLASS-METHODS decode_event
      IMPORTING
        iv_hex          TYPE xstring
      RETURNING
        VALUE(rs_event) TYPE zif_otlp_model_trace=>ty_event.
    CLASS-METHODS encode_link
      IMPORTING
        !is_link      TYPE zif_otlp_model_trace=>ty_link
      RETURNING
        VALUE(rv_hex) TYPE xstring .
    CLASS-METHODS decode_link
      IMPORTING
        iv_hex         TYPE xstring
      RETURNING
        VALUE(rs_link) TYPE zif_otlp_model_trace=>ty_link.
    CLASS-METHODS encode_resource_spans
      IMPORTING
        !is_resource_spans TYPE zif_otlp_model_trace=>ty_resource_span
      RETURNING
        VALUE(rv_hex)      TYPE xstring .
    CLASS-METHODS decode_resource_spans
      IMPORTING
        iv_hex TYPE xstring
      RETURNING
        VALUE(rs_resource_spans) TYPE zif_otlp_model_trace=>ty_resource_span.
    CLASS-METHODS decode_scope_spans
      IMPORTING
        iv_hex   TYPE xstring
      RETURNING
        VALUE(rs_scope_spans) TYPE zif_otlp_model_trace=>ty_scope_spans.
    CLASS-METHODS encode_scope_spans
      IMPORTING
        !is_scope_spans TYPE zif_otlp_model_trace=>ty_scope_spans
      RETURNING
        VALUE(rv_hex)   TYPE xstring .
    CLASS-METHODS encode_span
      IMPORTING
        !is_span      TYPE zif_otlp_model_trace=>ty_span
      RETURNING
        VALUE(rv_hex) TYPE xstring .
    CLASS-METHODS decode_span
      IMPORTING
        iv_hex         TYPE xstring
      RETURNING
        VALUE(rs_span) TYPE zif_otlp_model_trace=>ty_span.
    CLASS-METHODS encode_status
      IMPORTING
        !is_status    TYPE zif_otlp_model_trace=>ty_status
      RETURNING
        VALUE(rv_hex) TYPE xstring .
    CLASS-METHODS decode_status
      IMPORTING
        iv_hex TYPE xstring
      RETURNING
        VALUE(rs_status)    TYPE zif_otlp_model_trace=>ty_status.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_otlp_trace IMPLEMENTATION.


  METHOD decode.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      ASSERT ls_field_and_type-field_number = 1.
      APPEND decode_resource_spans( lo_stream->decode_delimited( ) ) TO rt_resource_spans.
    ENDWHILE.

  ENDMETHOD.

  METHOD encode.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* top level, message TracesData
    LOOP AT it_resource_spans INTO DATA(ls_resource_span).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_resource_spans( ls_resource_span ) ).
    ENDLOOP.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD decode_event.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      CASE ls_field_and_type-field_number.
        WHEN 1.
          rs_event-time_unix_nano = lo_stream->decode_fixed64( ).
        WHEN 2.
          rs_event-name = zcl_otlp_util=>from_xstring( lo_stream->decode_delimited( ) ).
        WHEN 3.
          APPEND zcl_otlp_common=>decode_key_value( lo_stream->decode_delimited( ) ) TO rs_event-attributes.
        WHEN 4.
          rs_event-dropped_attributes_count = lo_stream->decode_varint( ).
      ENDCASE.
    ENDWHILE.

  ENDMETHOD.

  METHOD encode_event.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    IF is_event-time_unix_nano IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_fixed64( is_event-time_unix_nano ).
    ENDIF.

    IF is_event-name IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_event-name ) ).
    ENDIF.

    LOOP AT is_event-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_common=>encode_key_value( ls_attribute ) ).
    ENDLOOP.

    IF is_event-dropped_attributes_count IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 4
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_event-dropped_attributes_count ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD decode_link.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      CASE ls_field_and_type-field_number.
        WHEN 1.
          rs_link-trace_id = lo_stream->decode_delimited( ).
        WHEN 2.
          rs_link-span_id = lo_stream->decode_delimited( ).
        WHEN 3.
          rs_link-trace_state = zcl_otlp_util=>from_xstring( lo_stream->decode_delimited( ) ).
        WHEN 4.
          APPEND zcl_otlp_common=>decode_key_value( lo_stream->decode_delimited( ) ) TO rs_link-attributes.
        WHEN 5.
          rs_link-dropped_attributes_count = lo_stream->decode_varint( ).
      ENDCASE.
    ENDWHILE.

  ENDMETHOD.

  METHOD encode_link.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    IF is_link-trace_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_link-trace_id ).
    ENDIF.

    IF is_link-span_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_link-span_id ).
    ENDIF.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 3
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_link-trace_state ) ).

    LOOP AT is_link-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 4
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_common=>encode_key_value( ls_attribute ) ).
    ENDLOOP.

    IF is_link-dropped_attributes_count IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 5
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_link-dropped_attributes_count ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.

  METHOD decode_resource_spans.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      CASE ls_field_and_type-field_number.
        WHEN 1.
          rs_resource_spans-resource = zcl_otlp_resource=>decode_resource( lo_stream->decode_delimited( ) ).
        WHEN 2.
          APPEND decode_scope_spans( lo_stream->decode_delimited( ) ) TO rs_resource_spans-scope_spans.
        WHEN 3.
          rs_resource_spans-schema_url = zcl_otlp_util=>from_xstring( lo_stream->decode_delimited( ) ).
      ENDCASE.
    ENDWHILE.

  ENDMETHOD.

  METHOD encode_resource_spans.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    IF is_resource_spans-resource IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_resource=>encode_resource( is_resource_spans-resource ) ).
    ENDIF.

    LOOP AT is_resource_spans-scope_spans INTO DATA(ls_scope_spans).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_scope_spans( ls_scope_spans ) ).
    ENDLOOP.

    IF is_resource_spans-schema_url IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_resource_spans-schema_url ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.

  METHOD decode_scope_spans.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      CASE ls_field_and_type-field_number.
        WHEN 1.
          rs_scope_spans-scope = zcl_otlp_common=>decode_instrumentation_scope( lo_stream->decode_delimited( ) ).
        WHEN 2.
          APPEND decode_span( lo_stream->decode_delimited( ) ) TO rs_scope_spans-spans.
        WHEN 3.
          rs_scope_spans-schema_url = zcl_otlp_util=>from_xstring( lo_stream->decode_delimited( ) ).
      ENDCASE.
    ENDWHILE.

  ENDMETHOD.

  METHOD encode_scope_spans.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    IF is_scope_spans-scope IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_common=>encode_instrumentation_scope( is_scope_spans-scope ) ).
    ENDIF.

    LOOP AT is_scope_spans-spans INTO DATA(ls_span).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_span( ls_span ) ).
    ENDLOOP.

    IF is_scope_spans-schema_url IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_scope_spans-schema_url ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.

  METHOD decode_span.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      CASE ls_field_and_type-field_number.
        WHEN 1.
          rs_span-trace_id = lo_stream->decode_delimited( ).
        WHEN 2.
          rs_span-span_id = lo_stream->decode_delimited( ).
        WHEN 3.
          rs_span-trace_state = zcl_otlp_util=>from_xstring( lo_stream->decode_delimited( ) ).
        WHEN 4.
          rs_span-parent_span_id = lo_stream->decode_delimited( ).
        WHEN 5.
          rs_span-name = zcl_otlp_util=>from_xstring( lo_stream->decode_delimited( ) ).
        WHEN 6.
          rs_span-kind = lo_stream->decode_varint( ).
        WHEN 7.
          rs_span-start_time_unix_nano = lo_stream->decode_fixed64( ).
        WHEN 8.
          rs_span-end_time_unix_nano = lo_stream->decode_fixed64( ).
        WHEN 9.
          APPEND zcl_otlp_common=>decode_key_value( lo_stream->decode_delimited( ) ) TO rs_span-attributes.
        WHEN 10.
          rs_span-dropped_attributes_count = lo_stream->decode_varint( ).
        WHEN 11.
          APPEND decode_event( lo_stream->decode_delimited( ) ) TO rs_span-events.
        WHEN 12.
          rs_span-dropped_events_count = lo_stream->decode_varint( ).
        WHEN 13.
          APPEND decode_link( lo_stream->decode_delimited( ) ) TO rs_span-links.
        WHEN 14.
          rs_span-dropped_links_count = lo_stream->decode_varint( ).
        WHEN 15.
          rs_span-status = decode_status( lo_stream->decode_delimited( ) ).
      ENDCASE.
    ENDWHILE.

  ENDMETHOD.

  METHOD encode_span.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    IF is_span-trace_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_span-trace_id ).
    ENDIF.

    IF is_span-span_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_span-span_id ).
    ENDIF.

    IF is_span-trace_state IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_span-trace_state ) ).
    ENDIF.

    IF is_span-parent_span_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 4
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_span-parent_span_id ).
    ENDIF.

    IF is_span-name IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 5
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_span-name ) ).
    ENDIF.

    IF is_span-kind IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 6
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_span-kind ).
    ENDIF.

    IF is_span-start_time_unix_nano IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 7
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_fixed64( is_span-start_time_unix_nano ).
    ENDIF.

    IF is_span-end_time_unix_nano IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 8
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_fixed64( is_span-end_time_unix_nano ).
    ENDIF.

    LOOP AT is_span-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 9
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_common=>encode_key_value( ls_attribute ) ).
    ENDLOOP.

    IF is_span-dropped_attributes_count IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 10
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_span-dropped_attributes_count ).
    ENDIF.

    LOOP AT is_span-events INTO DATA(ls_event).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 11
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_event( ls_event ) ).
    ENDLOOP.

    IF is_span-dropped_events_count IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 12
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_span-dropped_events_count ).
    ENDIF.

    LOOP AT is_span-links INTO DATA(ls_link).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 13
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_link( ls_link ) ).
    ENDLOOP.

    IF is_span-dropped_links_count IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 14
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_span-dropped_links_count ).
    ENDIF.

    IF is_span-status IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 15
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_status( is_span-status ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD decode_status.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      CASE ls_field_and_type-field_number.
        WHEN 1.
          rs_status-message = zcl_otlp_util=>from_xstring( lo_stream->decode_delimited( ) ).
        WHEN 3.
          rs_status-code = lo_stream->decode_varint( ).
      ENDCASE.
    ENDWHILE.

  ENDMETHOD.

  METHOD encode_status.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    IF is_status-message IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_status-message ) ).
    ENDIF.

    IF is_status-code IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_status-code ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.
ENDCLASS.

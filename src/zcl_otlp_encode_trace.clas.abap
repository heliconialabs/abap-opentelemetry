CLASS zcl_otlp_encode_trace DEFINITION
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
  PROTECTED SECTION.

    CLASS-METHODS encode_resource_spans
      IMPORTING
        !is_resource_spans TYPE zif_otlp_model_trace=>ty_resource_span
      RETURNING
        VALUE(rv_hex)      TYPE xstring .
    CLASS-METHODS encode_scope_spans
      IMPORTING
        !is_scope_spans TYPE zif_otlp_model_trace=>ty_scope_spans
      RETURNING
        VALUE(rv_hex)   TYPE xstring .
    CLASS-METHODS encode_instrumentation_scope
      IMPORTING
        is_instrumentation_scope TYPE zif_otlp_model_common=>ty_instrumentation_scope
      RETURNING
        VALUE(rv_hex)            TYPE xstring .
    CLASS-METHODS encode_span
      IMPORTING
        is_span       TYPE zif_otlp_model_trace=>ty_span
      RETURNING
        VALUE(rv_hex) TYPE xstring .
    CLASS-METHODS encode_resource
      IMPORTING
        is_resource   TYPE zif_otlp_model_resource=>ty_resource
      RETURNING
        VALUE(rv_hex) TYPE xstring .

    CLASS-METHODS encode_key_value
      IMPORTING
        is_key_value  TYPE zif_otlp_model_common=>ty_key_value
      RETURNING
        VALUE(rv_hex) TYPE xstring .

    CLASS-METHODS encode_any_value
      IMPORTING
        is_any_value  TYPE zif_otlp_model_common=>ty_any_value
      RETURNING
        VALUE(rv_hex) TYPE xstring .

    CLASS-METHODS encode_status
      IMPORTING
        is_status     TYPE zif_otlp_model_trace=>ty_status
      RETURNING
        VALUE(rv_hex) TYPE xstring .

    CLASS-METHODS encode_link
      IMPORTING
        is_link       TYPE zif_otlp_model_trace=>ty_link
      RETURNING
        VALUE(rv_hex) TYPE xstring .

    CLASS-METHODS encode_event
      IMPORTING
        is_event      TYPE zif_otlp_model_trace=>ty_event
      RETURNING
        VALUE(rv_hex) TYPE xstring .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OTLP_ENCODE_TRACE IMPLEMENTATION.


  METHOD encode.

    DATA(lo_stream) = NEW lcl_protobuf_stream( ).

* top level, message TracesData
    LOOP AT it_resource_spans INTO DATA(ls_resource_span).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_resource_spans( ls_resource_span ) ).
    ENDLOOP.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD encode_any_value.

    DATA(lo_stream) = NEW lcl_protobuf_stream( ).

    IF is_any_value-string_value IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( cl_abap_codepage=>convert_to( is_any_value-string_value ) ).
    ELSEIF is_any_value-bool_value IS NOT INITIAL.
      ASSERT 1 = 'todo'.
    ELSEIF is_any_value-int_value IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = lcl_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_any_value-int_value ).
    ELSEIF is_any_value-double_value  IS NOT INITIAL.
      ASSERT 1 = 'out of scope'.
    ELSEIF is_any_value-array_value   IS NOT INITIAL.
      ASSERT 1 = 'out of scope'.
    ELSEIF is_any_value-kvlist_value  IS NOT INITIAL.
      ASSERT 1 = 'out of scope'.
    ELSEIF is_any_value-bytes_value IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 7
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_any_value-bytes_value ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD encode_event.

    DATA(lo_stream) = NEW lcl_protobuf_stream( ).

    IF is_event-time_unix_nano IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = lcl_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_fixed64( is_event-time_unix_nano ).
    ENDIF.

    IF is_event-name IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( cl_abap_codepage=>convert_to( is_event-name ) ).
    ENDIF.

    LOOP AT is_event-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_key_value( ls_attribute ) ).
    ENDLOOP.

    IF is_event-dropped_attributes_count IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 4
        wire_type    = lcl_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_event-dropped_attributes_count ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD encode_instrumentation_scope.

    DATA(lo_stream) = NEW lcl_protobuf_stream( ).

    IF is_instrumentation_scope-name IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( cl_abap_codepage=>convert_to( is_instrumentation_scope-name ) ).
    ENDIF.

    IF is_instrumentation_scope-version IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( cl_abap_codepage=>convert_to( is_instrumentation_scope-version ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD encode_key_value.

    DATA(lo_stream) = NEW lcl_protobuf_stream( ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 1
      wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( cl_abap_codepage=>convert_to( is_key_value-key ) ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( encode_any_value( is_key_value-value ) ).

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD encode_link.

    DATA(lo_stream) = NEW lcl_protobuf_stream( ).

    IF is_link-trace_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_link-trace_id ).
    ENDIF.

    IF is_link-span_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_link-span_id ).
    ENDIF.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 3
      wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( cl_abap_codepage=>convert_to( is_link-trace_state ) ).

    LOOP AT is_link-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 4
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_key_value( ls_attribute ) ).
    ENDLOOP.

    IF is_link-dropped_attributes_count IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 5
        wire_type    = lcl_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_link-dropped_attributes_count ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD encode_resource.

    DATA(lo_stream) = NEW lcl_protobuf_stream( ).

    LOOP AT is_resource-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_key_value( ls_attribute ) ).
    ENDLOOP.

    IF is_resource-dropped_attributes_count IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = lcl_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_resource-dropped_attributes_count ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD encode_resource_spans.

    DATA(lo_stream) = NEW lcl_protobuf_stream( ).

    IF is_resource_spans-resource IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_resource( is_resource_spans-resource ) ).
    ENDIF.

    LOOP AT is_resource_spans-scope_spans INTO DATA(ls_scope_spans).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_scope_spans( ls_scope_spans ) ).
    ENDLOOP.

    IF is_resource_spans-schema_url IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( cl_abap_codepage=>convert_to( is_resource_spans-schema_url ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD encode_scope_spans.

    DATA(lo_stream) = NEW lcl_protobuf_stream( ).

    IF is_scope_spans-scope IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_instrumentation_scope( is_scope_spans-scope ) ).
    ENDIF.

    LOOP AT is_scope_spans-spans INTO DATA(ls_span).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_span( ls_span ) ).
    ENDLOOP.

    IF is_scope_spans-schema_url IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( cl_abap_codepage=>convert_to( is_scope_spans-schema_url ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD encode_span.

    DATA(lo_stream) = NEW lcl_protobuf_stream( ).

    IF is_span-trace_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_span-trace_id ).
    ENDIF.

    IF is_span-span_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_span-span_id ).
    ENDIF.

    IF is_span-trace_state IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( cl_abap_codepage=>convert_to( is_span-trace_state ) ).
    ENDIF.

    IF is_span-parent_span_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 4
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_span-parent_span_id ).
    ENDIF.

    IF is_span-name IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 5
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( cl_abap_codepage=>convert_to( is_span-name ) ).
    ENDIF.

    IF is_span-kind IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 6
        wire_type    = lcl_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_span-kind ).
    ENDIF.

    IF is_span-start_time_unix_nano IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 7
        wire_type    = lcl_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_fixed64( is_span-start_time_unix_nano ).
    ENDIF.

    IF is_span-end_time_unix_nano IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 8
        wire_type    = lcl_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_fixed64( is_span-end_time_unix_nano ).
    ENDIF.

    LOOP AT is_span-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 9
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_key_value( ls_attribute ) ).
    ENDLOOP.

    IF is_span-dropped_attributes_count IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 10
        wire_type    = lcl_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_span-dropped_attributes_count ).
    ENDIF.

    LOOP AT is_span-events INTO DATA(ls_event).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 11
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_event( ls_event ) ).
    ENDLOOP.

    IF is_span-dropped_events_count IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 12
        wire_type    = lcl_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_span-dropped_events_count ).
    ENDIF.

    LOOP AT is_span-links INTO DATA(ls_link).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 13
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_link( ls_link ) ).
    ENDLOOP.

    IF is_span-dropped_links_count IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 14
        wire_type    = lcl_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_span-dropped_links_count ).
    ENDIF.

    IF is_span-status IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 14
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_status( is_span-status ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.


  METHOD encode_status.

    DATA(lo_stream) = NEW lcl_protobuf_stream( ).

    IF is_status-message IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = lcl_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( cl_abap_codepage=>convert_to( is_status-message ) ).
    ENDIF.

    IF is_status-code IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = lcl_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_status-code ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.
ENDCLASS.

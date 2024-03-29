CLASS zcl_otlp_logs DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
    CLASS-METHODS encode
      IMPORTING
        !is_logs_data TYPE zif_otlp_model_logs=>ty_logs_data
      RETURNING
        VALUE(rv_hex) TYPE xstring .

    CLASS-METHODS decode
      IMPORTING
        !iv_hex TYPE xstring
      RETURNING
        VALUE(rs_logs_data) TYPE zif_otlp_model_logs=>ty_logs_data .
  PROTECTED SECTION.

    CLASS-METHODS encode_scope_logs
      IMPORTING
        !is_scope_logs TYPE zif_otlp_model_logs=>ty_scope_logs
      RETURNING
        VALUE(rv_hex)  TYPE xstring .
    CLASS-METHODS decode_scope_logs
      IMPORTING
        iv_hex  TYPE xstring
      RETURNING
        VALUE(rs_scope_logs) TYPE zif_otlp_model_logs=>ty_scope_logs.

    CLASS-METHODS encode_resource_logs
      IMPORTING
        !is_resource_logs TYPE zif_otlp_model_logs=>ty_resource_logs
      RETURNING
        VALUE(rv_hex)     TYPE xstring .
    CLASS-METHODS decode_resource_logs
      IMPORTING
        iv_hex     TYPE xstring
      RETURNING
        VALUE(rs_resource_logs) TYPE zif_otlp_model_logs=>ty_resource_logs.

    CLASS-METHODS encode_log_record
      IMPORTING
        !is_log_record TYPE zif_otlp_model_logs=>ty_log_record
      RETURNING
        VALUE(rv_hex)  TYPE xstring .
    CLASS-METHODS decode_log_record
      IMPORTING
        iv_hex  TYPE xstring
      RETURNING
        VALUE(rs_log_record) TYPE zif_otlp_model_logs=>ty_log_record.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_otlp_logs IMPLEMENTATION.

  METHOD encode.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    LOOP AT is_logs_data-resource_logs INTO DATA(ls_resource_logs).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_resource_logs( ls_resource_logs ) ).
    ENDLOOP.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.

  METHOD decode.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      ASSERT ls_field_and_type-field_number = 1.
      APPEND decode_resource_logs( lo_stream->decode_delimited( ) ) TO rs_logs_data-resource_logs.
    ENDWHILE.

  ENDMETHOD.

  METHOD encode_log_record.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    IF is_log_record-time_unix_nano IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_fixed64( is_log_record-time_unix_nano ).
    ENDIF.

    IF is_log_record-observed_time_unix_nano IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 11
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_fixed64( is_log_record-observed_time_unix_nano ).
    ENDIF.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
    lo_stream->encode_varint( is_log_record-severity_number ).

    IF is_log_record-severity_text IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_log_record-severity_text ) ).
    ENDIF.

    IF is_log_record-body IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 5
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_common=>encode_any_value( is_log_record-body ) ).
    ENDIF.

    LOOP AT is_log_record-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 6
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_common=>encode_key_value( ls_attribute ) ).
    ENDLOOP.

    IF is_log_record-dropped_attributes IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 7
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_log_record-dropped_attributes ).
    ENDIF.

    IF is_log_record-flags IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 8
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_log_record-flags ).
    ENDIF.

    IF is_log_record-trace_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 9
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_log_record-trace_id ).
    ENDIF.

    IF is_log_record-span_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 10
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_log_record-span_id ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.

  METHOD decode_log_record.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      CASE ls_field_and_type-field_number.
        WHEN 1.
          rs_log_record-time_unix_nano = lo_stream->decode_fixed64( ).
        WHEN 2.
          rs_log_record-severity_number = lo_stream->decode_varint( ).
        WHEN 3.
          rs_log_record-severity_text = zcl_otlp_util=>from_xstring( lo_stream->decode_delimited( ) ).
        WHEN 5.
          rs_log_record-body = zcl_otlp_common=>decode_any_value( lo_stream->decode_delimited( ) ).
        WHEN 6.
          APPEND zcl_otlp_common=>decode_key_value( lo_stream->decode_delimited( ) ) TO rs_log_record-attributes.
        WHEN 7.
          rs_log_record-dropped_attributes = lo_stream->decode_varint( ).
        WHEN 8.
          rs_log_record-flags = lo_stream->decode_varint( ).
        WHEN 9.
          rs_log_record-trace_id = lo_stream->decode_delimited( ).
        WHEN 10.
          rs_log_record-span_id = lo_stream->decode_delimited( ).
        WHEN 11.
          rs_log_record-observed_time_unix_nano = lo_stream->decode_fixed64( ).
      ENDCASE.
    ENDWHILE.

  ENDMETHOD.

  METHOD encode_resource_logs.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    IF is_resource_logs-resource IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_resource=>encode_resource( is_resource_logs-resource ) ).
    ENDIF.

    LOOP AT is_resource_logs-scope_logs INTO DATA(ls_scope_logs).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_scope_logs( ls_scope_logs ) ).
    ENDLOOP.

    IF is_resource_logs-schema_url IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_resource_logs-schema_url ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.

  METHOD decode_resource_logs.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      CASE ls_field_and_type-field_number.
        WHEN 1.
          rs_resource_logs-resource = zcl_otlp_resource=>decode_resource( lo_stream->decode_delimited( ) ).
        WHEN 2.
          APPEND decode_scope_logs( lo_stream->decode_delimited( ) ) TO rs_resource_logs-scope_logs.
        WHEN 3.
          rs_resource_logs-schema_url = zcl_otlp_util=>from_xstring( lo_stream->decode_delimited( ) ).
      ENDCASE.
    ENDWHILE.

  ENDMETHOD.

  METHOD encode_scope_logs.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    IF is_scope_logs-scope IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_common=>encode_instrumentation_scope( is_scope_logs-scope ) ).
    ENDIF.

    LOOP AT is_scope_logs-log_records INTO DATA(ls_log_record).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( encode_log_record( ls_log_record ) ).
    ENDLOOP.

    IF is_scope_logs-schema_url IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_scope_logs-schema_url ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.

  METHOD decode_scope_logs.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      CASE ls_field_and_type-field_number.
        WHEN 1.
          rs_scope_logs-scope = zcl_otlp_common=>decode_instrumentation_scope( lo_stream->decode_delimited( ) ).
        WHEN 2.
          APPEND decode_log_record( lo_stream->decode_delimited( ) ) TO rs_scope_logs-log_records.
        WHEN 3.
          rs_scope_logs-schema_url = zcl_otlp_util=>from_xstring( lo_stream->decode_delimited( ) ).
      ENDCASE.
    ENDWHILE.

  ENDMETHOD.

ENDCLASS.

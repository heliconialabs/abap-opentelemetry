CLASS zcl_otlp_common DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
    CLASS-METHODS encode_any_value
      IMPORTING
        !is_any_value TYPE zif_otlp_model_common=>ty_any_value
      RETURNING
        VALUE(rv_hex) TYPE xstring .
    CLASS-METHODS decode_any_value
      IMPORTING
        iv_hex TYPE xstring
      RETURNING
        VALUE(rs_any_value) TYPE zif_otlp_model_common=>ty_any_value.
    CLASS-METHODS encode_key_value
      IMPORTING
        !is_key_value TYPE zif_otlp_model_common=>ty_key_value
      RETURNING
        VALUE(rv_hex) TYPE xstring .
    CLASS-METHODS decode_key_value
      IMPORTING
        iv_hex TYPE xstring
      RETURNING
        VALUE(rs_key_value) TYPE zif_otlp_model_common=>ty_key_value.
    CLASS-METHODS encode_instrumentation_scope
      IMPORTING
        !is_instrumentation_scope TYPE zif_otlp_model_common=>ty_instrumentation_scope
      RETURNING
        VALUE(rv_hex)             TYPE xstring .
  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_otlp_common IMPLEMENTATION.


  METHOD encode_any_value.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    IF is_any_value-string_value IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_any_value-string_value ) ).
    ELSEIF is_any_value-bool_value IS NOT INITIAL.
      ASSERT 1 = 'todo'.
    ELSEIF is_any_value-int_value IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
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
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_any_value-bytes_value ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.

  METHOD decode_any_value.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).
    DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).

    CASE ls_field_and_type-field_number.
      WHEN 1.
        rs_any_value-string_value = zcl_otlp_util=>from_xstring( lo_stream->decode_delimited( ) ).
      WHEN 3.
        rs_any_value-int_value = lo_stream->decode_varint( ).
      WHEN 7.
        rs_any_value-bytes_value = lo_stream->decode_delimited( ).
      WHEN OTHERS.
        ASSERT 1 = 'out of scope'.
    ENDCASE.

  ENDMETHOD.

  METHOD encode_instrumentation_scope.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    IF is_instrumentation_scope-name IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_instrumentation_scope-name ) ).
    ENDIF.

    IF is_instrumentation_scope-version IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_instrumentation_scope-version ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).
  ENDMETHOD.

  METHOD decode_key_value.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      CASE ls_field_and_type-field_number.
        WHEN 1.
          rs_key_value-key = zcl_otlp_util=>from_xstring( lo_stream->decode_delimited( ) ).
        WHEN 2.
          rs_key_value-value = decode_any_value( lo_stream->decode_delimited( ) ).
      ENDCASE.
    ENDWHILE.

  ENDMETHOD.

  METHOD encode_key_value.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 1
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_key_value-key ) ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( encode_any_value( is_key_value-value ) ).

    rv_hex = lo_stream->get( ).

  ENDMETHOD.
ENDCLASS.

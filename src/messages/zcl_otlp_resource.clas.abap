CLASS zcl_otlp_resource DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
    CLASS-METHODS encode_resource
      IMPORTING
        !is_resource  TYPE zif_otlp_model_resource=>ty_resource
      RETURNING
        VALUE(rv_hex) TYPE xstring .
    CLASS-METHODS decode_resource
      IMPORTING
        iv_hex TYPE xstring
      RETURNING
        VALUE(rs_resource) TYPE zif_otlp_model_resource=>ty_resource.
  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_otlp_resource IMPLEMENTATION.

  METHOD decode_resource.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( iv_hex ).

    WHILE lo_stream->length( ) > 0.
      DATA(ls_field_and_type) = lo_stream->decode_field_and_type( ).
      CASE ls_field_and_type-field_number.
        WHEN 1.
          APPEND zcl_otlp_common=>decode_key_value( lo_stream->decode_delimited( ) ) TO rs_resource-attributes.
        WHEN 2.
          rs_resource-dropped_attributes_count = lo_stream->decode_varint( ).
      ENDCASE.
    ENDWHILE.

  ENDMETHOD.

  METHOD encode_resource.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    LOOP AT is_resource-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_common=>encode_key_value( ls_attribute ) ).
    ENDLOOP.

    IF is_resource-dropped_attributes_count IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_resource-dropped_attributes_count ).
    ENDIF.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.
ENDCLASS.

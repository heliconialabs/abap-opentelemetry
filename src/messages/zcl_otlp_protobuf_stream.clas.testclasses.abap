CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.
  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_otlp_protobuf_stream.
    METHODS setup.
    METHODS field_and_type FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD field_and_type.

    DATA(ls_field_and_type) = VALUE zcl_otlp_protobuf_stream=>ty_field_and_type(
      field_number = 10
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ).
    mo_cut->encode_field_and_type( ls_field_and_type ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->get( )
      exp = '52' ).

    DATA(ls_decoded) = mo_cut->decode_field_and_type( ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_decoded-field_number
      exp = ls_field_and_type-field_number ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_decoded-wire_type
      exp = ls_field_and_type-wire_type ).

  ENDMETHOD.

ENDCLASS.

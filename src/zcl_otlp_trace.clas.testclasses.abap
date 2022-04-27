CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_otlp_trace.
    METHODS setup.
    METHODS encode01 FOR TESTING.
ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD encode01.

    DATA(lv_hex) = mo_cut->encode( VALUE #( (
      scope_spans = VALUE #( (
      scope = VALUE #( name = 'foo' ) ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0A0B12090A050A03666F6F1200' ).

  ENDMETHOD.

ENDCLASS.

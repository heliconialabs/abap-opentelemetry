CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_otlp_trace.
    METHODS setup.
    METHODS encode01 FOR TESTING RAISING cx_static_check.
    METHODS encode02 FOR TESTING RAISING cx_static_check.
    METHODS encode03 FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD encode01.
    DATA(lv_hex) = mo_cut->encode( VALUE #( ( schema_url = 'moo' ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0A051A036D6F6F' ).
  ENDMETHOD.

  METHOD encode02.
    DATA(lv_hex) = mo_cut->encode( VALUE #( (
       scope_spans = VALUE #( (
       scope = VALUE #( name = 'foo' ) ) ) ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0A0912070A050A03666F6F' ).
  ENDMETHOD.

  METHOD encode03.
    DATA(lv_hex) = mo_cut->encode( VALUE #( (
      resource = VALUE #(
      attributes = VALUE #( (
        VALUE #( key = 'http.status_code'
        value = VALUE #( int_value = 200 ) ) ) )
    ) ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0A1B0A190A170A10687474702E7374617475735F636F6465120318C801' ).
  ENDMETHOD.

ENDCLASS.

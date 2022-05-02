CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_otlp_trace.
    METHODS setup.
    METHODS encode01 FOR TESTING RAISING cx_static_check.
    METHODS encode02 FOR TESTING RAISING cx_static_check.
    METHODS encode03 FOR TESTING RAISING cx_static_check.
    METHODS encode04 FOR TESTING RAISING cx_static_check.
    METHODS encode05 FOR TESTING RAISING cx_static_check.
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
        VALUE #( key   = 'http.status_code'
                 value = VALUE #( int_value = 200 ) ) ) )
      ) ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0A1B0A190A170A10687474702E7374617475735F636F6465120318C801' ).
  ENDMETHOD.

  METHOD encode04.
    DATA(lv_hex) = mo_cut->encode( VALUE #( (
       scope_spans = VALUE #( (
       spans = VALUE #( ( VALUE #(
         trace_id = '8A0BFA1BD9115897351A72440FB1F7BB'
         span_id  = 'FAE688807A3538EE' ) ) ) ) ) ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0A20121E121C0A108A0BFA1BD9115897351A72440FB1F7BB1208FAE688807A3538EE' ).
  ENDMETHOD.

  METHOD encode05.
    DATA(lv_hex) = mo_cut->encode( VALUE #( (
       scope_spans = VALUE #( (
       spans = VALUE #( ( VALUE #(
         start_time_unix_nano = 1651130626313000 ) ) ) ) ) ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0A0D120B120939288B75CEB1DD0500' ).
  ENDMETHOD.

ENDCLASS.

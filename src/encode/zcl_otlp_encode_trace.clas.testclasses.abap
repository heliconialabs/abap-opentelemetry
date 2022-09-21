CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_otlp_encode_trace.
    METHODS setup.
    METHODS encode01 FOR TESTING RAISING cx_static_check.
    METHODS encode02 FOR TESTING RAISING cx_static_check.
    METHODS encode03 FOR TESTING RAISING cx_static_check.
    METHODS encode04 FOR TESTING RAISING cx_static_check.
    METHODS encode05 FOR TESTING RAISING cx_static_check.
    METHODS encode06 FOR TESTING RAISING cx_static_check.
    METHODS ad_hoc FOR TESTING RAISING cx_static_check.
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
         span_id  = 'FAE688807A3538EE'
         kind     = zif_otlp_model_trace=>gc_span_kind-server ) ) ) ) ) ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0A221220121E0A108A0BFA1BD9115897351A72440FB1F7BB1208FAE688807A3538EE3002' ).
  ENDMETHOD.

  METHOD encode05.
    DATA(lv_hex) = mo_cut->encode( VALUE #( (
       scope_spans = VALUE #( (
       spans = VALUE #( ( VALUE #(
         start_time_unix_nano = 1651589819000000000 ) ) ) ) ) ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0A0D120B120939008E259C30A0EB16' ).
  ENDMETHOD.

  METHOD encode06.
    DATA(lv_hex) = mo_cut->encode( VALUE #( (
       scope_spans = VALUE #( (
       spans = VALUE #( ( VALUE #(
         status = VALUE #( code = zif_otlp_model_trace=>gc_status_code-ok ) ) ) ) ) ) ) ) ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0A081206120472021801' ).
  ENDMETHOD.

  METHOD ad_hoc.

    DATA lv_unix_start TYPE int8.
    DATA lv_unix_end   TYPE int8.

    lv_unix_start = zcl_otlp_util=>get_unix_time_nano( ).
* 123ms
    lv_unix_end = lv_unix_start + 123000000.

    DATA(lv_hex) = mo_cut->encode( VALUE #( (
      resource    = VALUE #( attributes = VALUE #(
        ( VALUE #( key   = 'service.name'
                   value = VALUE #( string_value = 'FooTestName4' ) ) )
        ( VALUE #( key   = 'deployment.environment'
                   value = VALUE #( string_value = 'FooEnv' ) ) )
      ) )
      scope_spans = VALUE #( (
        spans = VALUE #( ( VALUE #(
          trace_id             = '3A0BFA1BD9115897351A72440FB1F7BB'
          span_id              = '3AE688807A3538EE'
          name                 = 'spanName1'
          start_time_unix_nano = lv_unix_start
          end_time_unix_nano   = lv_unix_end ) ) ) ) ) ) ) ).

    cl_abap_unit_assert=>assert_not_initial( lv_hex ).
  ENDMETHOD.

ENDCLASS.

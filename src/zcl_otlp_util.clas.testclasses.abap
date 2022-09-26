CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.
  PRIVATE SECTION.
    METHODS get_unix_time_nano FOR TESTING RAISING cx_static_check.
    METHODS generate_trace_id FOR TESTING RAISING cx_static_check.
    METHODS generate_span_id FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD get_unix_time_nano.
    cl_abap_unit_assert=>assert_not_initial( zcl_otlp_util=>get_unix_time_nano( ) ).
  ENDMETHOD.

  METHOD generate_trace_id.
    cl_abap_unit_assert=>assert_not_initial( zcl_otlp_util=>generate_trace_id( ) ).
  ENDMETHOD.

  METHOD generate_span_id.
    cl_abap_unit_assert=>assert_not_initial( zcl_otlp_util=>generate_span_id( ) ).
  ENDMETHOD.

ENDCLASS.

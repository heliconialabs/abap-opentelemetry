CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_otlp_logs.
    METHODS setup.
    METHODS encode01 FOR TESTING RAISING cx_static_check.
    METHODS encode02 FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD encode01.

    DATA(lv_hex) = zcl_otlp_logs=>encode( VALUE #(
      resource_logs = VALUE #( ( schema_url = 'hello_world' ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0A0D1A0B68656C6C6F5F776F726C64' ).

  ENDMETHOD.

  METHOD encode02.

    DATA(lv_hex) = zcl_otlp_logs=>encode( VALUE #(
      resource_logs = VALUE #( (
        scope_logs = VALUE #( (
          log_records = VALUE #( (
            time_unix_nano          = zcl_otlp_util=>get_unix_time_nano( )
            observed_time_unix_nano = zcl_otlp_util=>get_unix_time_nano( )
            severity_number         = zif_otlp_model_logs=>gc_severity_number-severity_number_warn
            severity_text           = 'severity text'
            body-string_value       = 'body text'
       ) ) ) ) ) ) ) ).

    cl_abap_unit_assert=>assert_not_initial( lv_hex ).

  ENDMETHOD.

ENDCLASS.

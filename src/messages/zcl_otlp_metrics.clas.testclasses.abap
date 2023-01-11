CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.
  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_otlp_metrics.
    METHODS setup.
    METHODS encode FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD encode.

    DATA(lv_hex) = mo_cut->encode_metrics( VALUE #(
      resource_metrics = VALUE #( (
      scope_metrics = VALUE #( (
      metrics = VALUE #( (
      name        = 'hello'
      description = 'world'
      unit        = 'unit'
      sum         = VALUE #(
        data_points             = VALUE #( (
          time_unix_nano = zcl_otlp_util=>get_unix_time_nano( )
          as_int         = 5
        ) )
        aggregation_temporality = zif_otlp_model_metrics=>gc_aggregation_temporality-cumulative
        is_monotonic            = abap_false
      ) ) ) ) ) ) ) ) ).

    cl_abap_unit_assert=>assert_not_initial( lv_hex ).

  ENDMETHOD.

ENDCLASS.

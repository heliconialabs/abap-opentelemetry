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

    mo_cut->encode( VALUE #( ) ).

  ENDMETHOD.

ENDCLASS.

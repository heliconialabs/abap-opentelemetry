CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.
  PUBLIC SECTION.
    INTERFACES zif_otlp_span_processor.
  PRIVATE SECTION.
    METHODS trace FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD zif_otlp_span_processor~on_end.
* todo
  ENDMETHOD.

  METHOD trace.

    DATA(lo_cut) = NEW zcl_otlp_tracer_provider( ).
    lo_cut->add_span_processor( me ).

    DATA(lo_span) = lo_cut->get_tracer( 'tracerName' )->start_span(
      iv_name = 'spanName'
      iv_kind = zif_otlp_model_trace=>gc_span_kind-producer ).

    lo_span->end( ).

  ENDMETHOD.

ENDCLASS.

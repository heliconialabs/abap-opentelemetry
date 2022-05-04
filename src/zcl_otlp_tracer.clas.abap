CLASS zcl_otlp_tracer DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS start_span
      IMPORTING
        !iv_name       TYPE string
        !kind          TYPE zif_otlp_model_trace=>ty_span-kind
        !attributes    TYPE zif_otlp_model_trace=>ty_span-attributes
        !links         TYPE zif_otlp_model_trace=>ty_span-links
        !start_time    TYPE zif_otlp_model_trace=>ty_span-start_time_unix_nano
      RETURNING
        VALUE(ro_span) TYPE REF TO zcl_otlp_span .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OTLP_TRACER IMPLEMENTATION.


  METHOD start_span.
  ENDMETHOD.
ENDCLASS.

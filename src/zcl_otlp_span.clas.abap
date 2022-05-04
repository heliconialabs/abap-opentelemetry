CLASS zcl_otlp_span DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        !iv_name    TYPE string
        !kind       TYPE zif_otlp_model_trace=>ty_span-kind
        !attributes TYPE zif_otlp_model_trace=>ty_span-attributes
        !links      TYPE zif_otlp_model_trace=>ty_span-links
        !start_time TYPE zif_otlp_model_trace=>ty_span-start_time_unix_nano.

    METHODS add_event IMPORTING is_event TYPE zif_otlp_model_trace=>ty_event.
    METHODS add_link IMPORTING is_link TYPE zif_otlp_model_trace=>ty_link.
    METHODS set_status .
    METHODS end
      IMPORTING
        !iv_end_time TYPE zif_otlp_model_trace=>ty_span-end_time_unix_nano OPTIONAL .

  PROTECTED SECTION.
    DATA ms_data TYPE zif_otlp_model_trace=>ty_span.
ENDCLASS.



CLASS ZCL_OTLP_SPAN IMPLEMENTATION.


  METHOD add_event.
  ENDMETHOD.


  METHOD add_link.
  ENDMETHOD.


  METHOD constructor.
  ENDMETHOD.


  METHOD end.
  ENDMETHOD.


  METHOD set_status.
  ENDMETHOD.
ENDCLASS.

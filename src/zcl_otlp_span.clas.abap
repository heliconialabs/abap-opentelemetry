CLASS zcl_otlp_span DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS set_attributes
      IMPORTING
        attributes TYPE zif_otlp_model_trace=>ty_span-attributes.
    METHODS add_event .
    METHODS set_status .
    METHODS update_name .
    METHODS end
      IMPORTING
        !iv_end_time TYPE zif_otlp_model_trace=>ty_span-end_time_unix_nano OPTIONAL .
ENDCLASS.



CLASS ZCL_OTLP_SPAN IMPLEMENTATION.


  METHOD add_event.
  ENDMETHOD.


  METHOD end.
  ENDMETHOD.


  METHOD set_attributes.
  ENDMETHOD.


  METHOD set_status.
  ENDMETHOD.


  METHOD update_name.
  ENDMETHOD.
ENDCLASS.

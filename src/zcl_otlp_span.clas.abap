CLASS zcl_otlp_span DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry

    METHODS constructor
      IMPORTING
        !iv_name       TYPE zif_otlp_model_trace=>ty_span-name
        !iv_kind       TYPE zif_otlp_model_trace=>ty_span-kind
        !iv_start_time TYPE zif_otlp_model_trace=>ty_span-start_time_unix_nano OPTIONAL .
    METHODS add_event
      IMPORTING
        !is_event TYPE zif_otlp_model_trace=>ty_event .
    METHODS add_link
      IMPORTING
        !is_link TYPE zif_otlp_model_trace=>ty_link .
    METHODS set_status
      IMPORTING
        !is_status TYPE zif_otlp_model_trace=>ty_status.
    METHODS end
      IMPORTING
        !iv_end_time TYPE zif_otlp_model_trace=>ty_span-end_time_unix_nano OPTIONAL .
  PROTECTED SECTION.
    DATA ms_data TYPE zif_otlp_model_trace=>ty_span.
ENDCLASS.



CLASS ZCL_OTLP_SPAN IMPLEMENTATION.


  METHOD add_event.
    APPEND is_event TO ms_data-events.
  ENDMETHOD.


  METHOD add_link.
    APPEND is_link TO ms_data-links.
  ENDMETHOD.


  METHOD constructor.
* todo, add method "record_exception", https://opentelemetry.io/docs/reference/specification/trace/api/#record-exception
* todo, set span_id & trace_id ?
    ms_data = VALUE #(
      name = iv_name
      kind = iv_kind ).

    IF iv_start_time IS INITIAL.
      ms_data-start_time_unix_nano = zcl_otlp_util=>get_unix_time_nano( ).
    ELSE.
      ms_data-start_time_unix_nano = iv_start_time.
    ENDIF.

  ENDMETHOD.


  METHOD end.

    IF iv_end_time IS INITIAL.
      ms_data-end_time_unix_nano = zcl_otlp_util=>get_unix_time_nano( ).
    ELSE.
      ms_data-end_time_unix_nano = iv_end_time.
    ENDIF.

* todo, call processors from provider

  ENDMETHOD.


  METHOD set_status.
    ms_data-status = is_status.
  ENDMETHOD.
ENDCLASS.

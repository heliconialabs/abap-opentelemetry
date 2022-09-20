CLASS zcl_otlp_tracer DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
    METHODS start_span
      IMPORTING
        !iv_name       TYPE zif_otlp_model_trace=>ty_span-name
        !iv_kind       TYPE zif_otlp_model_trace=>ty_span-kind
        !iv_start_time TYPE zif_otlp_model_trace=>ty_span-start_time_unix_nano OPTIONAL
      RETURNING
        VALUE(ro_span) TYPE REF TO zcl_otlp_span .

    METHODS constructor
      IMPORTING
        iv_name       TYPE zif_otlp_model_common=>ty_instrumentation_scope-name
        iv_version    TYPE zif_otlp_model_common=>ty_instrumentation_scope-version OPTIONAL
        iv_schema_url TYPE zif_otlp_model_trace=>ty_scope_spans-schema_url OPTIONAL.
  PROTECTED SECTION.
    DATA: BEGIN OF ms_data,
            scope      TYPE zif_otlp_model_common=>ty_instrumentation_scope,
            schema_url TYPE string,
          END OF ms_data.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_otlp_tracer IMPLEMENTATION.


  METHOD constructor.
    ms_data = VALUE #(
      scope      = VALUE #(
        name    = iv_name
        version = iv_version )
      schema_url = iv_schema_url ).
  ENDMETHOD.


  METHOD start_span.

    ro_span = NEW #(
      iv_name       = iv_name
      iv_kind       = iv_kind
      iv_start_time = iv_start_time ).

  ENDMETHOD.
ENDCLASS.

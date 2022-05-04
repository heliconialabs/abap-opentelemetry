CLASS zcl_otlp_tracer_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry

    METHODS get_tracer
      IMPORTING
        !iv_name         TYPE string
        !iv_version      TYPE string OPTIONAL
        !iv_schema_url   TYPE string OPTIONAL
      RETURNING
        VALUE(ro_tracer) TYPE REF TO zcl_otlp_tracer .

    METHODS add_span_processor
      IMPORTING ii_span_processor TYPE REF TO zif_otlp_span_processor.
  PROTECTED SECTION.
    DATA mt_processors TYPE STANDARD TABLE OF REF TO zif_otlp_span_processor.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OTLP_TRACER_PROVIDER IMPLEMENTATION.


  METHOD add_span_processor.
    APPEND ii_span_processor TO mt_processors.
  ENDMETHOD.


  METHOD get_tracer.
    ro_tracer = NEW #(
      iv_name       = iv_name
      iv_version    = iv_version
      iv_schema_url = iv_schema_url ).
  ENDMETHOD.
ENDCLASS.

CLASS zcl_otlp_tracer_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS get_tracer
      IMPORTING
        !iv_name         TYPE string
        !iv_version      TYPE string OPTIONAL
        !iv_schema_url   TYPE string OPTIONAL
      RETURNING
        VALUE(ro_tracer) TYPE REF TO zcl_otlp_tracer .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OTLP_TRACER_PROVIDER IMPLEMENTATION.


  METHOD get_tracer.
  ENDMETHOD.
ENDCLASS.

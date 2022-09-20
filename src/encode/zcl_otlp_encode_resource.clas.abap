CLASS zcl_otlp_encode_resource DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
    CLASS-METHODS encode_resource
      IMPORTING
        !is_resource  TYPE zif_otlp_model_resource=>ty_resource
      RETURNING
        VALUE(rv_hex) TYPE xstring .
  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OTLP_ENCODE_RESOURCE IMPLEMENTATION.


  METHOD encode_resource.



  ENDMETHOD.
ENDCLASS.

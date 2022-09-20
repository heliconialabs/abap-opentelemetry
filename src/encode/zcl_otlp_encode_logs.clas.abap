CLASS zcl_otlp_encode_logs DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
    CLASS-METHODS encode
      IMPORTING
        !is_logs_data TYPE zif_otlp_model_logs=>ty_logs_data
      RETURNING
        VALUE(rv_hex) TYPE xstring .
  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OTLP_ENCODE_LOGS IMPLEMENTATION.


  METHOD encode.

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
    DATA(sdf) = is_logs_data.
    CLEAR sdf.

    rv_hex = lo_stream->get( ).

  ENDMETHOD.
ENDCLASS.

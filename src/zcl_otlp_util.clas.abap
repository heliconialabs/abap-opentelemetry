CLASS zcl_otlp_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
    CLASS-METHODS get_unix_time_nano
      RETURNING
        VALUE(rv_nano) TYPE int8 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OTLP_UTIL IMPLEMENTATION.


  METHOD get_unix_time_nano.

    DATA lv_epoch TYPE timestampl.
    DATA lv_start TYPE timestampl.
    DATA lv_result TYPE timestampl.

* https://www.epochconverter.com
    GET TIME STAMP FIELD lv_start.
    lv_epoch = '19700101000000'.

    lv_result = cl_abap_tstmp=>subtract(
      tstmp1 = lv_start
      tstmp2 = lv_epoch ).
    rv_nano = lv_result * 1000000000.

  ENDMETHOD.
ENDCLASS.

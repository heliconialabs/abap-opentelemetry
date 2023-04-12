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
    CLASS-METHODS to_xstring
      IMPORTING
        !iv_string        TYPE string
      RETURNING
        VALUE(rv_xstring) TYPE xstring .
    CLASS-METHODS from_xstring
      IMPORTING
        iv_xstring TYPE xstring
      RETURNING
        VALUE(rv_string)        TYPE string.
    CLASS-METHODS generate_trace_id
      RETURNING
        VALUE(rv_xstring) TYPE xstring.
    CLASS-METHODS generate_span_id
      RETURNING
        VALUE(rv_xstring) TYPE xstring.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_otlp_util IMPLEMENTATION.


  METHOD generate_span_id.

* todo, steampunk compatibility?

    CALL FUNCTION 'GENERATE_SEC_RANDOM'
      EXPORTING
        length         = 8
      IMPORTING
        random         = rv_xstring
      EXCEPTIONS
        invalid_length = 1
        no_memory      = 2
        internal_error = 3
        OTHERS         = 4.
    ASSERT sy-subrc = 0.

  ENDMETHOD.


  METHOD generate_trace_id.

* todo, steampunk compatibility? IF_SYSTEM_UUID_STATIC=>CREATE_UUID_X16 ?

    CALL FUNCTION 'GENERATE_SEC_RANDOM'
      EXPORTING
        length         = 16
      IMPORTING
        random         = rv_xstring
      EXCEPTIONS
        invalid_length = 1
        no_memory      = 2
        internal_error = 3
        OTHERS         = 4.
    ASSERT sy-subrc = 0.

  ENDMETHOD.


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

  METHOD from_xstring.

    DATA lo_conv TYPE REF TO object.

    TRY.
        CALL METHOD ('CL_ABAP_CONV_CODEPAGE')=>create_in
          RECEIVING
            instance = lo_conv.

        CALL METHOD lo_conv->('IF_ABAP_CONV_IN~CONVERT')
          EXPORTING
            source = iv_xstring
          RECEIVING
            result = rv_string.
      CATCH cx_sy_dyn_call_illegal_class.
        DATA(lv_conv_in_class) = 'CL_ABAP_CONV_IN_CE'.
        CALL METHOD (lv_conv_in_class)=>create
          EXPORTING
            encoding = 'UTF-8'
          RECEIVING
            conv     = lo_conv.

        CALL METHOD lo_conv->('CONVERT')
          EXPORTING
            input = iv_xstring
          IMPORTING
            data  = rv_string.
    ENDTRY.

  ENDMETHOD.

  METHOD to_xstring.

* argh, steampunk compatibility

    DATA lo_conv TYPE REF TO object.

    TRY.
        CALL METHOD ('CL_ABAP_CONV_CODEPAGE')=>create_out
          RECEIVING
            instance = lo_conv.

        CALL METHOD lo_conv->('IF_ABAP_CONV_OUT~CONVERT')
          EXPORTING
            source = iv_string
          RECEIVING
            result = rv_xstring.
      CATCH cx_sy_dyn_call_illegal_class.
        DATA(lv_conv_out_class) = 'CL_ABAP_CONV_OUT_CE'.
* workaround for not triggering static analysis error in Steampunk
        CALL METHOD (lv_conv_out_class)=>create
          EXPORTING
            encoding = 'UTF-8'
          RECEIVING
            conv     = lo_conv.

        CALL METHOD lo_conv->('CONVERT')
          EXPORTING
            data   = iv_string
          IMPORTING
            buffer = rv_xstring.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.

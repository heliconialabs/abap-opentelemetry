CLASS zcl_otlp_encode_metrics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
    CLASS-METHODS encode_metrics
      IMPORTING
        !is_metrics_data TYPE zif_otlp_model_metrics=>ty_metrics_data
      RETURNING
        VALUE(rv_hex)    TYPE xstring .

  PROTECTED SECTION.
    CLASS-METHODS exemplar
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_exemplar
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS value_at_quantile
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_value_at_quantile
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS summary_data_point
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_summary_data_point
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS number_data_point
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_number_data_point
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS gauge
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_gauge
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS sum
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_sum
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS histogram_data_point
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_histogram_data_point
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS histogram
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_histogram
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS buckets
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_buckets
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS exponential_histogram_data
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_exponential_histogram_data
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS exponential_histogram
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_exponential_histogram
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS summary
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_summary
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS metric
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_metric
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS scope_metrics
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_scope_metrics
      RETURNING
        VALUE(rv_hex) TYPE xstring.

    CLASS-METHODS resource_metrics
      IMPORTING
        !is_data      TYPE zif_otlp_model_metrics=>ty_resource_metrics
      RETURNING
        VALUE(rv_hex) TYPE xstring.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OTLP_ENCODE_METRICS IMPLEMENTATION.


  METHOD buckets.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 1
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
    lo_stream->encode_varint( is_data-offset ).

    LOOP AT is_data-bucket_counts INTO DATA(lv_int).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( lv_int ).
    ENDLOOP.

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD encode_metrics.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    LOOP AT is_metrics_data-resource_metrics INTO DATA(ls_resurce_metrics).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( resource_metrics( ls_resurce_metrics ) ).
    ENDLOOP.

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD exemplar.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).


    LOOP AT is_data-filtered_attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
      field_number = 7
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_encode_common=>encode_key_value( ls_attribute ) ).
    ENDLOOP.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-time_unix_nano ).

* todo
*           as_double           TYPE f,
*           as_int              TYPE i,

    IF is_data-span_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 4
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_data-span_id ).
    ENDIF.

    IF is_data-trace_id IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 5
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( is_data-trace_id ).
    ENDIF.

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD exponential_histogram.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           data_points TYPE STANDARD TABLE OF ty_exponential_histogram_data WITH EMPTY KEY,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD exponential_histogram_data.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           attributes           TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
*           start_time_unix_nano TYPE int8,
*           time_unix_nano       TYPE int8,
*           count                TYPE i,
*           sum                  TYPE f,
*           scale                TYPE i,
*           zero_count           TYPE i,
*           positive             TYPE ty_buckets,
*           negative             TYPE ty_buckets,
*           flags                TYPE i,
*           exemplars            TYPE STANDARD TABLE OF ty_exemplar WITH EMPTY KEY,
*           min                  TYPE f,
*           max                  TYPE f,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD gauge.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           data_points TYPE STANDARD TABLE OF ty_number_data_point WITH EMPTY KEY,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD histogram.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           data_points             TYPE STANDARD TABLE OF ty_histogram_data_point WITH EMPTY KEY,
*           aggregation_temporality TYPE i,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD histogram_data_point.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           attributes           TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
*           start_time_unix_nano TYPE int8,
*           time_unix_nano       TYPE int8,
*           count                TYPE i,
*           sum                  TYPE f,
*           bucket_counts        TYPE STANDARD TABLE OF i WITH EMPTY KEY,
*           explicit_bounds      TYPE STANDARD TABLE OF f WITH EMPTY KEY,
*           exemplars            TYPE STANDARD TABLE OF ty_exemplar WITH EMPTY KEY,
*           flags                TYPE i,
*           min                  TYPE f,
*           max                  TYPE f,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD metric.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           name                  TYPE string,
*           description           TYPE string,
*           unit                  TYPE string,
*           gauge                 TYPE ty_gauge,
*           sum                   TYPE ty_sum,
*           historgram            TYPE ty_histogram,
*           exponential_histogram TYPE ty_exponential_histogram,
*           summary               TYPE ty_summary,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD number_data_point.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           attributes           TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
*           start_time_unix_nano TYPE int8,
*           time_unix_nano       TYPE int8,
*           as_double            TYPE f,
*           as_int               TYPE i,
*           exemplars            TYPE STANDARD TABLE OF ty_exemplar WITH EMPTY KEY,
*           flags                TYPE i,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD resource_metrics.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           resource      TYPE zif_otlp_model_resource=>ty_resource,
*           scope_metrics TYPE STANDARD TABLE OF ty_scope_metrics WITH EMPTY KEY,
*           schema_url    TYPE string,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD scope_metrics.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           scope      TYPE zif_otlp_model_common=>ty_instrumentation_scope,
*           metrics    TYPE STANDARD TABLE OF ty_metric WITH EMPTY KEY,
*           schema_url TYPE string,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD sum.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           data_points             TYPE STANDARD TABLE OF ty_number_data_point WITH EMPTY KEY,
*           aggregation_temporality TYPE i,
*           is_monotonic            TYPE abap_bool,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD summary.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           data_points TYPE STANDARD TABLE OF ty_summary_data_point WITH EMPTY KEY,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD summary_data_point.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           attributes           TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
*           start_time_unix_nano TYPE int8,
*           time_unix_nano       TYPE int8,
*           count                TYPE i,
*           sum                  TYPE f,
*           quantile_values      TYPE STANDARD TABLE OF ty_value_at_quantile WITH EMPTY KEY,
*           flags                TYPE i,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD value_at_quantile.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

* todo
*           quantile TYPE f,
*           value    TYPE f,

    rv_hex = lo_stream->get( ).
  ENDMETHOD.
ENDCLASS.

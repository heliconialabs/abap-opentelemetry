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

    IF is_data-as_double IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_double( is_data-as_double ).
    ELSE.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 6
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_data-as_int ).
    ENDIF.

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

    LOOP AT is_data-data_points INTO DATA(ls_data_point).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( exponential_histogram_data( ls_data_point ) ).
    ENDLOOP.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
    lo_stream->encode_varint( is_data-aggregation_temporality ).

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD exponential_histogram_data.
* message ExponentialHistogramDataPoint

    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    LOOP AT is_data-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_encode_common=>encode_key_value( ls_attribute ) ).
    ENDLOOP.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-start_time_unix_nano ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 3
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-time_unix_nano ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 4
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-count ).

    IF is_data-sum IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 5
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_double( is_data-sum ).
    ENDIF.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 6
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
    lo_stream->encode_varint( is_data-scale ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 7
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-zero_count ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 8
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( buckets( is_data-positive ) ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 9
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( buckets( is_data-negative ) ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 10
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
    lo_stream->encode_varint( is_data-flags ).

    LOOP AT is_data-exemplars INTO DATA(ls_exemplar).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 11
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( exemplar( ls_exemplar ) ).
    ENDLOOP.

    IF is_data-min IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 12
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_double( is_data-min ).
    ENDIF.

    IF is_data-max IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 13
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_double( is_data-max ).
    ENDIF.

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD gauge.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    LOOP AT is_data-data_points INTO DATA(ls_number_data_point).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( number_data_point( ls_number_data_point ) ).
    ENDLOOP.

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD histogram.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    LOOP AT is_data-data_points INTO DATA(ls_histogram_data_point).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( histogram_data_point( ls_histogram_data_point ) ).
    ENDLOOP.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
    lo_stream->encode_varint( is_data-aggregation_temporality ).

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD histogram_data_point.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    LOOP AT is_data-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_encode_common=>encode_key_value( ls_attribute ) ).
    ENDLOOP.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-start_time_unix_nano ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 3
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-time_unix_nano ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 4
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-count ).

    IF is_data-sum IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 5
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_double( is_data-sum ).
    ENDIF.

    LOOP AT is_data-bucket_counts INTO DATA(lv_bucket_count).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 6
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_fixed64( lv_bucket_count ).
    ENDLOOP.

    LOOP AT is_data-explicit_bounds INTO DATA(lv_explicit_bound).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 7
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_double( lv_explicit_bound ).
    ENDLOOP.

    LOOP AT is_data-exemplars INTO DATA(ls_exemplar).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 8
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( exemplar( ls_exemplar ) ).
    ENDLOOP.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 10
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
    lo_stream->encode_varint( is_data-flags ).

    IF is_data-min IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 11
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_double( is_data-min ).
    ENDIF.

    IF is_data-max IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 12
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_double( is_data-max ).
    ENDIF.

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD metric.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 1
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_data-name ) ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_data-description ) ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 3
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_data-unit ) ).

    IF is_data-gauge IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 5
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( gauge( is_data-gauge ) ).
    ELSEIF is_data-sum IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 7
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( sum( is_data-sum ) ).
    ELSEIF is_data-histogram IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 9
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( histogram( is_data-histogram ) ).
    ELSEIF is_data-exponential_histogram IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 10
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( exponential_histogram( is_data-exponential_histogram ) ).
    ELSE.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 11
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( summary( is_data-summary ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD number_data_point.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    LOOP AT is_data-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 7
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_encode_common=>encode_key_value( ls_attribute ) ).
    ENDLOOP.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-start_time_unix_nano ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 3
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-time_unix_nano ).

    IF is_data-as_double IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 4
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
      lo_stream->encode_double( is_data-as_double ).
    ELSE.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 6
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
      lo_stream->encode_varint( is_data-as_int ).
    ENDIF.

    LOOP AT is_data-exemplars INTO DATA(ls_exemplar).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 5
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( exemplar( ls_exemplar ) ).
    ENDLOOP.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 8
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
    lo_stream->encode_varint( is_data-flags ).

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD resource_metrics.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 1
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( zcl_otlp_encode_resource=>encode_resource( is_data-resource ) ).

    LOOP AT is_data-scope_metrics INTO DATA(ls_scope_metrics).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( scope_metrics( ls_scope_metrics ) ).
    ENDLOOP.

    IF is_data-schema_url IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_data-schema_url ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD scope_metrics.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 1
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
    lo_stream->encode_delimited( zcl_otlp_encode_common=>encode_instrumentation_scope( is_data-scope ) ).

    LOOP AT is_data-metrics INTO DATA(ls_metric).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 2
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( metric( ls_metric ) ).
    ENDLOOP.

    IF is_data-schema_url IS NOT INITIAL.
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 3
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_util=>to_xstring( is_data-schema_url ) ).
    ENDIF.

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD sum.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    LOOP AT is_data-data_points INTO DATA(ls_data_point).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( number_data_point( ls_data_point ) ).
    ENDLOOP.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
    lo_stream->encode_varint( is_data-aggregation_temporality ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 3
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
    lo_stream->encode_bool( is_data-is_monotonic ).

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD summary.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    LOOP AT is_data-data_points INTO DATA(ls_data).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 1
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( summary_data_point( ls_data ) ).
    ENDLOOP.

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD summary_data_point.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    LOOP AT is_data-attributes INTO DATA(ls_attribute).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 7
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( zcl_otlp_encode_common=>encode_key_value( ls_attribute ) ).
    ENDLOOP.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-start_time_unix_nano ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 3
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-time_unix_nano ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 4
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_fixed64( is_data-count ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 5
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_double( is_data-sum ).

    LOOP AT is_data-quantile_values INTO DATA(ls_value).
      lo_stream->encode_field_and_type( VALUE #(
        field_number = 6
        wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-length_delimited ) ).
      lo_stream->encode_delimited( value_at_quantile( ls_value ) ).
    ENDLOOP.

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 8
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-varint ) ).
    lo_stream->encode_varint( is_data-flags ).

    rv_hex = lo_stream->get( ).
  ENDMETHOD.


  METHOD value_at_quantile.
    DATA(lo_stream) = NEW zcl_otlp_protobuf_stream( ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 1
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_double( is_data-quantile ).

    lo_stream->encode_field_and_type( VALUE #(
      field_number = 2
      wire_type    = zcl_otlp_protobuf_stream=>gc_wire_type-bit64 ) ).
    lo_stream->encode_double( is_data-quantile ).

    rv_hex = lo_stream->get( ).
  ENDMETHOD.
ENDCLASS.

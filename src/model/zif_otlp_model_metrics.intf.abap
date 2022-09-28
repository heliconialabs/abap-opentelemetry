INTERFACE zif_otlp_model_metrics
  PUBLIC .

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
* this file corresponds to
* https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/metrics/v1/metrics.proto

*message Exemplar {
  TYPES: BEGIN OF ty_exemplar,
           filtered_attributes TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
           time_unix_nano      TYPE int8,
           as_double           TYPE f,
           as_int              TYPE i,
           span_id             TYPE xstring,
           trace_id            TYPE xstring,
         END OF ty_exemplar.

* message ValueAtQuantile {
  TYPES: BEGIN OF ty_value_at_quantile,
           quantile TYPE f,
           value    TYPE f,
         END OF ty_value_at_quantile.

*message SummaryDataPoint {
  TYPES: BEGIN OF ty_summary_data_point,
           attributes           TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
           start_time_unix_nano TYPE int8,
           time_unix_nano       TYPE int8,
           count                TYPE int8,
           sum                  TYPE f,
           quantile_values      TYPE STANDARD TABLE OF ty_value_at_quantile WITH EMPTY KEY,
           flags                TYPE i,
         END OF ty_summary_data_point.

*message NumberDataPoint {
  TYPES: BEGIN OF ty_number_data_point,
           attributes           TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
           start_time_unix_nano TYPE int8,
           time_unix_nano       TYPE int8,
           as_double            TYPE f,
           as_int               TYPE i,
           exemplars            TYPE STANDARD TABLE OF ty_exemplar WITH EMPTY KEY,
           flags                TYPE i,
         END OF ty_number_data_point.

*message Gauge {
  TYPES: BEGIN OF ty_gauge,
           data_points TYPE STANDARD TABLE OF ty_number_data_point WITH EMPTY KEY,
         END OF ty_gauge.

*message Sum {
  TYPES: BEGIN OF ty_sum,
           data_points             TYPE STANDARD TABLE OF ty_number_data_point WITH EMPTY KEY,
           aggregation_temporality TYPE i,
           is_monotonic            TYPE abap_bool,
         END OF ty_sum.

*message HistogramDataPoint {
  TYPES: BEGIN OF ty_histogram_data_point,
           attributes           TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
           start_time_unix_nano TYPE int8,
           time_unix_nano       TYPE int8,
           count                TYPE int8,
           sum                  TYPE f,
           bucket_counts        TYPE STANDARD TABLE OF int8 WITH EMPTY KEY,
           explicit_bounds      TYPE STANDARD TABLE OF f WITH EMPTY KEY,
           exemplars            TYPE STANDARD TABLE OF ty_exemplar WITH EMPTY KEY,
           flags                TYPE i,
           min                  TYPE f,
           max                  TYPE f,
         END OF ty_histogram_data_point.

*message Histogram {
  TYPES: BEGIN OF ty_histogram,
           data_points             TYPE STANDARD TABLE OF ty_histogram_data_point WITH EMPTY KEY,
           aggregation_temporality TYPE i,
         END OF ty_histogram.

*message Buckets {
  TYPES: BEGIN OF ty_buckets,
           offset        TYPE i,
           bucket_counts TYPE STANDARD TABLE OF i WITH EMPTY KEY,
         END OF ty_buckets.

*message ExponentialHistogramDataPoint {
  TYPES: BEGIN OF ty_exponential_histogram_data,
           attributes           TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
           start_time_unix_nano TYPE int8,
           time_unix_nano       TYPE int8,
           count                TYPE int8,
           sum                  TYPE f,
           scale                TYPE i,
           zero_count           TYPE int8,
           positive             TYPE ty_buckets,
           negative             TYPE ty_buckets,
           flags                TYPE i,
           exemplars            TYPE STANDARD TABLE OF ty_exemplar WITH EMPTY KEY,
           min                  TYPE f,
           max                  TYPE f,
         END OF ty_exponential_histogram_data.

*message ExponentialHistogram {
  TYPES: BEGIN OF ty_exponential_histogram,
           data_points             TYPE STANDARD TABLE OF ty_exponential_histogram_data WITH EMPTY KEY,
           aggregation_temporality TYPE i,
         END OF ty_exponential_histogram.

*message Summary {
  TYPES: BEGIN OF ty_summary,
           data_points TYPE STANDARD TABLE OF ty_summary_data_point WITH EMPTY KEY,
         END OF ty_summary.

*enum AggregationTemporality {
  CONSTANTS: BEGIN OF gc_aggregation_temporality,
               tempraily_unspecified  TYPE i VALUE 0,
               temporality_delta      TYPE i VALUE 1,
               temporality_cumulative TYPE i VALUE 2,
             END OF gc_aggregation_temporality.

*enum DataPointFlags {
  CONSTANTS: BEGIN OF gc_data_point_flags,
               flag_none              TYPE i VALUE 0,
               flag_no_recorded_value TYPE i VALUE 1,
             END OF gc_data_point_flags.

*message Metric {
  TYPES: BEGIN OF ty_metric,
           name                  TYPE string,
           description           TYPE string,
           unit                  TYPE string,
           gauge                 TYPE ty_gauge,
           sum                   TYPE ty_sum,
           historgram            TYPE ty_histogram,
           exponential_histogram TYPE ty_exponential_histogram,
           summary               TYPE ty_summary,
         END OF ty_metric.

*message ScopeMetrics {
  TYPES: BEGIN OF ty_scope_metrics,
           scope      TYPE zif_otlp_model_common=>ty_instrumentation_scope,
           metrics    TYPE STANDARD TABLE OF ty_metric WITH EMPTY KEY,
           schema_url TYPE string,
         END OF ty_scope_metrics.

*message ResourceMetrics {
  TYPES: BEGIN OF ty_resource_metrics,
           resource      TYPE zif_otlp_model_resource=>ty_resource,
           scope_metrics TYPE STANDARD TABLE OF ty_scope_metrics WITH EMPTY KEY,
           schema_url    TYPE string,
         END OF ty_resource_metrics.

*message MetricsData {
  TYPES: BEGIN OF ty_metrics_data,
           resource_metrics TYPE STANDARD TABLE OF ty_resource_metrics WITH EMPTY KEY,
         END OF ty_metrics_data.

ENDINTERFACE.

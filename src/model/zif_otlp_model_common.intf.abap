INTERFACE zif_otlp_model_common
  PUBLIC .


  TYPES:
* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
* this file corresponds to
* https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/common/v1/common.proto
* message AnyValue {
    BEGIN OF ty_any_value,
      string_value TYPE string,
      bool_value   TYPE abap_bool,
      int_value    TYPE i,
* out of scope
      double_value TYPE string,
* out of scope
      array_value  TYPE string,
* out of scope
      kvlist_value TYPE string,
      bytes_value  TYPE xstring,
    END OF ty_any_value .
  TYPES:
* message KeyValue {
    BEGIN OF ty_key_value,
      key   TYPE string,
      value TYPE ty_any_value,
    END OF ty_key_value .
  TYPES:
* message InstrumentationScope {
    BEGIN OF ty_instrumentation_scope,
      name    TYPE string,
      version TYPE string,
    END OF ty_instrumentation_scope .
ENDINTERFACE.

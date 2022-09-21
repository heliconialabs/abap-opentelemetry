INTERFACE zif_otlp_model_resource
  PUBLIC .

* MIT License, Copyright (c) 2022 Heliconia Labs
* https://github.com/heliconialabs/abap-opentelemetry
* this file corresponds to
* https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/resource/v1/resource.proto

  TYPES: BEGIN OF ty_resource,
           attributes               TYPE STANDARD TABLE OF zif_otlp_model_common=>ty_key_value WITH EMPTY KEY,
           dropped_attributes_count TYPE i,
         END OF ty_resource .

ENDINTERFACE.

INTERFACE zif_otlp_span_processor
  PUBLIC .

* on end of each span
* todo: inputs are the actual span and some resource/context information
  METHODS on_end.

ENDINTERFACE.

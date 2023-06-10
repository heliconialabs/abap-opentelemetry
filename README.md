# abap-opentelemetry

[OpenTelemetry Protocol (OTLP)](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/otlp.md) serialization in ABAP

- [X] Trace, [Protobuf Specification](https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/trace/v1/trace.proto)
- [X] Metrics, [Protobuf Specification](https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/metrics/v1/metrics.proto)
- [X] Logs, [Protobuf Specification](https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/logs/v1/logs.proto)

## Sending OTLP to Elastic

Elastic 8.8 and up [supports sending OTLP](https://github.com/elastic/apm-server/pull/8156) over HTTP 1.1 following [OTLP/HTTP](https://github.com/open-telemetry/opentelemetry-proto/blob/main/docs/specification.md#otlphttp).

The HTTP request format is described in [OTLP/HTTP Request](https://github.com/open-telemetry/opentelemetry-proto/blob/main/docs/specification.md#otlphttp-request)

* URL: https://apm-host/v1/traces / https://apm-host/v1/logs / https://apm-host/v1/metrics
* Method: POST
* Authorization: `|ApiKey { iv_auth }|`
* content-type: application/x-protobuf
* Body: raw protobuf encoded OTLP data
import * as proto from "./compiled";
import 'dotenv/config';
import * as https from "https";
import * as crypto from "crypto";

const trace = new proto.opentelemetry.proto.trace.v1.TracesData({
  resourceSpans: [
    {
//      resource: { attributes: [{ key: "http.status_code", value: { intValue: 200 } }] },
      scopeSpans: [{
        scope: {
          name: "scopename"
        },
        spans: [
          {
            traceId: crypto.randomBytes(16),
            spanId: crypto.randomBytes(8),
            /*
            events: [{
              name: "eventname"
            }],
            kind: proto.opentelemetry.proto.trace.v1.Span.SpanKind.SPAN_KIND_PRODUCER,
            name: "operation description",
            attributes: [{ key: "duration_ms", value: { intValue: 20 } }],
            startTimeUnixNano: new Long(new Date().getTime()).multiply(1000),
            endTimeUnixNano: new Long(new Date().getTime()).multiply(1000).add(10),
            */
          }
      }]
    }
  ]
});

const buffer = Buffer.from(proto.opentelemetry.proto.trace.v1.TracesData.encode(trace).finish());

console.log("Message:");
console.dir(buffer.toString("hex"));
console.log("\n");

/////////////////////////////////////////////////////

const options = {
  hostname: 'api.honeycomb.io',
  port: 443,
  path: '/v1/traces',
  headers: {
    'content-type': 'application/protobuf',
    'x-honeycomb-team': process.env.OTEL_KEY
  },
  method: 'POST'
};
const req = https.request(options, (res) => {
  console.log('statusCode:', res.statusCode);
  console.log('headers:', res.headers);
  res.on('data', (d) => {
    process.stdout.write(d);
  });
});
req.on('error', (e: any) => {
  console.error(e);
});
req.write(buffer);
req.end();
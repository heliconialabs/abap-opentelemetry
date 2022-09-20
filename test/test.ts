import * as proto from "./compiled";
import 'dotenv/config';
import * as https from "https";
import * as crypto from "crypto";

const log = new proto.opentelemetry.proto.logs.v1.LogsData({
  resourceLogs: [{schemaUrl: "hello_world"}]
});
const buffer = Buffer.from(proto.opentelemetry.proto.logs.v1.LogsData.encode(log).finish());
console.dir(buffer.toString("hex"));

/*
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
            events: [{
              name: "eventname"
            }],
            kind: proto.opentelemetry.proto.trace.v1.Span.SpanKind.SPAN_KIND_PRODUCER,
            name: "operation description",
            attributes: [{ key: "duration_ms", value: { intValue: 20 } }],
//            startTimeUnixNano: new Long(new Date().getTime()).multiply(1000),
  //          endTimeUnixNano: new Long(new Date().getTime()).multiply(1000).add(10),
          }
        ]
      }]
    }
  ]
});
const buffer = Buffer.from(proto.opentelemetry.proto.trace.v1.TracesData.encode(trace).finish());
console.dir(buffer.toString("hex"));
*/

/*
const buffer = Buffer.from("0A83010A440A1E0A0C736572766963652E6E616D65120E0A0C466F6F546573744E616D65340A220A166465706C6F796D656E742E656E7669726F6E6D656E7412080A06466F6F456E76123B12390A103A0BFA1BD9115897351A72440FB1F7BB12083AE688807A3538EE2A097370616E4E616D65313960C4A49679CEEB16412099F99D79CEEB16", "hex");

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
*/
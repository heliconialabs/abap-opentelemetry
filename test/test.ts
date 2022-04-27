import * as proto from "./compiled";
import 'dotenv/config';
import * as https from "https";

const trace = new proto.opentelemetry.proto.trace.v1.TracesData({
  resourceSpans: [
    {
      scopeSpans: [{
        schemaUrl: "url",
        spans: [
          {
            name: "hello"
          }
        ]
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
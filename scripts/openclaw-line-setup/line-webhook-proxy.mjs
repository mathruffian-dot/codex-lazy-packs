import http from "node:http";

const listenHost = "127.0.0.1";
const listenPort = Number(process.env.LINE_PROXY_PORT || 18790);
const upstreamHost = "127.0.0.1";
const upstreamPort = Number(process.env.OPENCLAW_GATEWAY_PORT || 18789);
const allowedPath = "/line/webhook";

const server = http.createServer((req, res) => {
  const url = new URL(req.url || "/", `http://${req.headers.host || listenHost}`);

  if (url.pathname !== allowedPath) {
    res.writeHead(404, { "content-type": "text/plain; charset=utf-8" });
    res.end("Not found");
    return;
  }

  if (req.method !== "GET" && req.method !== "POST") {
    res.writeHead(405, { "content-type": "text/plain; charset=utf-8" });
    res.end("Method not allowed");
    return;
  }

  if (req.method === "GET") {
    res.writeHead(200, { "content-type": "text/plain; charset=utf-8" });
    res.end("OK");
    return;
  }

  const headers = { ...req.headers, host: `${upstreamHost}:${upstreamPort}` };
  delete headers.connection;
  delete headers["proxy-connection"];

  const upstream = http.request(
    {
      host: upstreamHost,
      port: upstreamPort,
      method: req.method,
      path: `${allowedPath}${url.search}`,
      headers,
    },
    (upstreamRes) => {
      res.writeHead(upstreamRes.statusCode || 502, upstreamRes.headers);
      upstreamRes.pipe(res);
    },
  );

  upstream.on("error", (error) => {
    res.writeHead(502, { "content-type": "text/plain; charset=utf-8" });
    res.end(`Upstream error: ${error.message}`);
  });

  req.pipe(upstream);
});

server.listen(listenPort, listenHost, () => {
  console.log(`LINE webhook proxy listening on http://${listenHost}:${listenPort}${allowedPath}`);
});

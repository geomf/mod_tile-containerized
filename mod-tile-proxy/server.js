/*
 Copyright (c) 2015 Intel Corporation

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/
var listen_port = process.env.PORT;

var vcap_services  = JSON.parse(process.env.VCAP_SERVICES);

var target_hostname = vcap_services["user-provided"][0].credentials["mod-tile-bg-host"];
var target_port = vcap_services["user-provided"][0].credentials["mod-tile-bg-port"];

console.log("Setting up proxy to " , target_hostname, "  :" , target_port);

var http = require('http'),
    httpProxy = require('http-proxy');

//
// Create a proxy server with custom application logic
//
var proxy = httpProxy.createProxyServer({   target: {
    host: target_hostname,
    port: target_port
  },ws: true, web:true});

//
// Create your custom server and just call `proxy.web()` to proxy
// a web request to the target passed in the options
// also you can use `proxy.ws()` to proxy a websockets request
//
var server = http.createServer(function(req, res) {
  // You can define here your custom logic to handle the request
  // and then proxy the request.
  proxy.web(req, res);

});

server.on('upgrade', function (req, socket, head) {
  proxy.ws(req, socket, head);
});

console.log("Listening on port " + listen_port)
server.listen(listen_port);

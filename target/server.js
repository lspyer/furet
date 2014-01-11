// Generated by CoffeeScript 1.6.3
(function() {
  var Hapi, defaults, server;

  Hapi = require("hapi");

  defaults = {
    port: +process.env.PORT || 8000
  };

  server = new Hapi.Server(defaults.port, "0.0.0.0");

  server.route({
    method: "GET",
    path: "/{path*}",
    handler: {
      directory: {
        path: "./app",
        listing: false,
        index: true
      }
    }
  });

  server.start(function() {
    server.info.uri = process.env.HOST != null ? "http://" + process.env.HOST + ":" + process.env.PORT : server.info.uri;
    return console.log("Server started at " + server.info.uri);
  });

}).call(this);

"use strict";

const FastBootAppServer = require('fastboot-app-server');
let server = new FastBootAppServer({
  distPath: 'public'
});

server.start();

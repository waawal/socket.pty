var server, port
require('coffee-script');
server = require('./app');
port = Number(process.env.PORT) || 8080;
server.listen(port, function() {
  return console.log("Listening on port " + port);
});
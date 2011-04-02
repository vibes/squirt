/**
  * pub/sub client for arduino
   npm install redis-node
   redis must run on 6000 port
  */

var net = require('net'),
	redis = require('redis'),
	rclient = redis.createClient(6000, 'localhost');
	sys = require('sys');

//receiving command from the web interface or whatever
arduino_clients = {};

rclient.on("message", function(channel, message) {
    try {
		var command = JSON.parse(message); 
		var data;	
		if(command.type == "move") {
			data = "move " + command.data + "\n";
		} else {
			data = "fire" + "\n";
		}
		for(var client in arduino_clients) {
			arduino_clients[client].write(data);
		}
	}
	catch (SyntaxError) { 
		return false; 
	}
});

var arduino_server = net.createServer(function(stream) {
	stream.setEncoding("ascii");
	stream.on("connect", function() {
		arduino_clients[stream.remoteAddress] = stream;
	});
	stream.on("data", function(){});
	stream.on("end", function() {
		delete arduino_clients[stream.remoteAddress]
		stream.end();
	});
});
rclient.subscribe("canon_command");

arduino_server.listen(3001, "0.0.0.0")

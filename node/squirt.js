var express = require('express');
var redis = require('redis');
var app = express.createServer();
var rclient = redis.createClient(6000, "localhost");

app.get('/video', function(req, res){
  res.send("I'm some video");
});
app.post('/cmd/:type/:data?', function(req, res) {
	var command = {
		"type":null,
		"data":null
	}
	command.type = req.params.type;
	command.data = req.params.data;
	rclient.publish("canon_command",JSON.stringify(command));
	res.send(JSON.stringify({"status":"OK"}));
});

app.configure(function(){
  app.use(express.static(__dirname + '/public'));
});


app.listen(3000);
console.log('Webserver listening on port 3000')

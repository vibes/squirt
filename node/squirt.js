var express = require('express');
var app = express.createServer();

app.get('/video', function(req, res){
  res.send("I'm some video");
});

app.configure(function(){
  app.use(express.static(__dirname + '/public'));
});


app.listen(3000);
console.log('Webserver listening on port 3000')
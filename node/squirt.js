var express = require('express');
var console = require('console');
var app = express.createServer();

var serialport = require('serialport');
// alter serial port based on your setup
var arduino_client = new serialport.SerialPort("/dev/cu.usbserial-A600enOT", { 
// var arduino_client = new serialport.SerialPort("/dev/cu.usbserial-A4001ubI", { 
// var arduino_client = new serialport.SerialPort("/dev/cu.usbserial-A600euoC", { 
// var arduino_client = new serialport.SerialPort("/dev/cu.usbserial-A600enQO", { 
    baudrate: 9600
});

var chain = require('chain-gang').create({workers: 1})

app.get('/video', function(req, res){
  res.send("I'm some video");
});
app.post('/cmd/:type/:data?', function(req, res) {
  var command = {
    "type":null,
    "data":null
  },
  data = [];

  command.type = req.params.type;
  command.data = req.params.data;
  console.log(command);
  
  if(command.type == "move") {
    var coords = command.data.split(",");
    data.push("x " + coords[0] + "\n");
    if(coords.length == 2) {
      data.push("y " + coords[1] + "\n");
    }
  } else {
    data.push("f\n");
  }
  for(var i = data.length;i--;) {
    // write to client
    var thatdata = data[i];
    chain.add(function(worker){
      arduino_client.write(thatdata);
      setTimeout(function(){
        worker.finish();
      },100);
    });
    //arduino_client.write(thatdata);
  }

  res.send(JSON.stringify({"status":"OK"}));
});

app.configure(function(){
  app.use(express.static(__dirname + '/public'));
});

app.listen(3000);
console.log('Webserver listening on port 3000')

/*
  Door opener client
 
 Circuit:
 * Ethernet shield attached to pins 10, 11, 12, 13
 
 Created 2011-01-13 
 by Simon Wex
 based on Telnet client created 14 Sep 2010
 by Tom Igoe
 
 */

#include <SPI.h>
#include <Ethernet.h>

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = {0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED};
byte ip[] = {10,42,43,2};
//byte ip[] = {192,168,2,170};
// byte ip[] = {192,168,170,170};

// Enter the IP address of the server you're connecting to:
byte server[] = {10,42,43,1}; 
//byte server[] = { 192,168,2,1 }; 

// Initialize the Ethernet client library
// with the IP address and port of the server 
Client client(server, 3001);

// Here we make a buffer for reading from the server. Max command length we want is "open " + 32 = 37
// We always clear the buffer after a "\n"
int bufferIndex = 0;
char buffer[37];
const unsigned int TRIGGER_PORT = 4;
const unsigned int CONNECTED_PORT = 3;


void blink(int port, int count){
  for (int x = 0; x < count; x++){
    digitalWrite(port, HIGH);   // set the LED on
    delay(300);
    digitalWrite(port, LOW);   // set the LED off
    // If we aren't on the last of the loop...
    if (x + 1 < count){ 
      delay(300);
    }
  }
}


void connect() {
  // Blink to let the observer know we're connecting
  // It also gives the Ethernet shield a second to initialize:
  blink(CONNECTED_PORT, 3);   // blink the connected port 3 times (leaves it off)

  Serial.println("connecting...");
  if (client.connect()) {
    Serial.println("connected");
    digitalWrite(CONNECTED_PORT, HIGH);   // set the LED on
  } else {
    // if you didn't get a connection to the server:
    Serial.println("connection failed");
  }
}


void openTheDamnDoor(){
  digitalWrite(TRIGGER_PORT, HIGH);
  delay(1000);
  digitalWrite(TRIGGER_PORT, LOW);
}


void setup() {
  pinMode(TRIGGER_PORT, OUTPUT);
  pinMode(CONNECTED_PORT, OUTPUT);

  // start the Ethernet connection:
  Ethernet.begin(mac, ip);
  // start the serial library:
  Serial.begin(9600);
  connect();
}


void processCommand(){
  Serial.print("Processing Command: \"");
  Serial.print(buffer);
  Serial.println("\"");
 
  // Additional comments go here...
  if (String(buffer) == "open sesame"){
    Serial.println("Opening the door");
    openTheDamnDoor();
  } else {
    Serial.println("Unknown command.");
  }

  bufferIndex = 0;
}


void loop() {
  // if there are incoming bytes available 
  // from the server, read them and print them:
  if (client.available()) {
    char c = client.read();
    if (c == '\n'){
      buffer[bufferIndex] = '\0';
      processCommand();

    } else {
      buffer[bufferIndex] = c;
      bufferIndex++;
    }
  }

  // if the server's disconnected, reconnect
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnected...");
    client.stop();

    connect();
  }
}


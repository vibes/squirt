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
#include <Servo.h> 

#define XPIN 11
#define YPIN 9
#define CONNPIN 13
#define INFOPIN 12 
Servo xservo;
Servo yservo;

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = {0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED};
byte ip[] = {10,42,43,2};

// Enter the IP address of the server you're connecting to:
byte server[] = {10,42,43,1}; 

// Initialize the Ethernet client library
// with the IP address and port of the server 
Client client(server, 3001);

// Here we make a buffer for reading from the server. Max command length we want is "open " + 32 = 37
// We always clear the buffer after a "\n"
int bufferIndex = 0;
char buffer[20];
char command = '\0';

int counter = 0;


void blink(int port, int count){
  for (int x = 0; x < count; x++){
    digitalWrite(port, HIGH);   // set the LED on
    delay(100);
    digitalWrite(port, LOW);   // set the LED off
    // If we aren't on the last of the loop...
    if (x + 1 < count){ 
      delay(100);
    }
  }
}


void connect() {
  // Blink to let the observer know we're connecting
  // It also gives the Ethernet shield a second to initialize:
  blink(CONNPIN, 3);   // blink the connected port 3 times (leaves it off)

  counter += 1;
  //Serial.print(counter);
  //Serial.println(" connecting...");
  if (client.connect()) {
    //Serial.println("connected");
    digitalWrite(CONNPIN, HIGH);   // set the LED on
  } else {
    // if you didn't get a connection to the server:
    //Serial.println("connection failed");
  }
}


void setup() {
  pinMode(CONNPIN, OUTPUT);
  xservo.attach(XPIN);
  yservo.attach(YPIN);

  // start the Ethernet connection:
  Ethernet.begin(mac, ip);
  // start the serial library:
  //Serial.begin(9600);
  delay(1000);
  //Serial.println("inside setup...");
  connect();
}


void processCommand(char command){
  //Serial.print(counter);
  //Serial.print(" Processing Command: \"");
  //Serial.print(command);
  //Serial.print("\" with buffer: \"");
  //Serial.print(buffer);
  //Serial.println("\"");

  switch (command) {
    case 'x':
      moveX( atoi(buffer) ); 
      break;
    case 'y':
      moveY( atoi(buffer) ); 
      break;
    default:
      //Serial.print("Unknown command: ");
      //Serial.println(command);
      break;
  }
  delay(10);
}

void moveX(int pos) {
  xservo.write(pos);
  //Serial.print("moving x: ");
  //Serial.println(pos);
  digitalWrite(INFOPIN, HIGH);
}
void moveY(int pos) {
  yservo.write(pos);
  //Serial.print("moving y: ");
  //Serial.println(pos);
  digitalWrite(INFOPIN, LOW);

}


void loop() {
  // if there are incoming bytes available 
  // from the server, read them and print them:

  if (client.available()) {
    char c = client.read();

    if (c == '\n'){
      buffer[bufferIndex] = '\0';
      processCommand(command);
      buffer[0] = '\0';
      bufferIndex = 0;
      command = '\0';
    } else if (c == ' ') {
      // skip colons
    } else {
      if (command == '\0') {
        command = c;
      } else {
        buffer[bufferIndex] = c;
        bufferIndex++;
      }
    }
  }

  // if the server's disconnected, reconnect
  if (!client.connected()) {
    //Serial.println();
    //Serial.println("disconnected...");
    client.stop();

    connect();
  }
}


/*

S.Q.U.I.R.T. - The Vibes Media avian deterant system.

PINOUT

PIN 11 - X servo control
PIN  9 - Y servo control
PIN  7 - Eyes
PIN  6 - Trigger


PROTOCOL

Newline separated command strings. Each string is a command character with an optional 
integer argument. For X and Y movement, the range is 20 - 160, with 90 being center. To 
aim at 50,100 and turn on the eyes, and fire for 1.25 seconds, send 4 lines as follows:

x 50
y 100
e 1
f 1250

 */

#include <Servo.h> 

#define XPIN 11
#define YPIN 9
#define EYES 7
#define TRIGGER 6
Servo xservo;
Servo yservo;

int bufferIndex = 0;
char buffer[20];
char command = '\0';

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


void processCommand(char command){
  Serial.print("Processing Command: \"");
  Serial.print(command);
  Serial.print("\" with buffer: \"");
  Serial.print(buffer);
  Serial.println("\"");

  switch (command) {
    case 'x':
      moveX( atoi(buffer) ); 
      break;
    case 'y':
      moveY( atoi(buffer) ); 
      break;
    case 'e':
      eyes( atoi(buffer) );
      break;
    case 'f':
      fire( atoi(buffer) );
      break;
    default:
      Serial.print("Unknown command: ");
      Serial.println(command);
      break;
  }
}

void moveX(int pos) {
  xservo.write(pos);
  Serial.print("moving x: ");
  Serial.println(pos);
}
void moveY(int pos) {
  yservo.write(pos);
  Serial.print("moving y: ");
  Serial.println(pos);
}
void eyes(int val) {
  if (val > 0) {
    eyesOn();
  } else {
    eyesOff();
  }
}
void eyesOn() {
  digitalWrite(EYES, HIGH);
  Serial.println("Eyes On");
}
void eyesOff() {
  digitalWrite(EYES, LOW);
  Serial.println("Eyes Off");
}
void fire(int time) {
  Serial.print("FIRE!!!");
  digitalWrite(TRIGGER,HIGH);
  delay(time);
  digitalWrite(TRIGGER,LOW);
  Serial.println(" firing complete.");
}

void setup() {
  pinMode(EYES, OUTPUT);
  pinMode(TRIGGER, OUTPUT);

  xservo.attach(XPIN);
  yservo.attach(YPIN);

  // Start off at center/center
  xservo.write(90);	 
  yservo.write(90);	 

  // start the serial library:
  Serial.begin(9600);
  delay(1000);
  Serial.println("done with setup...");
}
void fire(){

}

void loop() {
  // if there are incoming bytes available 
  // from the server, read them and print them:

  if (Serial.available() > 0) {
    char c = Serial.read();

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
}


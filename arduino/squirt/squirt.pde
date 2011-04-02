// Squirt
#include <Servo.h> 

#define XPIN 11
#define YPIN 9
#define POT 0
Servo xservo;
Servo yservo;

int pos = 0;    // variable to store the servo position 
int sensor = 0;    // variable to store the servo position 

void setup() 
{ 
	xservo.attach(XPIN);  // x-plane
	yservo.attach(YPIN);  // y-plane
	//pinMode(POT, INPUT);
	//Serial.begin(9600); 
} 

void loop() {
	//sensor = analogRead(POT);
	//pos = map(sensor, 0, 1024, 0, 120);

	//Serial.print("sensor = ");
	//Serial.print(sensor);
	//Serial.print("\tpos = ");
	//Serial.println(pos); 

	xservo.write(30);
	yservo.write(80);
	delay(1000);
	xservo.write(120);
	yservo.write(80);
	delay(1000);
}

void a_loop() 
{ 
	for(pos = 30; pos < 60; pos += 1)  // goes from 0 degrees to 180 degrees 
	{                                  // in steps of 1 degree 
		yservo.write(pos);              // tell servo to go to position in variable 'pos' 
		delay(15);                       // waits 15ms for the servo to reach the position 
	} 
	for(pos = 60; pos>=31; pos-=1)     // goes from 180 degrees to 0 degrees 
	{                                
		xservo.write(pos);              // tell servo to go to position in variable 'pos' 
		delay(15);                       // waits 15ms for the servo to reach the position 
	} 
} 

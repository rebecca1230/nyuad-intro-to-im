/*
   INTRO TO IM

   MAR 30, 2021
   Ayush Pandey

   Using Ultrasonic Distance Sensor to build a simulation of collision-detector

   Instructions:
   The project has two modes - Manual and Automatic.
   In Manual mode, there will be no effect of the sensor. You will only see a green light fading (that means it's all upon you to control the vehicle)
   In Automatic mode, you'll see a green light if there are no collisions ahead. Otherwise, a red light will show up and buzzer will be triggered.
*/

const int buzzer = 10;    // pin for Buzzer

const int trig = 5;       // trig pin of HC-SR04
const int echo = 6;       // echo pin of HC-SR04

const int redLED = 2;           // red light for auto mode
const int autoGreenLED = 3;     // green light for auto mode
const int manualGreenLED = 9;   // green light for manual mode

int brightness = 0;       // for brightness of fading green light
int fadeAmount = 5;       // increment amount of fading green light

const int greenSwitch = A0;  // pin for switch that changes modes

bool automatic = true;      // state variable for mode

void setup() {
  // setting pin modes
  pinMode(buzzer, OUTPUT);

  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);

  pinMode(redLED, OUTPUT);
  pinMode(autoGreenLED, OUTPUT);
  pinMode(manualGreenLED, OUTPUT);

  pinMode(greenSwitch, INPUT);
}

void loop() {
  // if the switch is pressed, change mode from automatic <-> manual
  if (digitalRead(greenSwitch) == HIGH) {
    automatic = !automatic;
    delay(1000);
  }

  if (automatic) {
    digitalWrite(manualGreenLED, LOW);

    // getting distance in cms
    int distance = getDistance();

    if (distance > 10) {    // if distance is more than 10cm, no buzzer, green light
      noTone(buzzer);

      digitalWrite(autoGreenLED, HIGH);
      digitalWrite(redLED, LOW);
    } else {              // if distance is less than 10cm, trigger buzzer, show red light
      tone(buzzer, 400);

      digitalWrite(autoGreenLED, LOW);
      digitalWrite(redLED, HIGH);
    }
  } else {
    // in manual mode, the green light fades (just so the driver knows it's in manual mode)
    greenFade();
  }
}

// function to get distance from the Ultrasonic Distance Sensor
int getDistance() {
  digitalWrite(trig, LOW);   // for safety
  delayMicroseconds(2);

  digitalWrite(trig, HIGH);   // sending an 8-cycle sonic burst from trig
  delayMicroseconds(10);      // for 10 microseconds
  digitalWrite(trig, LOW);

  // reading pulse on echo so we get the duration between sound wave striking on an object and returning back
  int duration = pulseIn(echo, HIGH);

  // distance = (time taken from sending wave and returning back) * (speed of sound in centimeters/microseconds) / 2
  // [1/2 because sending and receiving means double the duration]
  int distance = duration * 0.034 / 2;

  return distance;
}

// function to handle fade of green light
void greenFade() {
  digitalWrite(redLED, LOW);
  digitalWrite(autoGreenLED, LOW);
  noTone(buzzer);

  // incrementing brightness
  brightness = brightness + fadeAmount;

  // switching increment along the value constraints
  if (brightness <= 0 || brightness >= 255) {
    fadeAmount = -fadeAmount;
  }

  analogWrite(manualGreenLED, brightness);
  delay(10);
}

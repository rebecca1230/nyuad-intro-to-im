/*
 * INTRO TO IM
 * APR 6, 2021
 * 
 * AYUSH PANDEY
 * METRONOME & THEREMIN USING ARDUINO
 * 
 * Instructions -
 * There are two buttons to control the speed of metronome. Red slows it down while Green increases its speed.
 * There's a toggle switch to enable/disable the sound output from buzzer.
 * 
 * When there's low light, lower notes (C4, D4, E4, ...) are played. 
 * When there's brighter light, higher notes (C5, D5, E5, ...) are played.
 */

#include "pitches.h"        // file for pitch information
#include <Servo.h>          // importing Servo header file

#define buzzerPin 8         // pin for Buzzer
#define servoPin 9          // pin for Servo

#define redButton A1        // metronome Red (decrease speed) button
#define greenButton A2      // metronome Green (increase speed) button

#define echo 6              // HC-SR04 echo pin
#define trig 7              // HC-SR04 trig pin

#define LDR A0              // pin for LDR

const int lightNotes[] = {NOTE_C4, NOTE_D4, NOTE_E4, NOTE_F4, NOTE_G4, NOTE_A4, NOTE_B4, NOTE_C5};    // notes to play when there's more light
const int darkNotes[] = {NOTE_C3, NOTE_D3, NOTE_E3, NOTE_F3, NOTE_G3, NOTE_A3, NOTE_B3, NOTE_C4};     // notes to play when there's low light

int toneVal = 0;            // index of notes list to get value for tone()

Servo servo;

unsigned int steps = 4;     // steps per 4 sec
int increment = 180 / steps;

unsigned int triggeredMillis = 0, delayedMillis; // to implement task without delay()

void setup() {
  // pin modes
  pinMode(greenButton, INPUT);
  pinMode(redButton, INPUT);
  pinMode(buzzerPin, OUTPUT);

  pinMode(echo, INPUT);
  pinMode(trig, OUTPUT);

  pinMode(LDR, INPUT);

  // servo initialization
  servo.attach(servoPin);
  servo.write(0);
}

void loop() {
  // playing the metronome
  metronome();
  
  if(delayedMillis >= 400){
    toneVal = map(getDuration(), 100, 2000, 0, 7); // tone as per the distance of object from HC-SR04
  }

  // tone for buzzer
  tone(buzzerPin, analogRead(LDR) > 600 ? lightNotes[toneVal]: darkNotes[toneVal]);
  
}

// function for metronome
void metronome() {
  // if green button is pressed, increase the metronome speed
  if (digitalRead(greenButton) == HIGH) {
    steps++;
    increment = 180 / steps;

    servo.write(0);
    delay(500);
  }

  // if green button is pressed, decrease the metronome speed
  if (digitalRead(redButton) == HIGH) {
    steps = (steps <= 1) ? 0: --steps;
    increment = (steps > 0) ? 180 / steps: 0;
    
    servo.write(0);
    delay(500);
  }

  // get servo's current angle
  int angle = servo.read();

  // alternating servo rotation (clockwise and anti-clockwise)
  if (angle + increment > 180 || angle + increment < 0) {
    increment = -increment;
  }

  // to omit delay()
  delayedMillis = millis() - triggeredMillis;

  int interval = steps > 0 ? (4 * 1000 / steps) : 0;
  
  if (delayedMillis >= interval) {
    triggeredMillis = millis();
    servo.write(angle + increment);
  }

}

// function to get distance from the Ultrasonic Distance Sensor
int getDuration() {
  digitalWrite(trig, LOW);   // for safety
  delayMicroseconds(2);

  digitalWrite(trig, HIGH);   // sending an 8-cycle sonic burst from trig
  delayMicroseconds(10);      // for 10 microseconds
  digitalWrite(trig, LOW);

  // reading pulse on echo so we get the duration between sound wave striking on an object and returning back
  int duration = pulseIn(echo, HIGH);

  // to stay within boundaries
  duration = constrain(duration, 100, 2000);

  return duration;
}

const int buzzer = 10;

const int trig = 5;
const int echo = 6;

const int redLED = 2;
const int autoGreenLED = 3;
const int manualGreenLED = 9;

int distance;

int brightness = 0;
int fadeAmount = 5;

const int greenSwitch = 7;

bool automatic = true;

void setup() {
  pinMode(buzzer, OUTPUT);

  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);

  pinMode(redLED, OUTPUT);
  pinMode(autoGreenLED, OUTPUT);
  pinMode(manualGreenLED, OUTPUT);

  pinMode(greenSwitch, INPUT);
}

void loop() {
  if (digitalRead(greenSwitch) == HIGH) {
    automatic = !automatic;
    delay(1000);
  }

  if (automatic) {
    digitalWrite(manualGreenLED, LOW);
    distance = getDistance();
    if (distance > 10) {
      noTone(buzzer);

      digitalWrite(autoGreenLED, HIGH);
      digitalWrite(redLED, LOW);
    } else {
      tone(buzzer, 400);

      digitalWrite(autoGreenLED, LOW);
      digitalWrite(redLED, HIGH);
    }
  } else {
      greenFade();
  }
}

int getDistance() {
  digitalWrite(trig, LOW);
  delayMicroseconds(2);

  digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);

  int duration = pulseIn(echo, HIGH);
  int distance = duration * 0.034 / 2;
  
  return distance;
}

void greenFade(){
  digitalWrite(redLED, LOW);
  digitalWrite(autoGreenLED, LOW);
  
  brightness = brightness + fadeAmount;

  if(brightness <= 0 || brightness >= 255){
     fadeAmount = -fadeAmount;
  }
  
  analogWrite(manualGreenLED, brightness);
  delay(10);
}

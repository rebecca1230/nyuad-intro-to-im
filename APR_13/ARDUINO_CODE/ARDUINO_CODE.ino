#define leftSwitch A0
#define rightSwitch A1

const int LEDs[] = {2, 3, 4, 5};
int currentLight = -1;

void setup() {
  pinMode(leftSwitch, INPUT);
  pinMode(rightSwitch, INPUT);

  for (int led : LEDs) {
    pinMode(led, OUTPUT);
  }

  Serial.begin(9600);
}

void loop() {
  while (Serial.available()) {
    int lightToGlow = constrain(Serial.parseInt(), 0, 3);
    if (Serial.read() == '\n') {
      currentLight = lightToGlow;
    }
  }

  for (int i = 0; i < sizeof(LEDs) / sizeof(int); i++) {
    if (i == currentLight) {
      digitalWrite(LEDs[i], HIGH);
    } else {
      digitalWrite(LEDs[i], LOW);
    }
  }

  if (digitalRead(leftSwitch) == HIGH) {
    Serial.println("LEFT");
    delay(200);
  } else if (digitalRead(rightSwitch) == HIGH) {
    Serial.println("RIGHT");
    delay(200);
  }
}

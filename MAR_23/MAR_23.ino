const int triggers[] = {A0, A1, A2, A3};
const int lights[] = {7, 6, 5, 4};

class Bomb {
  private:
    int* goal;
    int maxSteps;

  public:
    int step, next, pressed;

    Bomb() {
      Serial.println("WELCOME TO BOMB DEFUSAL");
      Serial.println("-----------------------");

      step = next = pressed = 0;
      maxSteps = 3;

      goal = new int[maxSteps];

      for (int i = 0; i < maxSteps; i++) {
        goal[i] = random(0, 4);
      }
      
      this->newLevel();
    }

    void newLevel() {
      next = goal[0];
      pressed = 0;
      step++;

      if (this->success()) {
        return;
      }

      Serial.println("STEP " + String(step));
      for (int i = 0; i < step; i++) {
        digitalWrite(lights[goal[i]], HIGH);
        delay(1000);
        digitalWrite(lights[goal[i]], LOW);
        delay(1000);
      }
    }

    void checkButtonPress() {
      for (int i = 0; i < 4; i++) {
        if (digitalRead(triggers[i]) == HIGH) {
          if (next == i) {
            digitalWrite(lights[i], HIGH);

            delay(500);
            digitalWrite(lights[i], LOW);
            delay(500);
            pressed++;
            next = goal[pressed];

            if (pressed == step) {
              this->newLevel();
            }
          } else {
            step = -1;
          }
        } else {
          digitalWrite(lights[i], LOW);
        }
      }
    }

    bool success() {
      if (step == maxSteps + 1) {
        return true;
      }
      return false;
    }
};

Bomb* bomb;
void setup() {
  for (int trigger : triggers) {
    pinMode(trigger, INPUT);
  }

  for (int light : lights) {
    pinMode(light, OUTPUT);
  }

  Serial.begin(9600);
  randomSeed(analogRead(A5));
  
  bomb = new Bomb();
}

void loop() {
  if (bomb->step == -1) {
    delete bomb;
    lightWorks(false);

    Serial.println("OOPS, BOMB HAS BLASTED!");
  } else if (!bomb->success()) {
    bomb->checkButtonPress();
  } else {
    delete bomb;
    lightWorks(true);

    Serial.println("CONGRATULATIONS! BOMB SUCCESSFULLY DIFFUSED!");
  }
}

void lightWorks(bool win) {
  if (win) {
    for (int light : lights) {
      digitalWrite(light, HIGH);
      delay(50);
      digitalWrite(light, LOW);
      delay(50);
    }
  } else {
    for (int light : lights) {
      digitalWrite(light, HIGH);
    }
    delay(300);
    for (int light : lights) {
      digitalWrite(light, LOW);
    }
    delay(300);
  }
}

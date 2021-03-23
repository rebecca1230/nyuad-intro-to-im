/*
   INTRO TO IM
   MAR 23, 2021

   BOMB DEFUSAL GAME WITH LEDs & Switches

   INSTRUCTIONS:
   The lights blink one by one in a random series starting from just one blink at first.
   The series keeps on increasing until you reach maxSteps.
   Your goal is to remember which lights blinked and press the corresponding buttons to diffuse the bomb.

   If you mess up, all lights start blinking at the same time (BOMB BLASTS!)
   If you successfully complete the series, lights start blinking one by one in a sequence. (BOMB DEFUSED!)
*/

const int triggers[] = {A0, A1, A2, A3};  // switch pins (A0 - RED, A1 - GREEN, A2 - BLUE, A3 - YELLOW)
const int lights[] = {7, 6, 5, 4};        // light pins (7 - RED, 6 - GREEN, 5 - BLUE, 4 - YELLOW)

// class that handles the game logic
class Bomb {
  private:
    int* goal;    // pointer to dynamic array that'll store the random light sequence
    int maxSteps; // no. of steps for game

  public:
    int step, next, pressed;

    Bomb() {
      Serial.println("WELCOME TO BOMB DEFUSAL");
      Serial.println("-----------------------");

      step = next = pressed = 0;
      maxSteps = 10;              // change this to increase/decrease game difficulty

      goal = new int[maxSteps];   // dynamic array for light sequence

      for (int i = 0; i < maxSteps; i++) {
        goal[i] = random(0, 4);
      }

      this->newLevel();
    }

    // destructor to clear memory
    ~Bomb() {
      delete[] this->goal;
    }

    // method to proceed to new level
    // on new level, you'll see the sequence you need to follow
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

    // to handle button press and verify if the sequence was followed correctly
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

    // method to check success/failure
    bool success() {
      if (step == maxSteps + 1) {
        return true;
      }
      return false;
    }
};

Bomb* bomb; // pointer for the Bomb class
int lightWorkState = 0;

void setup() {
  // setting pin modes
  for (int trigger : triggers) {
    pinMode(trigger, INPUT);
  }

  for (int light : lights) {
    pinMode(light, OUTPUT);
  }

  Serial.begin(9600);
  randomSeed(analogRead(A5)); // random seed for random() function

  // initialization
  bomb = new Bomb();
}

void loop() {
  if (lightWorkState == 0) {
    if (bomb->step == -1) {     // if the user messes up, step is set to -1
      delete bomb;              // clearing the memory
      lightWorkState = 2;                // to blink lights all at once (FAILURE)

      Serial.println("OOPS, BOMB HAS BLASTED!");
    } else if (!bomb->success()) {
      bomb->checkButtonPress(); // handling button press events
    } else {
      delete bomb;              // clearing the memory
      lightWorkState = 1;                // to blink lights in a sequence (WIN)

      Serial.println("CONGRATULATIONS! BOMB SUCCESSFULLY DEFUSED!");
    }
  } else {
    lightWorks(lightWorkState == 1 ? true : false);
  }

}

// function to handle blinks for SUCCESS/FAILURE lightWorkStates
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

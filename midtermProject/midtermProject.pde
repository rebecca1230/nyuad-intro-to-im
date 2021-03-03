/*

 INTRO TO INTERACTIVE MEDIA
 PROF. MICHAEL SHILOH
 
 MIDTERM PROJECT BY
 AYUSH PANDEY
 
 GAME TITLE
 Marine Voyage in the Pacific
 
 INSTRUCTIONS
 - Move the Submarine clicking and dragging the mouse up and down.
 - Press SPACEBAR to fire Missiles.
 
 WIN/LOSE
 The game runs infinitely, so your task is to kill as many sharks as possible and beat your own high score.
 If you miss more than more than 5 sharks, you lose.
 If a shark reaches you before you kill it, you lose.
 
*/

public class Background {
  private PImage img;
  private PImage[] subImg;
  private float xShift;

  Background() {
    img = loadImage("images/marine.png");

    subImg = new PImage[3];
    for (int i = 1; i <= 3; i++) {
      subImg[i - 1] = loadImage("images/sub" + i + ".png");
    }

    xShift = 0;
  }

  public void display() {
    image(img, width / 2, height / 2);

    xShift += 2;

    int count = 1;
    for (PImage sub : subImg) {
      int x;
      if (count == 1) {
        x = (int) xShift / 3;
      } else if (count == 2) {
        x = (int) xShift / 2;
      } else {
        x = (int) xShift;
      }

      int wR, wL;
      wR = x % width;
      wL = width - wR;

      imageMode(CORNER);
      image(sub, 0, 0, wL, height, wR, 0, width, height);
      image(sub, wL, 0, wR, height, 0, 0, wR, height);
      imageMode(CENTER);

      count++;
    }
  }
}

public class SubMarine {
  private PImage img;
  public PVector position;
  private int imgCount, cropStart;
  public int size;
  private float rotation, speed;

  SubMarine() {
    position = new PVector(100, random(100, height / 1.5));
    img = loadImage("images/submarine.png");

    imgCount = 5;
    cropStart = 0;

    rotation = radians(30.0);
    size = 120;
    speed = 3;
  }

  public void display() {

    rotation = atan2(mouseY - position.y, mouseX - position.x);

    if (rotation > radians(30)) { 
      rotation = radians(30);
    }
    if (rotation < radians(-30)) { 
      rotation = radians(-30);
    }

    pushMatrix();
    imageMode(CENTER);
    translate(position.x, position.y);
    rotate(rotation);
    image(img, 0, 0, size, size, cropStart * (img.width / imgCount), 0, cropStart * (img.width / imgCount) + (img.width / imgCount), img.height);
    popMatrix();

    if (frameCount % 5 == 0 || frameCount == 1) {
      if (cropStart < imgCount - 1) {
        cropStart++;
      } else {
        cropStart = 0;
      }
    }
  }

  public void update() {
    float increment = 0;
    if (rotation < radians(-10)) {
      increment = -(speed);
    } else if (rotation > radians(10)) {
      increment = speed;
    }

    if ((position.y + increment) < (height - size / 2) && (position.y + increment) > (size / 2)) {
      position.y += increment;
    }
  }
}

public class Shark {
  private PVector position;
  private PImage img;
  private int imgCount, cropStart, size;

  private float speed;

  public Shark() {
    position = new PVector(width + 200, random(100, height / 1.2));
    img = loadImage("images/shark.png");

    imgCount = 6;
    size = 200;
    cropStart = 0;

    speed = random(4, 6);
  }

  public void display() {
    float ratio = (float) img.height / (img.width / imgCount);

    image(img, position.x, position.y, size, size * ratio, cropStart * (img.width / imgCount), 0, cropStart * (img.width / imgCount) + (img.width / imgCount), img.height);
    update();
    if (frameCount % 10 == 0 || frameCount == 1) {
      if (cropStart < imgCount - 1) {
        cropStart++;
      } else {
        cropStart = 0;
      }
    }
  }

  public void update() {
    position.x -= speed;

    if (position.x < -200) {
      game.sharks.remove(this);
      game.missed++;
    }

    for (int i = 0; i < game.missiles.size(); i++) {
      Missile missile = game.missiles.get(i);
      if (dist(missile.position.x, missile.position.y, position.x, position.y) < size / 2) {
        game.explosions.add(new Explosion(missile.position.x + 30, missile.position.y));
        game.missiles.remove(missile);
        game.sharks.remove(this);

        game.score += 10;
      }
    }

    if (dist(game.submarine.position.x, game.submarine.position.y, position.x, position.y) < (game.submarine.size / 2 + size / 2 - 20)) {
      game.screen = 2;
    }
  }
}

public class Missile {
  private PImage img;
  public PVector position;

  private int imgCount, cropStart, size;

  Missile() {
    img = loadImage("images/missile.png");
    position = new PVector(game.submarine.position.x + 20, game.submarine.position.y + 35);

    cropStart = 0;
    imgCount = 5;
    size = 80;
  }

  public void display() {
    float ratio = (float) img.height / (img.width / imgCount);
    image(img, position.x, position.y, size, size * ratio, cropStart * (img.width / imgCount), 0, cropStart * (img.width / imgCount) + (img.width / imgCount), img.height);
    update();

    if (frameCount % 7 == 0 || frameCount == 1) {
      if (cropStart < imgCount - 1) {
        cropStart++;
      } else {
        cropStart = 0;
      }
    }
  }

  public void update() {
    position.x += 3;

    if (position.x >= width + 50) {
      game.missiles.remove(this);
    }
  }
}

public class Explosion {
  private PImage img;
  private PVector position;

  private int imgCount, cropStart, size;

  Explosion(float x, float y) {
    position = new PVector(x, y);
    img = loadImage("images/explosion.png");

    cropStart = 0;
    imgCount = 5;
    size = 100;
  }

  public void display() {
    if (cropStart < imgCount) {
      image(img, position.x, position.y, size, size, cropStart * (img.width / imgCount), 0, cropStart * (img.width / imgCount) + (img.width / imgCount), img.height);
      if (frameCount % 10 == 0) {
        cropStart++;
      }
    } else {
      game.explosions.remove(this);
    }
  }
}

public class Game {
  private PFont font;

  private Background background;
  public SubMarine submarine;

  public ArrayList<Shark> sharks;
  public ArrayList<Missile> missiles;
  public ArrayList<Explosion> explosions;

  public int screen, score, missed;
  private color scoreColor;

  private String highScoreFile;
  private int highScore;

  Game() {
    screen = 1;
    score = missed = 0;

    font = createFont("fonts/big_noodle_titling.ttf", 32);
    textFont(font);
    scoreColor = color(255, 255, 255);

    background = new Background();
    submarine = new SubMarine();

    sharks = new ArrayList<Shark>();
    missiles = new ArrayList<Missile>();
    explosions = new ArrayList<Explosion>();

    highScoreFile = "high-score.txt";
    highScore = readHighScore();
  }

  public void update() {
    background.display();
    switch(screen) {
    case 0:
      break;

    case 1:
      submarine.display();

      if (frameCount % 100 == 0) {
        if (sharks.size() < 4) {
          sharks.add(new Shark());
        }
      }

      for (int i = 0; i < sharks.size(); i++) {
        sharks.get(i).display();
      }

      for (int i = 0; i < missiles.size(); i++) {
        missiles.get(i).display();
      }

      for (int i = 0; i < explosions.size(); i++) {
        explosions.get(i).display();
      }

      //score
      textAlign(RIGHT);
      fill(scoreColor);
      textSize(35);
      text("SCORE", width - 10, 35);
      textSize(28);
      text(score, width - 10, 65);

      textAlign(LEFT);
      textSize(35);
      text("MISSED", 10, 35);
      textSize(28);
      text(missed, 10, 65);

      if (mousePressed) {
        mouseHandler();
      }
      break;
    case 2:
      if (score > highScore) {
        newHighScore();
      }
      break;
    }
  }

  private void mouseHandler() {
    submarine.update();
  }

  private int readHighScore() {
    int hs;

    File file = new File(dataPath(highScoreFile));
    if (file.exists()) {
      BufferedReader reader = createReader(dataPath(highScoreFile));
      try {
        hs = Integer.parseInt(reader.readLine());
      }
      catch(IOException ioe) {
        hs = 0;
      }
    } else {
      hs = 0;
    }

    return hs;
  }

  private void newHighScore() {
    PrintWriter writer = createWriter(dataPath(highScoreFile));
    writer.print(score);
    writer.flush();
    writer.close();
  }
}

Game game;
void setup() {
  size(1100, 684);
  imageMode(CENTER);

  game = new Game();
}

void draw() {
  game.update();
}

void keyPressed() {
  if (keyCode == 32 && game.missiles.size() < 4) {
    game.missiles.add(new Missile());
  }
}

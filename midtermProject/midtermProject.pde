public class Background {
  private PImage img;
  private PImage[] subImg;
  private float xShift;

  Background() {
    img = loadImage("images/marine.png");

    subImg = new PImage[3];
    for (int i = 1; i <= 3; i++) {
      subImg[i-1] = loadImage("images/sub" + i + ".png");
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
  public PImage img;
  public PVector position;
  private int imgCount, cropStart, size;
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

  public Shark() {
    position = new PVector(width + 200, random(100, height / 1.2));
    img = loadImage("images/shark.png");

    imgCount = 6;
    size = 200;
    cropStart = 0;
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
    position.x -= 2;

    if (position.x < -200) {
      game.sharks.remove(this);
    }
    
    for(int i = 0; i < game.missiles.size(); i++){
      Missile missile = game.missiles.get(i);
      if(dist(missile.position.x, missile.position.y, position.x, position.y) < size / 2){
        game.missiles.remove(missile);
        game.sharks.remove(this);
        
        game.score += 10;
      }
    }
  }
}

public class Missile {
  PImage img;
  PVector position;

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

public class Game {
  PFont font;

  Background background;
  SubMarine submarine;

  ArrayList<Shark> sharks;
  ArrayList<Missile> missiles;

  int screen, score;
  color backgroundColor, scoreColor;

  Game() {
    screen = 0;
    score = 0;

    font = createFont("fonts/big_noodle_titling.ttf", 32);
    textFont(font);

    background = new Background();
    submarine = new SubMarine();

    sharks = new ArrayList<Shark>();
    missiles = new ArrayList<Missile>();
  }

  public void update() {
    switch(screen) {
    case 0:
      background.display();
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

      //score
      textAlign(RIGHT);
      fill(255);
      textSize(35);
      text("SCORE", width - 10, 35);
      textSize(28);
      text(score, width - 10, 65);
      
      textAlign(LEFT);
      textSize(35);
      text("PRESS SPACE", 10, 35);
      textSize(28);
      text("FOR MISSILES", 10, 65);

      if (mousePressed) {
        mouseHandler();
      }
      break;
    case 1:
      break;
    case 2:
      break;
    }
  }

  private void mouseHandler() {
    submarine.update();
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

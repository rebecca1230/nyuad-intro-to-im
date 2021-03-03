/*
Ayush Pandey
ap6178

INTRO TO IM
ASSIGNMENT - FEB 9

SIMPLE BALL CATCHING GAME IN PROCESSING
*/

public class Ball {
  public PVector position = new PVector(); // horizontal and vertical position for ball
  public int radius; // radius of the ball
  public float speed; // the speed with which it falls down

  Ball() {
    // initialization
    this.reset();
    this.radius = 20;
    this.speed = 5;
  }

  // to set random x-position for ball at the top
  public void reset() {
    this.position.x = random(width/3, width/1.2);
    this.position.y = 40;
  }

  // to display the ball on screen
  public void display() {
    noStroke();
    fill(65, 112, 130);
    ellipse(this.position.x, this.position.y, this.radius, this.radius);
    this.update();
  }

  // to update ball's position and status
  public void update() {
    
    //if it misses the basket, game is over
    if (this.position.y + this.radius/2 >= height - 80) {
      gameOver = true;
    }
    
    // incrementing y-position with speed
    this.position.y += this.speed;
    
    // if it collides with the basket, add score
    if (dist(this.position.x, this.position.y, basket.position.x, basket.position.y) <= basket.size/3) {
      score += 10;
      
      //incrementing speed
      this.speed += 0.2;
      
      this.reset();
    }
  }
}

public class Basket {
  public PVector position = new PVector(); // horizontal and vertical positions
  public int size; // size of basket
  PImage img; // for the basket image
  
  Basket() {
    // basket moves with mouse position
    this.position.x = mouseX;
    this.position.y = height - 100;
    
    this.size = 100;
    this.img = loadImage("images/basket.png");
  }
  
  // to display the basket on screen
  public void display() {
    image(this.img, this.position.x, this.position.y, this.size, this.size);
    this.update();
  }

  // to update the basket's position with mouse position but horizontally
  public void update() {
    if (mouseX - this.size/2 > 0 && mouseX + this.size/2 < width) {
      this.position.x = mouseX;
    }
  }
}

//ball and basket objects
Ball ball;
Basket basket;

//score for the game
int score = 0;

//to check game over state
boolean gameOver = false;

//for background image
PImage bg;

void setup() {
  size(600, 600);
  frameRate(60);

  bg = loadImage("images/background.png");

  imageMode(CENTER);
  ball = new Ball();
  basket = new Basket();
}

void draw()
{
  background(bg);
  
  //displaying score
  fill(0);
  textAlign(RIGHT);
  textSize(20);
  text("SCORE", width - 20, 30);
  textSize(16);
  text(score, width - 20, 50);

  if (!gameOver) {
    ball.display();
    basket.display();
  } else {
    //showing the game over screen
    textSize(30);
    textAlign(CENTER);
    text("GAME OVER", width/2, height/2);
  }
}

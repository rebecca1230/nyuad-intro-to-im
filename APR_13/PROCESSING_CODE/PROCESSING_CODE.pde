import java.util.Map;
import processing.serial.*;
Serial serial;

final int blockSize = 30;

final int ROWS = 10;
final int COLS = 20;

final int RES_X = blockSize * ROWS;
final int RES_Y = blockSize * COLS;

ArrayList<Integer> colors = new ArrayList<Integer>();

public class Block {
  public int row, col, fillColor;

  public Block(int row, int col) {
    this.row = row;
    this.col = col;
    this.fillColor = color(64);
  }

  public void display() {
    strokeWeight(1);
    stroke(115);

    fill(this.fillColor);
    rect(this.col * blockSize, this.row * blockSize, blockSize, blockSize);
  }
}

public class Game {
  private int speed, score;
  private int[] active;
  private boolean gameOver;

  private ArrayList<ArrayList<Block>> blockList;

  public Game() {
    colors.add(color(64));
    colors.add(color(36, 130, 201));
    colors.add(color(224, 190, 16));  // yellow
    colors.add(color(25, 179, 71));  // green
    colors.add(color(201, 39, 14));  // red

    this.speed = 0;
    this.score = 0;
    this.active = null;
    this.gameOver = false;

    this.blockList = new ArrayList<ArrayList<Block>>();

    for (int i = 0; i < RES_Y / blockSize; i++) {
      ArrayList<Block> blocks = new ArrayList<Block>();

      for (int j = 0; j < RES_X / blockSize; j++) {
        blocks.add(new Block(i, j));
      }

      blockList.add(blocks);
    }
  }

  private void update() {
    if (frameCount % (max(1, int(8 - this.speed))) == 0 || frameCount == 1) {
      if (!this.gameOver) {
        if (this.active == null) {
          this.newBlock();
        } else {
          this.swapBlock(0);
        }

        for (ArrayList<Block> row : blockList) {
          for (Block block : row) {
            block.display();
          }
        }

        textSize(15);
        fill(255);
        text("Score: " + this.score, RES_X - 70, 20);
      } else {
        background(255);
        fill(0);
        textSize(20);
        text("GAME OVER", 15, 30);
        
        textSize(13);
        text("SCORE: " + this.score + "\nClick anywhere to\nrestart the game.", 15, 50);
      }
    }
  }

  private void newBlock() {
    int position = (int) random(0, 9);

    int count = 0;
    while (this.getBlock(0, position).fillColor != colors.get(0) && count < 10) {
      position = (int) random(0, 9);
      count++;
    }

    if (count == 10) {
      this.gameOver = true;
    } else {
      int randomChoice = (int) random(1, 5);

      this.getBlock(0, position).fillColor = colors.get(randomChoice);
      this.active = new int[]{0, position};

      this.speed += 1;
    }
  }

  private void check(int row, int col) {
    if (row + 3 < RES_Y / blockSize) {
      int count = row;
      int activeColor = this.getBlock(row, col).fillColor;

      ArrayList<int[]> blocks = new ArrayList<int[]>();

      while (count < row + 4) {
        if (this.getBlock(count, col).fillColor == activeColor) {
          blocks.add(new int[]{count, col});
        } else {
          return;
        }

        count++;
      }
      
      for(int[] b: blocks){
        this.getBlock(b[0], b[1]).fillColor = colors.get(0);
      }
      
      this.speed = 0;
      this.score++;
    }
  }

  private void swapBlock(int horizontal) {
    int maxY = RES_Y / blockSize;
    int maxX = RES_X / blockSize;

    if (this.active != null && this.active[0] + 1 < maxY) {

      if (this.getBlock(this.active[0] + 1, this.active[1]).fillColor == colors.get(0)) {

        if (this.active[1] + horizontal >= 0 && this.active[1] + horizontal < maxX) {
          if (this.getBlock(this.active[0] + 1, this.active[1] + horizontal).fillColor != colors.get(0)) {
            horizontal = 0;
          }
        } else {
          horizontal = 0;
        }

        Block block1 = this.getBlock(this.active[0], this.active[1]);
        Block block2 = this.getBlock(this.active[0] + 1, this.active[1] + horizontal);

        block2.fillColor = block1.fillColor;
        block1.fillColor = colors.get(0);

        this.active = new int[]{this.active[0] + 1, this.active[1] + horizontal};
      } else {
        this.check(this.active[0], this.active[1]);
        this.active = null;
      }
    } else {
      if (this.active != null) {
        this.check(this.active[0], this.active[1]);
      }

      this.active = null;
    }
  }

  private Block getBlock(int r, int c) {

    for (ArrayList<Block> row : this.blockList) {
      for (Block block : row) {
        if (r == block.row && c == block.col) {
          return block;
        }
      }
    }

    return null;
  }

  private void newGame() {
    this.gameOver = false;
    this.score = 0;
    this.speed = 0;
    this.active = null;

    for (ArrayList<Block> row : this.blockList) {
      for (Block block : row) {
        block.fillColor = colors.get(0);
      }
    }
  }
}

Game game;
void setup() {
  size(300, 600);
  background(210);

  game = new Game();

  serial = new Serial(this, Serial.list()[0], 9600);
  serial.clear();
  serial.bufferUntil('\n');
}

int light = 0;
void draw() {
  game.update();
}

void keyPressed() {
  if (keyCode == LEFT) {
    game.swapBlock(-1);
  } else if (keyCode == RIGHT) {
    game.swapBlock(1);
  }
}

void mousePressed() {
  if (game.gameOver) {
    game.newGame();
  }
}

void serialEvent(Serial serial) {
  String message = trim(serial.readStringUntil('\n'));
  if (message != null) {
    println(message);
    if (message.contains("LEFT")) {
      game.swapBlock(-1);
    } else if (message.contains("RIGHT")) {
      game.swapBlock(1);
    }
  }
}

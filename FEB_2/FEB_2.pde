/*
Ayush Pandey
ap6178

INTRO TO IM
ASSIGNMENT - FEB 2

USING LOOPS TO MAKE A SIMPLE ANIMATION
*/

void setup() {
  size(600, 600);
  frameRate(100);
}

//radius for ripples
int radius = 40;

//increment for ripples (or simply, speed)
int offset = 2;

void draw() {
  background(74, 57, 45);

  //drawing each ellipse for wave-like animation
  noFill();
  stroke(255);
  strokeWeight(2);
  for (int j = radius; j < width / 2 ; j += 30) {
    ellipse(mouseX, mouseY, j, j);
  }
  
  //incrementing the radius
  radius += offset;
  
  //checking if the radius is max, then reversing it
  if (radius > width/2 || radius < 0) {
    offset = (-1) * offset;
  }
  
  //steps (inspired from Grid example)
  stroke(255, 237, 138);
  for(int j = 20; j < mouseX; j += 20){
    line(j, j, j, mouseY);
    line(0, j, j, j);
  }
}

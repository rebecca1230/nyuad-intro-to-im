/*
Ayush Pandey
ap6178

INTRO TO IM
ASSIGNMENT - JAN 26

SELF PORTRAIT IN PROCESSING
*/

void setup(){
  size(600, 600);
  background(125, 204, 209);
  
  //to set co-ordinates to CENTER, unlike corners
  rectMode(CENTER);
  ellipseMode(CENTER);
}

void draw(){
  //face width and height for other calculations
  int faceWidth = 130;
  int faceHeight = 150;
  
  //tshirt
  fill(121, 69, 173);
  ellipse(width/2, height/1.42, 300, 300);
  
  //table
  fill(255);
  quad(60, height/1.42, width - 60, height/1.42, width + 300, height * 1.2, -300, height * 1.2);
  
  //laptop
  fill(0);
  quad(width/2 - 120, height/1.6, width/2 + 120, height/1.6, width/2 + 90, height/1.6 + 100, width/2 - 90, height/1.6 + 100);
  fill(255);
  textAlign(CENTER);
  textSize(14);
  text("acer", width/2, height/1.6 + 50);
  
  //neck
  fill(237, 216, 145);
  stroke(255);
  strokeWeight(10);
  ellipse(width/2, height/2 - faceHeight/5, 60, 70);
  strokeWeight(0);
  noStroke();
  
  //face container
  fill(245, 228, 171);
  rect(width/2, height/3, faceWidth, faceHeight, 40);
  
  //eyes
  fill(255);
  stroke(0);
  ellipse(width/2 - faceWidth/4, height/3 - 20, 15, 15);
  ellipse(width/2 + faceWidth/4, height/3 - 20, 15, 15);
  
  fill(0);
  ellipse(width/2 - faceWidth/4, height/3 - 17, 3, 3);
  ellipse(width/2 + faceWidth/4, height/3 - 17, 3, 3);
  
  //nose
  stroke(0);
  strokeWeight(1);
  line(width/2 + 5, height/3, width/2, height/3 + 5);
  line(width/2, height/3 + 5, width/2 - 5, height/3);
  noStroke();
  
  //mouth
  fill(82, 50, 44);
  ellipse(width/2, height/3 + 40, 20, 20);
  
  //hair
  fill(0);
  rect(width/2 - 20, height/3 - faceHeight/2, faceWidth + 30, 40, 25);
  fill(255);
  rect(width/2 - 50, height/3 - faceHeight/2 - 15, faceWidth/3, 5, 5);
}

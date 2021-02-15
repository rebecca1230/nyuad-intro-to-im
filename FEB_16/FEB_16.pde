/*
Ayush Pandey
ap6178

INTRO TO IM
ASSIGNMENT - FEB 16

BITCOIN DATA VISUALIZATION FROM DEC 2020
*/

String database[]; // to load data into an array from a csv file
int margin; // display margin for the graph

void setup() {
  background(36);
  size(600, 500);
  
  // loading bitcoin price data from DEC 2020 [data downloaded from Kaggle]
  database = loadStrings("bitcoin.csv");
  
  margin = 50;

  noLoop();
  stroke(102);
}

void draw() {
  // looping over data
  for (int i = 0; i < database.length; i++) {
    // getting individual rows of data
    String row[] = split(database[i], ",");
    
    // extracting timestamps and their respective price
    float timestamp = map(int(row[0]), int(split(database[0], ",")[0]), int(split(database[database.length - 1], ",")[0]), margin, width - margin);
    float value = map(float(row[1]), 0, float(split(database[database.length - 1], ",")[1]), margin, height - margin);
    value = 500 - value;
    
    // plotting the data
    point(timestamp, value);
  }

  // lines for x and y axis
  stroke(250, 240, 57);
  fill(255);
  strokeWeight(2);
  line(margin, margin, margin, height - margin);
  line(margin, height - margin, width - margin, height - margin);

  // indicating endpoints of lines
  noStroke();
  ellipse(margin, height - margin, 10, 10);
  ellipse(margin, margin, 10, 10);
  ellipse(width - margin, height - margin, 10, 10);
  
  // text information
  textAlign(CENTER);
  textSize(22);
  text("Bitcoin Price Chart\nDEC 2020", width / 1.4, height - margin - 60);

  // graph legends
  textSize(15);
  pushMatrix();
  translate(margin / 2 + 10, height / 2);
  rotate(radians(-90));
  translate(-margin / 2, -height / 2);
  text("VALUE IN USD", margin / 2, height / 2);
  popMatrix();
  
  text("TIMESTAMPS FROM DEC 1 - DEC 31", width / 2, height - margin / 2);
}

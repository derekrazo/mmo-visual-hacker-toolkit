import oscP5.*;

OscP5 oscP5;

float x, y, z, zm; //x = x-coordinate, y = y-coordinate, z = brush size, zm = max brush size
 
void setup() {  //setup function called initially, only once
  size(600, 600);
  background(0);  //set background white
  colorMode(HSB);   //set colors to Hue, Saturation, Brightness mode
  x = width/2; //set start coords to the middel
  y = height/2;
  zm = 40;
  z = zm/2;
  
  oscP5 = new OscP5(this, 12000);
  background(0, 20);
}
 
void draw() {  //draw function loops
  synchronized(this) {
    fill(0, 12);
    rect(0, 0, width, height);
  }
  iterate();
}

float h = 0;
float zJump = 2;
float spread = 5;
float jitter = 0;

void iterate() {
  
  float jX = constrain(jitter*(x/width), -.8*spread, .8*spread),
        jY = constrain(jitter*(y/height), -.8*spread, .8*spread);
        
  x = x + random(-(spread-jX),spread-jX); //add or subtracts a bit
  if (x > width) x = width;
  if (x < 0) x = 0;
  y = y + random(-(spread-jY),spread-jY); //add or subtracts a bit
  if (y > height) y = height;
  if (y < 0) y = 0;
  z = z + random(-zJump,zJump); //add or subtracts a bit
  if (z > zm) z = zm;
  if (z < 3) z = 3;
  noStroke();
  fill(h,200*y/height+55,200*z/zm+55); //let z, y and z determine hue, saturation and brightness
  ellipse(x,y,z,z);
}

void oscEvent(OscMessage m) {
  println(m.addrPattern());
  println(m.arguments());
  synchronized(this) {
    if(m.checkAddrPattern("bang")) {
      for(int i =0 ; i < 2500; i++) {
        iterate();
      }
    }
    if(m.checkAddrPattern("/start")) {
      h = (m.get(0).floatValue() / 10) % 255;
    }
    if(m.checkAddrPattern("/length")) {
      zJump = (m.get(0).floatValue()) / 10;
    }
    if(m.checkAddrPattern("/speed")) {
      spread = (m.get(0).floatValue());
    }
  }
}

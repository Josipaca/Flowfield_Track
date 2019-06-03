import org.openkinect.freenect.*;
import org.openkinect.processing.*;

boolean debug = true;

float inc = 0.1;
int scl = 10;
float zoff = 0;

int cols;
int rows;

int noOfPoints = 10000;

Particle[] particles = new Particle[noOfPoints];
PVector[] flowField;

KinectTracker tracker;
Kinect kinect;

void setup() {
  size(640, 480, P2D);
  //fullScreen();
  orientation(LANDSCAPE);
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  
  background(0);
  hint(DISABLE_DEPTH_MASK);
  
  cols = floor(width/scl);
  rows = floor(height/scl);
  
  flowField = new PVector[(cols*rows)];
  
  for(int i = 0; i < noOfPoints; i++) {
    particles[i] = new Particle();
  }
}

void draw() {
 fill(0,7);
 rect(0,0,width,height);
 noFill();
  tracker.track();
  if (debug) tracker.display();
  
  PVector v2 = tracker.getLerpedPos();
  if (debug) fill(100, 250, 50);
  noStroke();
  ellipse(v2.x, v2.y, 20, 20);
  
  
  float yoff = 0;
  for(int y = 0; y < rows; y++) {
    float xoff = 0;
    for(int x = 0; x < cols; x++) {
      int index = (x + y * cols);

      float angle = noise(xoff, yoff, zoff) * TWO_PI;
      PVector v = PVector.fromAngle(angle);
      v.setMag(0.01);
      
      flowField[index] = v;
     
      stroke(100);
      push();
      translate(x * scl, y * scl);
      rotate(v.heading());
      strokeWeight(1);
      if (debug) line(0, 0, scl, 0);
      pop(); 
       
       
      
      xoff = xoff + inc;
    }
    yoff = yoff + inc;
  }
  zoff = zoff + (inc / 50);
  
  for(int i = 0; i < particles.length; i++) {
    particles[i].follow(flowField);
    particles[i].update();
    particles[i].edges();
    particles[i].show();
  }
}


void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }
 
  
    }
  }

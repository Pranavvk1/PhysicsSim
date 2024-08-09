Ball b1;
Ball b2;
Rod r1;
float currAngle;

void setup() {
  size(400, 400);
  float[] pos1 = {-70, -50};
  float[] vel1 = {100, 0};
  float[] pos2 = {70, -50};
  b1 = new Ball(10, pos1, vel1);
  b2 = new Ball(20, pos2, new float[2]);
  r1 = new Rod(100, 20,   3 * PI / 2, -0.1);
  currAngle = r1.angle;
}

void draw() {
  background(220);
  translate(width / 2, height / 2);
  
  float[] g1 = {0, b1.getMass() * 75};
  b1.applyForce(g1);
  
  float[] g2 = {0, b2.getMass() * 75};
  b2.applyForce(g2);
   
  float[] gR = {0, r1.mass * 75};
  r1.applyForce(gR, r1.len / 2);
  
  b1.collide(b2);
  r1.collide(b1);
  r1.collide(b2);
  if(keyPressed) {
    if (key == CODED){
      if(keyCode == RIGHT) {
        setSpeed(50);
      } else if(keyCode == LEFT) {
        setSpeed(-50);
      } else if(keyCode == SHIFT){
        maintainPos(currAngle);
      }
    } else if (key == 'h') {
      hitBall();
    }
  } else {
    currAngle = r1.angle;
  }
  
  
  b2.show();
  b1.show();
  r1.show();
  
}

void setSpeed(float speed) {
  float err = speed * 0.05 - r1.angVel;
  
  float theta = r1.angle;
  while(theta >= 2 * PI) theta -= 2 * PI;
  
  if(abs(err) >= 0.001) {
    if(theta >= 3 * PI / 2 || theta <= 3 * PI / 4){
      r1.applyTorque(98000 * err);
    } else {
      r1.applyTorque(230000 * err);
    }
  }
}

void maintainPos(float theta) {
  float err = theta - r1.angle;
  
  if(abs(err) >= 0.001) {
    setSpeed(100 * err);
  }
}

void hitBall() {
  float[] distance = r1.getDistance(b1);
  
  if(distance[1] == r1.angle + PI / 2) {
    setSpeed(2 * distance[0]);
  } else if (distance[1] == r1.angle - PI / 2) {
    setSpeed(-2 * distance[0]);
  }
}

  

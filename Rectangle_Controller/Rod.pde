class Rod {
  float angle;
  float angVel;
  float angAccel = 0;
  float netTorque = 0;
  float len;
  float mass;
  boolean isCollision;
  
  public Rod(float len, float mass, float angle, float omega){
    this.len = len;
    this.mass = mass;
    this.angle = angle;
    this.angVel = omega;
    isCollision = false;
  }
  
  public void setVel(float vel){
    angVel = vel;
  }
    
  
   public void applyForce(float[] force, float radius) {
    float[] leverArm = {radius, angle};
    float[] polarForce = {sqrt(sq(force[0]) + sq(force[1])), getAbsoluteAngle(force)};
    netTorque = leverArm[0] * polarForce[0] * sin(polarForce[1] - leverArm[1]);
  }
  
  public void applyTorque(float torque) {
    netTorque += torque;
  }

  // get the heading of the vector with respect to the positive x-axis. Clockwise angles are positive
  public float getAbsoluteAngle(float[] vector) {
    float angle = atan(vector[1] / vector[0]);
    if(vector[0] < 0 && vector[1] > 0) {
      angle = PI + angle;
    } else if (vector[0] < 0 && vector[1] < 0) {
      angle += PI;
    } else if (vector[0] > 0 && vector[1] < 0) {
      angle = (2 * PI) + angle;
    }
    return angle;
  }
  
  public float[] getDistanceFromHinge(Ball other) {
    float[] relPos = {other.pos[0], other.pos[1]};
    float[] pos = {sqrt(sq(relPos[0]) + sq(relPos[1])), getAbsoluteAngle(relPos)};
    return pos;
  }
  
  public float[] getDistance(Ball other) { // gets the shortest distance from the center of the ball to the rod
    float[] r1 = getDistanceFromHinge(other);
    float theta = r1[1] - angle;
    float[] distance = {Float.MAX_VALUE, 0};
    
    if(theta <= PI / 2 && theta >= 0) {
      if(r1[0] * cos(theta) <= len && r1[0] * sin(theta) >= 25) { // below
        distance[0] = r1[0] * sin(theta) - 25;
        distance[1] = angle + PI / 2;
      } else if (r1[0] * cos(theta) >= len && r1[0] * sin(theta) <= 25) { // right
        distance[0] = r1[0] * cos(theta) - len;
        distance[1] = angle;
      }
    } else if(theta >= -PI / 2 && theta < 0) { // above
      if(r1[0] * cos(theta) <= len) {
        distance[0] = r1[0] * sin(abs(theta));
        distance[1] = angle - PI / 2;
      }
    } else if(theta >= -3 * PI / 2 && theta <= -PI) { // left, angle > pi / 2
      theta += PI;
      if(r1[0] * sin(theta) >= -25) {
        distance[0] = r1[0] * cos(theta);
        distance[1] = angle + PI;
      }
    } else if(theta > PI / 2 && theta <= PI) { // left, angle < pi / 2
      theta -= PI / 2;
      if(r1[0] * cos(theta) <= 25) {
        distance[0] = r1[0] * sin(theta);
        distance[1] = angle + PI;
      }
    } 
    return distance;
  }
  
  public void collide (Ball other) {
    float[] distance = getDistance(other);
    float leverArm = 0;
    if(distance[1] == angle + PI / 2 || distance[1] == angle - PI / 2) {
      float[] pos = getDistanceFromHinge(other);
      float theta = abs(pos[1] - angle);
      leverArm = pos[0] * cos(theta);
    } else {
      leverArm = len;
    }
    
    float[] ballGrav = {0, other.getMass() * 75};
    float[] rodGrav = {0, mass * 75};
    
    float angMomentum = 1/3 * mass * sq(len) * angVel + other.getMass() * sqrt(sq(other.vel[0]) + sq(other.vel[1]));
    
    if (distance[0] < 25) {
      float scalingFactor = -0.5 * angMomentum * distance[0];
      scalingFactor = (float) Math.max(-80000 , Math.min(scalingFactor, -25000));
      float[] normalForce = {scalingFactor *   cos(distance[1]), scalingFactor *  sin(distance[1])};
      float[] reactionForce = {-normalForce[0], -normalForce[1]};
      this.applyForce(normalForce, leverArm);
      other.applyForce(reactionForce);
      isCollision = true;
    } else if(!other.isBallCollision && !this.isCollision) {
      this.applyForce(rodGrav, len / 2);
      other.applyForce(ballGrav);
    }
    
  }
  
  
  public void show(){
    float inertia = (float) 1/3 * mass * sq(len);
    
    if(abs(angVel) > 5) {
      applyTorque(angVel * -10000);
    }
        
    angAccel = netTorque / inertia;
    angVel += angAccel * 1/60;
    angle += angVel * 1/60;
    
    while(angle > 2 * PI) {
      angle -= 2 * PI;
    }
    
    while(angle < 0) {
      angle += 2 * PI;
    }
    
    rotate(angle);
    rect(0, 0, len, 25);
  }
}
  
 

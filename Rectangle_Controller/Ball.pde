public class Ball{
  float[] pos;
  float[] vel;
  float[] accel;
  float[] netForce;
  private final float MASS;
  boolean isBallCollision = false;
  
  public Ball(float mass, float[] pos, float[] vel) {
    MASS = mass;
    this.pos = pos;
    this.vel = vel;
    accel = new float[2];
    netForce = new float[2];
  }
  
  public void setVel(float[] vel) {
    this.vel = vel;
  }
  
  public void applyForce(float[] force) {
    this.netForce[0] = force[0];
    this.netForce[1] = force[1];
  }
  
  public void addForce(float[] force) {
    netForce[0] += force[0];
    netForce[1] += force[1];
  }
  
  public float[] getRelPos(Ball other) {
     float[] relPos = {other.pos[0] - pos[0], other.pos[1] - pos[1]};
     return relPos;
  }
  
  public float getDistance(Ball other) {
    return (float) Math.sqrt(Math.pow(this.pos[0] - other.pos[0], 2) + Math.pow(this.pos[1] - other.pos[1], 2));
  }
  
  public float getMass() {
    return MASS;
  }
  
  public void collide(Ball other) {
    float[] g1 = {0, this.getMass() * 75};
    float[] g2 = {0, other.getMass() * 75};
    
    float momentum = this.getMass() * (sqrt(sq(vel[0]) + sq(vel[1]))) + other.getMass() * (sqrt(sq(other.vel[0]) + sq(other.vel[1])));
    
    if (b1.getDistance(other) < 50) {
      float[] normalForce = {this.getRelPos(other)[0] * -0.15 * momentum, this.getRelPos(other)[1] * -0.15 * momentum};
      float[] reactionForce = {-normalForce[0], -normalForce[1]};
      this.applyForce(normalForce); 
      other.applyForce(reactionForce);
      isBallCollision = true;
    } else if (netForce[0] != g1[0] || netForce[1] != g1[1]) {
      this.applyForce(g1);
      other.applyForce(g2);
      isBallCollision = false;
    }   
  }
    
  
  public void show() {
    if (Math.abs(pos[0]) >= 175 ) {
      vel[0] *= -1;
    }
    if ( Math.abs(pos[1]) >= 175) {
      vel[1] *= -1;
    }
    
    
    if(sqrt(sq(vel[0]) + sq(vel[1])) > 200) {
      float[] dragForce = {-vel[0] * 3, -vel[1] * 3};
      addForce(dragForce);
    }
    
    accel[0] = netForce[0] * 1/MASS;
    accel[1] = netForce[1] * 1/MASS;
    vel[0] += accel[0] * 1/60;
    vel[1] += accel[1] * 1/60;
    pos[0] += vel[0] * 1/60;
    pos[1] += vel[1] * 1/60;
  
    circle(pos[0], pos[1], 50);
  }
}
    
    
    
  

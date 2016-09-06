class Projectile
{
  PShape projShape;
  
  float rotation;//Rotation of projectile
  
  PVector position;//Position of projectile
  PVector velocity;//Velocity of preojectile to modify position
  
  float activeTimer;//Timer for how long projectile has been active
  float lifeTime;//How long projectile can be active before destroyed
  
  float radius;//Radius around bullet for collision detection
  
  //Constructor (params: pos-position of player where projeectile will fire from, direction-normalized direction vector in which projectile will move, rot-rotation of projectile,
  // speed-speed of projectile, time-duration for which projectile remains active)
  Projectile(PVector pos, PVector direction, float rot, float speed, float time)
  {
    activeTimer = 0;   
    lifeTime = time;
     
    projShape = createShape(RECT, -10,-2.5,20,5);
    projShape.setFill(color(0,255,255,127));    
    projShape.setStroke(false);
    
    position = PVector.add(pos,PVector.mult(direction,30)); //Shift 30 px forward from center of ship
    
    velocity = PVector.mult(direction, speed);//Set velocity vector with direction and speed
        
    rotation = rot;
    
    radius = 5;
  }
  
  
  boolean updateActive()
  {
    activeTimer += deltaTime;
    
    //If projectile's active time has exceeded its lifetime, return that the projectile is no longer alive
    if(activeTimer > lifeTime)
    {
      return false; 
    }
    
    position.add(PVector.mult(velocity, 60*deltaTime));//Update position
    screenWrap();
    
    return true;//Return that projectile is still alive
  }
  
  //Display projectile
  void display()
  {     
    pushMatrix();
    
    translate(position.x,position.y);
    rotate(rotation);
    shape(projShape);
    
    if(debugMode)
    {
      noFill();
      stroke(0,255,0);
      ellipse(0,0,2*radius,2*radius);
    }
    
    popMatrix();     
    
  }
   
  //If projectile goes off screen, wrap it around to other side
  void screenWrap()
  {
    if(position.x > width+20)
      position.x = -20;
    else if(position.x < -20)
      position.x = width+20;
     
    if(position.y > height+20)
      position.y = -20;
     
    else if(position.y < -20)
      position.y = height+20;
    
  }
  
  
  
  
  
  
  
}
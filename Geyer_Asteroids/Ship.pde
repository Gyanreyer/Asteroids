//Player's Ship //<>// //<>//
class Ship
{

  PShape shipShape;
  PShape boostShape;

  

  float boundingRadius;//Radius of bounding circle for collisions

  float rotation;//Rotation of ship
  float rotationSpeed;//Speed that ship rotates at
  float accelMagnitude;//Constant for acceleration of ship
  float maxSpeed;//Maximum magnitude of ship's velocity

  PVector position;//Vector for position of ship
  PVector velocity;//Vector for velocity of ship
  PVector acceleration;//Vector for acceleration of ship
  PVector direction;//Vector for direction ship is facing

  float fireTimer;//Keeps track of time between shots
  float fireRate;//Time between each shot

  boolean canFire;//Whether ship can fire or not based on timer
  boolean boosting;//Whether ship is boosting forward, used for visual effect of boost flame off back


  Ship()
  {
    fireTimer = 0;
    fireRate = 0.5;

    canFire = true;

    rotation = radians(270);

    //Create ship's shape with custom vertices
    shipShape = createShape();
    shipShape.beginShape();            
    shipShape.vertex(25, 0);
    shipShape.vertex(-25, 15);
    shipShape.vertex(-20, 0);
    shipShape.vertex(-25, -15);
    shipShape.endShape(CLOSE);

    shipShape.setFill(color(200));

    //Create ship's boost shape
    boostShape = createShape();
    boostShape.beginShape();
    boostShape.vertex(0, 0);
    boostShape.vertex(-10, 10);
    boostShape.vertex(-40, 0);
    boostShape.vertex(-10, -10);      
    boostShape.endShape(CLOSE);

    boostShape.setStroke(false);

    boundingRadius = 10;//Collision detection for ship is just a small circle in its center with radius of 10
                        //While this may not be exact it makes collision detection much easier, gives the player a bit more leighway to make mistakes, and is almost unnoticeable anyways

    position = new PVector(width/2, height/2);//Starting position in center of screen   
    direction = new PVector();//Direction calculated each frame in update   
    velocity = new PVector(0, 0);//Start stationary
    acceleration = new PVector(0, 0);

    accelMagnitude = 0.1;//When accelerating, velocity magnitude will be increased by 0.1 every frame

    rotationSpeed = 0.05;//Stationary rotation speed is same as acceleration

    maxSpeed = 5;//Limit for magnitude of velocity
  }

  //Updates ship every frame before being drawn
  void update()
  {   
    //If ship can't fire yet, increment fire timer until ready to fire again
    if (!canFire)
    {
      fireTimer += deltaTime;

      //If fire timer is greater than rate, set ability to fire to true and reset timer
      if (fireTimer > fireRate)
      {
        fireTimer = 0;
        canFire = true;
      }
    }

    //If left key is pressed, rotate CCW
    if (LEFT_KEY)
    {
      rotation -= rotationSpeed * 60*deltaTime;
    }

    //If right key is pressed, rotate CW
    else if (RIGHT_KEY)
    {
      rotation += rotationSpeed * 60*deltaTime;
    }

    //Get direction from rotation
    direction = PVector.fromAngle(rotation);

    //If up key is pressed, accelerate in direction ship is facing
    if (UP_KEY)
    {      
      acceleration = PVector.mult(direction, accelMagnitude);
      drawManager.addScreenShake((velocity.mag())*25);//Add screen shake based on velocity to add a cool extra sense of speed
      
      boosting = true;//Set boosting to true to indicate that boost flames should be drawn
    }

    //If down key is pressed, accelerate slightly slower in opposite direction ship is facing
    else if (DOWN_KEY)
    {
      acceleration = PVector.mult(direction, -0.75*accelMagnitude);
      boosting = false;
    }

    //IF neither acceleration button is being pressed, ship will naturally decelerate
    else
    {             
      decelerate();
      boosting = false;
    }

    //If fire key is pressed and ship is ready to fire
    if (FIRE_KEY && canFire)
    {      
      projManager.fireProjectile(position, direction, rotation);//Fire projectile with projectile manager
      canFire = false;//Set ability to fire to false
    }

    //Rotation speed decreases as ship moves faster to sorta simulate drifting
    rotationSpeed = 0.1 / (velocity.mag()+2);

    
    velocity.add(PVector.mult(acceleration, 60*deltaTime));//Add acceleration to velocity of ship to change movement speed appropriately
    velocity.limit(maxSpeed);//Limit velocity to max magnitude of 5


    position.add(PVector.mult(velocity, 60*deltaTime));//Add velocity to position of ship to move it

    screenWrap();//Wrap position around edges of screen if necessary
    
    //Check for collision between player and asteroids, if any collisions occur then player dies
    if (astManager.detectCircleCollision(position, boundingRadius))
    {
      die();
    }
  }

  //Update and draw ship to screen
  void display()
  {        
    //Transform matrix and draw ship to screen
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);

    shape(shipShape);

    //If boosting, display boost flames in back of ship
    if (boosting)
    {      
      pushMatrix();
      translate(-17, 0);
      
      pushMatrix();
      boostShape.setFill(color(255, 200, 0, 200));
      scale(map(velocity.mag(), 0, maxSpeed, 0.5, 1), map(velocity.mag(), 0, maxSpeed, 1.5, 0.75));//Boost flames stretch out as velocity increases
      shape(boostShape);
      boostShape.setFill(color(255, 255, 0, 128));
      scale(0.75, 0.5);
      shape(boostShape);
      popMatrix();

      //Glow around boost flames
      translate(-23, 0);
      noStroke();
      fill(255, 255, 0, 16);
      ellipse(0, 0, 50, 50);
      fill(255, 128, 0, 8);
      ellipse(0, 0, 150, 150);

      popMatrix();
    }
    popMatrix();
    
    
    if(debugMode)
    {
      pushMatrix();
      translate(position.x, position.y);
      
      noFill();
      stroke(0,0,255);
      ellipse(0,0, 2*boundingRadius, 2*boundingRadius);//Show bounding circle for collision
      
      line(0,0,direction.x*100,direction.y*100);//Draw line to show direction pointing in
      stroke(0,255,0);
      line(0,0,velocity.x*20,velocity.y*20);//Draw line to show velocity
      
      popMatrix();
    }
    
  }


  //Slow ship down when not accelerating
  void decelerate()
  { 
    //Get current direction that velocity is going in
    acceleration = velocity.copy().normalize();

    //If velocity in x direction has been reduced to within a certain range, snap to 0
    if (velocity.x < accelMagnitude && velocity.x > -accelMagnitude)
    {
      acceleration.x = 0;
      velocity.x = 0;
    }
    //Otherwise, decelerate by half of acceleration value
    else
    {
      acceleration.x *= -accelMagnitude*0.5;
    }

    //If velocity in y direction has been reduced to within certain range, snap to 0
    if (velocity.y < accelMagnitude && velocity.y > -accelMagnitude)
    {
      acceleration.y = 0;
      velocity.y = 0;
    }
    //Otherwise, decelerate by half of accel value
    else
    {
      acceleration.y*= -accelMagnitude*0.5;
    }
  }

  //If ship goes off screen, wrap around to other side
  void screenWrap()
  {
    float edgeBuffer = 25;//Width of how far ship can go off screen before wrapping around to other side

    //If position goes outside of bounds of screen and passes buffer, wrap to other side
    if (position.x > width+edgeBuffer)
      position.x = -edgeBuffer;
    else if (position.x < -edgeBuffer)
      position.x = width+edgeBuffer;

    if (position.y > height+edgeBuffer)
      position.y = -edgeBuffer;
    else if (position.y < -edgeBuffer)
      position.y = height+edgeBuffer;
  }

  //When player dies, play explosion at their position and change game state to game over
  void die()
  {    
    drawManager.addExplosion(25, position, 10, 30, 10);

    gameState = GameState.GameOver;
  }
}
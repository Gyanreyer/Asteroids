class AsteroidManager
{
  ArrayList<Asteroid> asteroidList;//ArrayList of all active asteroids
  
  float spawnTimer;//TImer to count down until next asteroid spawn
  float spawnInterval;//Interval between each spawn, gradually decreases over time to ramp up difficulty
  
  //Constructor
  AsteroidManager()
  {
    spawnTimer = 0;
    spawnInterval = 15;//Start out spawning an asteroid every 15 seconds
    
    asteroidList = new ArrayList<Asteroid>();
    
    //Start by spawning 5 asteroids
    while(asteroidList.size() < 5)
    {
      spawnAsteroid(); 
    }
  }

  //Update whether to spawn an asteroid or not
  void update()
  {    
    //Increment spawn timer
    spawnTimer += deltaTime;
    
    //If timer has reached spawn interval...
    if(spawnTimer>spawnInterval)
    {      
      spawnAsteroid();//Spawn an asteroid
      spawnTimer = 0;//Reset spawn timer
      
      //Limit spawn interval so it can't be lower than 7 seconds
      if(spawnInterval > 7)
        spawnInterval-=0.5;
    }
  }
  
  //Display asteroids
  void display()
  { 
    stroke(0);
    //For every active asteroid in list...
    for(int i = 0; i < asteroidList.size(); i++)
    {
      asteroidList.get(i).update(); //Update asteroid
      asteroidList.get(i).display(); //Display it
    }
  }
  
  //Spawn a large asteroid
  void spawnAsteroid()
  {
    PVector asteroidSpawnPos = new PVector(random(0,width),random(0,height));//Random point on screen where asteroid will spawn    
    float asteroidRadius = random(125,150);//Randomly determine asteroid's radius
      
    float distFromPlayer = asteroidSpawnPos.dist(player.position); //Distance between player position and spawn position
    float noSpawnZoneRadius = asteroidRadius+(player.boundingRadius*15); //Radius around player that should not be spawned in
       
     //If asteroid's spawn position is too close to the player, shift it outward to a safe distance
    if(distFromPlayer < noSpawnZoneRadius)
    {
      //Direction in which to shift asteroid away from player
      PVector shiftDirection = PVector.sub(asteroidSpawnPos,player.position);
           
      //It's essentially impossible for the asteroid to spawn perfectly on top of the player but just in case, shift it away in a random direction
      if(shiftDirection.x == 0 && shiftDirection.y == 0)
      {
        shiftDirection.x = random(0,1);
        shiftDirection.y = random(0,1);
      }

      //Normalize shift direction and then multiply to shift to edge of player spawn zone
      shiftDirection.normalize();
      shiftDirection.mult(noSpawnZoneRadius - distFromPlayer);                    
                     
      asteroidSpawnPos.add(shiftDirection);//Shift position out                 
    }
    
    //Add a new asteroid to list of active asteroids with 2 hits left, determined radius, and determined spawn position
    asteroidList.add(new Asteroid(2, asteroidRadius, asteroidSpawnPos));
  }
  
  //Detect collision between asteroids and a given point/radius
  boolean detectCircleCollision(PVector point, float otherRadius)
  {
    PVector testPos;//Vector to hold asteroid position to test  
    
    //Loop through all asteroids to check if given thing is colliding with any of them
    for(int i = 0; i < asteroidList.size(); i++)
    { 
      //If the asteroid is passing over an edge, need to check collision with its copies on the opposite sides of the screen as well
      for(int j = 0; j < (2*asteroidList.get(i).passEdges)-1; j++ )
      {
        testPos = asteroidList.get(i).edgePositions[j].copy();//Test positions of edge copies
        
        //If distance between test point and given point are less than their combined radii, they have collided
        if (testPos.dist(point) <= asteroidList.get(i).radius + otherRadius)
        {
          explodeAsteroid(i);//Break asteroid into smaller pieces (or if too small, just destroy it)
          return true;//Return that a collision has occured
        }
      }
      
      testPos = asteroidList.get(i).position.copy();//Test main position
      
      //If distance between test point and given point are less than their combined radii, they have collided
      if (testPos.dist(point) <= asteroidList.get(i).radius + otherRadius)
      {
        explodeAsteroid(i);//Explode asteroid
        return true;//Return that collision occured
      }
    }
    
    return false; //If no collisions with any of the asteroids, return that no collisions occured
  }

  //Take an asteroid at a given index in the asteroid list and blow it up
  void explodeAsteroid(int asteroidIndex)
  {
    if(asteroidList.size() >= asteroidIndex)
    {      
      //Get radius of asteroid being blown up, this will be divided into smaller pieces unless asteroid has no hits left
      float origRadius = asteroidList.get(asteroidIndex).radius; 
      
      //Play an explosion particle effect at asteroid's position with particle count, particle size, system size, and duration based on size of asteroid
      drawManager.addExplosion((int)origRadius/3, asteroidList.get(asteroidIndex).position, (float)origRadius/100, (float)origRadius/2, (float)origRadius/100);
      
      //If the asteroid has more hits left, divide it into smaller ones
      if(asteroidList.get(asteroidIndex).hitsLeft > 0)
      {      
        int hitsLeft = asteroidList.get(asteroidIndex).hitsLeft - 1;//Decrement hits left for smaller asteroids
        
        int numDivisions = (int)random(3,5);//Randomly decide whether to divide asteroid into 3 or 4 smaller ones
        
        //Spawn smaller asteroids with new hits left, smaller radius, and position of original asteroid
        for(int i = 0; i < numDivisions; i++)
        {
          asteroidList.add(new Asteroid(hitsLeft, origRadius/(numDivisions-1), asteroidList.get(asteroidIndex).position));
        
        }
      }     
    }
      
    asteroidList.remove(asteroidIndex); //Remove original asteroid from list, destroying it
  } 
    
    
    
}
  
  
  
class DrawManager
{
  PVector screenCoords;//Coordinates to shift screen to
  PVector coordChange;//Velocity of screen movement
  
  float shakeMagnitude;//Magnitude of screen shake
  
  ArrayList<ParticleSystem> partSys;//List of active particle systems
  
  //Constructor
  DrawManager()
  {        
    shakeMagnitude = 0;
    
    partSys = new ArrayList<ParticleSystem>();
    
    screenCoords = new PVector(0,0);
    
    coordChange = new PVector(0,0);
  }
  
  //Update screen shake
  void update()
  {    
    //Calculate how much to change screen coords by
    screenShake();
    
    //Halve shake magnitude so that it will naturally decrease over time
    shakeMagnitude/=2;    
    
    //If not shaking, screen position shifts slowly back to center
    if(shakeMagnitude == 0)
    {
      screenCoords.x -= screenCoords.x*.1*deltaTime;
      screenCoords.y -= screenCoords.y*.1*deltaTime;
      
      if(screenCoords.mag() < 1)//If screen pos is within small range of origin, just snap it to origin
      {
        screenCoords.set(0,0); 
      }     
    }
    
    //Shift screen coordinates
    screenCoords.add(PVector.mult(coordChange,deltaTime));
  }
  
  //Translate screen and draw particle systems
  void display()
  {             
    translate(screenCoords.x,screenCoords.y);//Translate whole screen
    
    //Loop through all particle systems and play them
    for(int i = 0; i< partSys.size(); i++)
    {
      if(!partSys.get(i).playParticles())//If a particle system is done, destroy it
      {
        partSys.remove(i);
        i--;
      }     
    }  
    
  }
 
 //Add a new explosion particle system
 //params: maxParticles-maximum number of particles in system
  void addExplosion(int maxParticles,PVector centerPoint, float particleRadius, float systemRadius, float duration)
  {
    partSys.add(new ParticleSystem(maxParticles, centerPoint, particleRadius, systemRadius, duration));
    
  }
  
  //Increase screen shake magnitude by given amount
  void addScreenShake(float magnitude)
  {
    shakeMagnitude += magnitude;
  }
  
  
  //Randomly decide what velocity to add to screen coordinates based on current shake magnitude
  void screenShake()
  {     
    coordChange.set(random(-shakeMagnitude,shakeMagnitude),random(-shakeMagnitude,shakeMagnitude));   
    
    coordChange.limit(100);
      
    
    
  }
  
  
  
  
  
  
  
  
}
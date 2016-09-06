import java.util.Random;

//NOTE TO GRADER: I'm partially recycling this from the particle system I made in my rolling on random project, although this has been significantly updated and tweaked
class ParticleSystem
{

  Random randGenerator;
  
  PVector[] particlePositions;//Array of positions where each particle will be drawn at
   
  float timeElapsed; //Timer to keep track of how long particles have been playing
  float duration; //Duration particles play for
  
  float systemRadius;//Radius of area in which particles spawn
  float particleRadius; //Radius of particles within system
  
  PVector center;//Position of system's center
   
  //Constructor (params: maxParticles-number of particles in system, cent-vector for center of system,
  // partRad-starting radius of particles, sysRad-radius of particle system spawn area, dur-duration system will play for)
  ParticleSystem(int maxParticles, PVector cent, float partRad, float sysRad, float dur)
  {
    randGenerator = new Random();//Initialize random generator for gaussian distribution of particles around center
        
    particleRadius = partRad;    
    systemRadius = sysRad;    
    center = cent.copy();
    duration = dur;
    
    particlePositions = new PVector[maxParticles];
    
    //Loop through all particle positions and give them random positions
    for(int i = 0; i < maxParticles; i++)
    {
      particlePositions[i] = new PVector((float)randGenerator.nextGaussian()*systemRadius+center.x,(float)randGenerator.nextGaussian()*systemRadius+center.y);
      
      screenWrap(i);//If position was off-screen, wrap to other side
    }
      
    timeElapsed = 0;
    
  }

  //Center: coordinates that particle system will center around, mean of gaussian dist
  //Size: How spread out particles will be in x and y directions, standard dev of gaussian dist
  boolean playParticles()
  {   
    //If system has run for given duration, return early that system is done and it will be destroyed in drawManager
    if(timeElapsed>duration)
    {            
      return false;      
    }
    
    //Calculate number of particles to display this frame, number increases and then decreases over duration to fade in/out
    int numDisplay = (int)((particlePositions.length-1) * (duration-timeElapsed)/duration);
        
    
    //Increment time  by fraction of framerate
    timeElapsed += deltaTime;        
          
     noStroke();     
    //Display appropriate number of particles
    for(int i = 0; i < numDisplay; i++)
    {   
        fill(random(127,255),random(63,127),random(0,63),map(numDisplay,0,particlePositions.length-1,0,127));//Randomly determine color of particle and mape its alpha so that it fades in and out with the number of particles being drawn
        ellipse(particlePositions[i].x, particlePositions[i].y, particleRadius*2, particleRadius*2);
        
    }
    
    particleRadius+=deltaTime*50/duration;//Slowly increase size of particles
    
    
    //Randomly change the position of up to 1/20 of particles to be displayed
    for(int i = 0; i < random(0,numDisplay/20); i++)
    {
      particlePositions[i].set((float)randGenerator.nextGaussian()*systemRadius+center.x,(float)randGenerator.nextGaussian()*systemRadius+center.y);
      
      screenWrap(i);
    }
    
    drawManager.addScreenShake(systemRadius/timeElapsed);//Shake the screen based on size of system
    
    return true;//Return that particle system is still playing
  
  }
  
  //If a particle's position goes off the side, wrap it around to the other side
  void screenWrap(int index)
  {    
    if (particlePositions[index].x > width+particleRadius)
      particlePositions[index].x -= width;
    else if (particlePositions[index].x < -particleRadius)
      particlePositions[index].x += width;

    if (particlePositions[index].y > height+particleRadius)
      particlePositions[index].y = -particleRadius;
    else if (particlePositions[index].y < -particleRadius)
      particlePositions[index].y = height+particleRadius;
  }
  
  
  
  
  
}
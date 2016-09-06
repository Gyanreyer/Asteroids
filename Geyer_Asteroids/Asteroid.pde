class Asteroid //<>//
{
  PShape asteroidShape;//Asteroid's custom pshape, will have randomly varied vertices in a circle around center pt

  int hitsLeft;//If hit, asteroid will divide and each child asteroid can take one less hit- if hitsLeft is 0, no children will be spawned

  float radius;//Collision circle radius, also used for generation of random vertices

  PVector position;//Position in world
  PVector velocity;//Velocity to modify position each frame
  
  int passEdges;//Number of edges passing over, can be 0, 1, or 2  
  
  PVector[] edgePositions;//List of alternative positions for copies to be displayed on opposite sides of screen for screen wrapping
  
  //Constructor (params: rad-sets radius of asteroid, hits-sets number of hits left, spawnPos-sets initial position of asteroid where it will spawn)
  Asteroid(int hits, float rad, PVector spawnPos)
  {

    hitsLeft = hits;
    radius = rad;    
    position = spawnPos.copy();
    
    edgePositions = new PVector[4];
    
    for(int i = 0; i < edgePositions.length; i++)
    {
      edgePositions[i] = new PVector(); 
    }

    //Determine a random direction for asteroid to start moving in within this asteroid's radius
    velocity = new PVector(random(-radius, radius), random(-radius, radius));

    //If this asteroid is a smaller child asteroid, shift its pos by the generated direction so child asteroids won't all spawn bunched up in center of parent
    if (hitsLeft<2)
      position.add(velocity);

    //Now normalize velocity and set speed so that larger asteroid is slower than smaller ones
    velocity.normalize();
    velocity.mult(25/radius);
    

    int numVertices = (int)random(6, 10);//Randomly determine how many vertices asteroid's shape will have-can be between 6 and 9

    float circleValue = random(0, TWO_PI);//Value used with trig to get coords of circle around center point.  Randomized so that asteroid's vertices will be more varied between each one

    //Start asteroid's shape generation
    asteroidShape = createShape();
    asteroidShape.beginShape();  

    //Loop for each vertice of asteroid
    for (int i = 0; i < numVertices; i++)
    { 
      //Create loop around unit circle around center point with cos(x),sin(x)
      //Multiply these values by random variation on radius so that points are less uniform and look nicer
      asteroidShape.vertex(cos(circleValue)*(float)random(0.8*radius, 1.2*radius),
          sin(circleValue)*(float)random(0.8*radius, 1.2*radius));

      //Increment circle value by fraction of circle
      circleValue += TWO_PI/numVertices;
    }
    asteroidShape.endShape(CLOSE);

    asteroidShape.setFill(color(220,random(100,150), 64));//Randomly varied brown/gold-ish color, nice and bright to both make game more visually interesting and help the player stay more aware of where the asteroids are around them
    asteroidShape.setStroke(color(0));
  }


  //Update function runs every frame before displaying
  void update()
  {
    //Move by velocity
    position.add(PVector.mult(velocity, 60*deltaTime));
    //Wrap position around screen if necessary
    screenWrap();
  }

  //Draw asteroid to screen each frame
  void display()
  {
    //If the asteroid is passing over an edge, draw the appropriate number of duplicates for the other side - if 1 edge, only loop once to draw the first item in array, if 2 edges, loop three times to draw a copy in each corner
    for(int i = 0; i < (2*passEdges-1); i++)
    {
      pushMatrix();
      
      translate(edgePositions[i].x,edgePositions[i].y);    
      shape(asteroidShape);      
      
      if(debugMode)
      {
        noFill();
        stroke(255, 0, 0);
        ellipse(0, 0, 2*radius, 2*radius);//Draw bounding circle for collision
        
        line(0,0,velocity.x*300, velocity.y*300);//Draw line to indicate direction and speed relative to other asteroids
        
      }
      
      popMatrix();
      
    }
            
    //Translate to position and draw
    pushMatrix();
    translate(position.x, position.y);

    shape(asteroidShape); 

    if(debugMode)
    {
      noFill();
      stroke(255, 0, 0);
      ellipse(0, 0, 2*radius, 2*radius);//Draw bounding circle for collision
      
      line(0,0,velocity.x*300, velocity.y*300);//Draw line to indicate direction and speed relative to other asteroids
    }

    popMatrix();
  }


  //When the asteroid goes off the screen, redraw its edges on the other side for a nice clean wrap
  //Holy crap was this annoying to do.  But in my opinion it's totally worth it, from a design perspective sometimes it was hard to see where asteroids were if they were partially off-screen so now they're always visible
  void screenWrap()
  {
    passEdges = 0;//Reset number of edges asteroid is passing over
    
    //If the asteroid is touching an edge anywhere...
    if(position.x + radius > width || position.x - radius < 0 || position.y + radius > height || position.y - radius < 0)
    {
      //Set all potential edge positions to default (asteroid's current position)
      for(int i = 0; i < edgePositions.length; i++)
      {
        edgePositions[i].set(position.x, position.y);
      }
    
      //If the asteroid is off screen to the right...
      if(position.x + radius > width)
      {
        //...and the asteroid isn't COMPLETELY off the screen...
        if(position.x < width+radius)
        {
          edgePositions[passEdges].x -= width;//Set this edge position to its counterpart on the opposite (left) side of the screen
          passEdges++;//Increment number of edges passing over
        }
        
        //...otherwise if it IS completely off the screen, set the actual position to left side, no more need for alternate edge positions on this axis
        else     
          position.x -= width;;   
      }
      
      //If the asteroid is off screen to the left...
      else if(position.x - radius < 0)
      {     
        //...and asteroid isn't completely off screen...
        if(position.x > -radius)
        {
          edgePositions[passEdges].x += width;//Set this edge position to its counterpart on the opposite side (right) of the screen
          passEdges++;//Increment number of edges passing over
        }
          
        //...otherwise if it IS completely off the screen, set the actual position to right side
        else
          position.x += width;;
      }

      //If asteroid is off screen to top...
      if(position.y + radius > height)
      {
        //...and asteroid isn't scompletely off screen...
        if(position.y < height+radius)
        {
          edgePositions[passEdges].y -= height;//Set this edge position to its counterpart on the opposite side (bottom) of the screen
          passEdges++;//Increment number of edges passing over
        }
          
        //...otherwise if it IS completely off screen, set actual position to bottom side
        else
          position.y -= height;
      }

      //If asteroid is off screen to bottom...
      else if(position.y - radius < 0)      
      {     
        //...and asteroid isn't completely off screen...
        if(position.y > -radius) 
        {        
          edgePositions[passEdges].y += height;//Set this edge position to its counterpart on the opposite side (top) of the screen
          passEdges++;//Increment number of edges passing over
        }
        
        //...otherwise if it IS completely off the screen, set the actual position to top side
        else
          position.y += height;       
      }
      
      //If passing over 2 edges at once, this asteroid will need to be drawn 4 times (once in each corner) in order to look right
      if(passEdges == 2)
      {
        edgePositions[2].set(edgePositions[0].x,edgePositions[1].y);//Third additional position is mirrored on both axes
        
      }
      
    }
      
  }
}
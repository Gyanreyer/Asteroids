class ProjectileManager
{
  ArrayList<Projectile>firedProjectiles;//List that holds all active projectiles fired
  
  //Constructor
  ProjectileManager()
  {
    firedProjectiles = new ArrayList<Projectile>();
  }
  
  //Update projectiles positions, check collision, and determine whether active
  void update()
  {
    //Run through all projectiles
    for(int i = 0; i < firedProjectiles.size(); i++)
    {
      //If no longer active or collided with an asteroid, destroy the projectile
      if(!firedProjectiles.get(i).updateActive() ||
          astManager.detectCircleCollision(firedProjectiles.get(i).position, firedProjectiles.get(i).radius))
      {
        firedProjectiles.remove(i);
        i--;
      }      
    }  
  }
  
  //Display all projectiles
  void display()
  {
    for(int i = 0; i < firedProjectiles.size(); i++)
    {                 
      firedProjectiles.get(i).display(); 
    }   
  }
  
  //Add a projectile to list of active projectiles with given start position, direction, and rotation
  void fireProjectile(PVector position, PVector direction, float rotation)
  {
    firedProjectiles.add(new Projectile(position, direction, rotation, 10, 2));
  }
  
  
}
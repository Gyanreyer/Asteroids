//Enum for state that game is in
enum GameState
{
  StartMenu,
  Game,
  GameOver  
};

//CONTROLS: Rebindable in controls text file but defaults are WASD for movement, SPACEBAR to fire, F for debug mode
boolean UP_KEY,DOWN_KEY,LEFT_KEY,RIGHT_KEY, FIRE_KEY;

char up,down,left,right,fire,debug;//Values of keys from controls text file to be compared against in KeyPressed()

float deltaTime, newTime, oldTime;//Used to calculate time passed between each frame in order to keep movement independent of framerate

boolean debugMode;//Turning on will show frame rate in top right corner and lines to represent collision radii, direction, and velocity of asteroids and ship


GameState gameState;//State that game is currently in, can be start menu screen, main game, or game over screen

Menu menu;//Handles menus to show for start and game over

Ship player;//Ship controlled by player

AsteroidManager astManager;//Manages spawning, updating, and displaying asteroids

ProjectileManager projManager;//Manages updating and displaying projectiles

DrawManager drawManager;//Manages extra animation related stuff like particle systems and screen shake


void setup()
{
  size(1280,720,P2D);
  frameRate(999);//Unlocked framerate
    
  newTime = 0;
  oldTime = 0;  
  
  getControlSettings();//Get the game's controls from the text file
  
  menu = new Menu();  
  gameState = GameState.StartMenu;  
   
  
}

void draw()
{  
  //Calculate delta time with difference of time between this frame and last frame
  oldTime = newTime;
  newTime = millis();  
  deltaTime = (newTime-oldTime)/1000;
  
  
  background(0);
  
  //Update and draw start menu
  if(gameState == GameState.StartMenu)
  {
    menu.updateStart();
    menu.displayStart();      
  }
    
  //Update and draw main game
  else if(gameState == GameState.Game)
  {
    pushMatrix();    
    player.update();
    projManager.update();
    astManager.update();
    drawManager.update();
     
    drawManager.display();
    
    player.display(); 
    projManager.display();
    astManager.display();  
    
    popMatrix();
    
  }
  
  //Update and draw game over screen
  else if(gameState == GameState.GameOver)
  {
    cursor();//Bring back cursor for menu navigation
    
    //Continue drawing stuff in the background
    pushMatrix();
    drawManager.update();
    projManager.update();
        
    drawManager.display();    
    projManager.display();
    astManager.display();
    popMatrix();
    
    menu.updateGameOver();
    menu.displayGameOver();
    
  }
  
  //If in debug mode, show frame rate in upper right corner
  if(debugMode)
    {
      fill(255);
      textSize(32);
      text(frameRate,width-100,50);
    }
  
}

//Reset everything to start a new game
void setupGame()
{
  fill(255);
  stroke(0);
  
  player = new Ship();
  
  projManager = new ProjectileManager();
  
  astManager = new AsteroidManager();
  
  drawManager = new DrawManager();
  
  noCursor();//Hide cursor while game is playing
}

//Gets the game controls from text file
//NOTE ON FORMAT OF TEXT FILE: Needs to be CONTROL=key
//Unfortunately non-ascii keys aren't supported
void getControlSettings()
{
  String[] keySettings = loadStrings("controls.txt");//Read controls.txt, each line is one element in array
  
  String[] defaults = {"w","s","a","d"," ","f"};//Default key settings, used in case the controls file gets messed up and a control doesn't have a value
  
  //Loop through lines from text file
  for(int i = 0; i<keySettings.length;i++)
  {
    keySettings[i] = split(keySettings[i],'=')[1].toLowerCase();//Split each line at the equals sign and only keep the part after it, then convert this to lower case
    
    if(keySettings[i].length() != 1)//If the control isn't a single character...
    {
      //The word "space" can be used to represent the spacebar, this will recognize that and convert it appropriately
      if(keySettings[i].equalsIgnoreCase("space"))      
        keySettings[i] = " "; 
        
      else
        keySettings[i] = defaults[i];//If the key binding is missing, just set it to default
    }

       
  }
  
  //Set all controls to corresponding characters
  up = keySettings[0].charAt(0);
  down = keySettings[1].charAt(0);
  left = keySettings[2].charAt(0);
  right = keySettings[3].charAt(0);
  fire = keySettings[4].charAt(0);
  debug = keySettings[5].charAt(0);
}



void keyPressed()
{
    char checkKey = Character.toLowerCase(key);
  
    if(checkKey == left)
      {
        LEFT_KEY = true;  
      }
      
      if(checkKey == right)
      {
        RIGHT_KEY = true;
      }
      
      if(checkKey == up)
      {
        UP_KEY = true;
      }
      
      if(checkKey == down)
      {
        DOWN_KEY = true;
      }
      
      if(checkKey == fire)
      {
        FIRE_KEY = true;
      }
      
}

void keyReleased()
{
  char checkKey = Character.toLowerCase(key);
  
  if(checkKey == left)
      {
        LEFT_KEY = false;  
      }
      
      if(checkKey == right)
      {
        RIGHT_KEY = false;
      }
      
      if(checkKey == up)
      {
        UP_KEY = false;
      }
      
      if(checkKey == down)
      {
        DOWN_KEY = false;
      }
      
      if(checkKey == fire)
      {
        FIRE_KEY = false;
      }
      
      //Switches to debug mode on release of key, did it this way so will only switch once per key press
      if(checkKey == debug)
      {
        debugMode = !debugMode;
      }  
  
}
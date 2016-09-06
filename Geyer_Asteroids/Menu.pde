class Menu
{  
  PFont font;//Font to be used for menu text
  
  //Main start menu buttons
  MenuButton startButton, quitButton;
  
  //Game over menu buttons
  MenuButton retryButton, gameOverQuitButton;
  
  
  
  //Constructor
  Menu()
  {   
    //Initialize buttons
    startButton = new MenuButton(width/2,height/2,"START");
    quitButton = new MenuButton(width/2,125+height/2,"QUIT");    
    
    retryButton = new MenuButton(width/2,height/2,"RETRY");
    gameOverQuitButton = new MenuButton(width/2,125+height/2,"QUIT");
    
    //Load font and set up text settings
    font = loadFont("AgencyFB-Bold-48.vlw");
    textFont(font,100);
    textAlign(CENTER, CENTER);   
  }
  
  //Update start menu
  void updateStart()
  {
    //If start button clicked, run setup for game and change game state to play game
    if(startButton.clicked())
    {
      setupGame();
      gameState = GameState.Game;         
    }
    //If quit button clicked, exit game
    else if(quitButton.clicked())
    {
      exit();      
    }    
  }
  
  //Display start menu
  void displayStart()
  { 
    //Display title
    fill(255);
    textSize(150);
    text("ASTEROIDS",width/2,height/4);
    
    //Display buttons
    startButton.display();
    quitButton.display();
  }
    
  //Update game over menu
  void updateGameOver()
  {
    //If retry button clicked, run setup for new game and change game state to play game again
    if(retryButton.clicked())
    {
      setupGame();
      gameState = GameState.Game;           
    }
    //If quit button clicked, exit game
    else if(gameOverQuitButton.clicked())
    {
      exit();
    }   
    

    
  }
  
  //Display game over menu
  void displayGameOver()
  {    
    //Display game over title
    fill(255);
    textSize(150);
    text("GAME OVER",width/2,height/4);
    
    //Display buttonsgameSettings[0].equals("true")
    retryButton.display();
    gameOverQuitButton.display();
    
  } 
  
  
}
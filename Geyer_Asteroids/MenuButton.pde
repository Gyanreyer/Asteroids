class MenuButton
{
  PShape buttonShape;//Shape to be drawn button
  
  PVector buttonPosition;//Position of button
  
  String buttonText;//Text for button
  
  float fontSize;
  
  //Constructor (params: x,y-x and y positions on screen, text-text to be shown on button)  
  MenuButton(float x, float y, float w, float h, String text)
  {
    fontSize = h;
    
    buttonText = text;
    
    buttonShape = createShape(RECT,-w/2,-h/2,w,h); 
    
    buttonPosition = new PVector(x,y);
  }
  
  //Buttons with no specified dimensions default to 300x100
  MenuButton(float x, float y, String text)
  {
    this(x,y,300,100,text);   
  }
  
  //Change button color when moused over and return whether button clicked or not
  boolean clicked()
  {
    //If mouse intersecting with button...
    if(mouseX < buttonPosition.x+150 && mouseX > buttonPosition.x-150
      && mouseY < buttonPosition.y+50 && mouseY > buttonPosition.y-50)
    {
      //Change fill color
      buttonShape.setFill(color(100));
      
      //If mouse clicked, return true
      if(mousePressed && mouseButton==LEFT)
      {
        return true;
      }
    }
    else
    {
      buttonShape.setFill(color(150));//If mouse not over button, return to default fill color
    }
    
    return false;//If not clicked, return false   
  }
  
  //Display the button to the screen
  void display()
  {    
    fill(255);
    textSize(fontSize);
    
    pushMatrix();
    translate(buttonPosition.x, buttonPosition.y);    
    shape(buttonShape);    
    text(buttonText,0,0);
    popMatrix();
  }
  

  
  
  
}
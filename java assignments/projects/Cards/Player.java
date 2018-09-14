
/**
 * Write a description of class player here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Player 
{
  
    Hand hand;
  
  String name="";
  Player(String name){
    this.name = name;
    this.hand= new Hand(5);

  }
  
  public String showHand() { 
    return this.name + " " + this.hand ; 
  } 

  
}

    



/**
 * Write a description of class dealer here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;
class Dealer extends Player {
    
  private String name;
  Dealer() {
      
      super("dude");  
  }
 
  void deal(Deck d, Player play) { 
    card c = d.dealCard(); 
    System.out.println(this.name + " " + c); 
    play.hand.addCard(c);  
  }

}
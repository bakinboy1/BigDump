
/**
 * Will be used by company to test whether you implemented 
 * the required interface
 * We want tester to generic. Can be used to test any class 
 * that already implements the interface
 * 
 * 
 * @author Company 
 * @version 3/30/2016
 */
public class Tester
{
   public static void main(String[] args){
       //Create an object of John Doe' class
       CanEncrypt e1 = new Encryptor1();
       //testing code (may span thousands of lines
       //Calls methods from the interface
       //Illustrates polymorphism
       //ability to treat object of different
       //type in the same way
       //Also illustrates Dynamic method lookup
       //
       System.out.println(e1.cesar("HELLO WORLD"));
       for(int sh = 1; sh <=26;sh++){
         System.out.println(e1.shiftByN("HELLO WORLD", sh));
       }
       
       char[] key = {'B', 'A', 'D', 'C', 'F', 'E', 'H', 'G',
                      'J', 'I', 'L', 'K', 'N', 'M', 'P', 'O',
                      'R', 'Q', 'T', 'S', 'V', 'U', 'X', 'W',
                     'Z', 'Y'};
       System.out.println(e1.substitute("HELLO WORLD", key));
    }
}

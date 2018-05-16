
/**
 * Write a description of class RoverTester here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */

public class RoverTester
{
  public static void main (String[] args){
    Rover rt1= new Rover();
    
    System.out.println(rt1.elevation());
    System.out.println(rt1.quadrant());
    System.out.println(rt1.distance());
    System.out.println(rt1.roverName("Potato"));
    System.out.println(rt1.intact());
    System.out.println(rt1.hop());
    System.out.println(rt1.hop());
    System.out.println(rt1.intact());
    }
}

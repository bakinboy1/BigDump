
/**
 * Tests the Magical Calculator
 * 
 * @author Radhouane
 * @version 2/19/2016
 */
public class Tester
{
   public static void main(String[] args){
       MyMagicalCalculator mc1 = new MyMagicalCalculator();
       System.out.println(mc1.add(2, 3));
       System.out.println(mc1.add("Hello", "Bob"));
       System.out.println(mc1.add(1.2, -1.57));
       System.out.println(mc1.add(5, 11.2));
       System.out.println(mc1.add("T", 1000));
       System.out.println(mc1.compare("Good", "Day"));
       System.out.println(mc1.computeCircleArea(4.0));
    }
}

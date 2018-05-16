
/**
 * Tests ChocolateBAr class
 * 
 * @author (Fabian Hucke) 
 * @version (a version number or a date)
 */
public class ChocolateBarTester
{
   public static void main(String[] args){
       //Instantiate an object of type ChocolateBar
       // creates new object defined by this method
       ChocolateBar myBar = new ChocolateBar ();
       System.out.println(myBar.toString());
       //System.out.println(myBar.getUnitCost());
       //System.out.println(myBar.getBrand());
       ChocolateBar myBar2 = new ChocolateBar (2,true,"Twix");
       //System.out.println(myBar2.getUnitCost());
       //System.out.println(myBar2.getBrand());
       //System.out.println(myBar2.getDark());
       myBar2.setUnitCost(-2.25);
       //System.out.println(myBar2.getUnitCost());
       //System.out.println(myBar2.getInfo());
    } 
}


/**
 * Write a description of class Tester here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Tester
{
       public static void main (String args[]){
        Bicycle myBike= new Bicycle(3,4,16);
        Bicycle myBike2= new Bicycle();
        Bicycle myBike3= new MountainBike(2,4,8,"low");
        myBike.printDescription();
        myBike2.printDescription();
        myBike3.printDescription();
        }
}

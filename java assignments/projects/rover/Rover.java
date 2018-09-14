
/**
 * Write a description of class Rover here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;
public class Rover
{
    boolean flag=true;
    private final String planet = "MERCURY";

    public String elevation (){
        double elevation= 0.0+(double)(Math.random()*1000);
        return "the rover's elevation is "+ elevation+ " meters \n";
    }

    public String quadrant (){
        double latitude= 0.0+(double)(Math.random()*1000.0);
        double longitude= 0.0+(double)(Math.random()*1000.0);
        return "latitude: "+latitude+", \n longitude: "+longitude+"\n";
    }

    public String distance(){
        int distance= 30000000+(int)(Math.random()*77000000);
        return "the rover is "+ distance + " miles from Earth";
    }

    public String roverName(String roverName){
        return "your rover is named: "+roverName;
    }

    public String intact(){
        return "is the rover intact? "+ flag;
    }
    
    public String hop(){
        int hop = 1 + (int)(Math.random() * 100);
        if (hop%10!=0){
            return "your rover hopped " + hop +" meters \n";
            
        }
        else{
                flag=false;
                return "your rover landed on its side and broke";
            }

    }

}

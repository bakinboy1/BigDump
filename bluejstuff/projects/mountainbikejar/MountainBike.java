
/**
 * Write a description of class MountainBike here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class MountainBike extends Bicycle
{
    private String suspension;

    public MountainBike(int newCadence, int newGear, int newSpeed, String newSuspension){
        super(newCadence, newGear, newSpeed);
        setSuspension(newSuspension);
    }
    bicycle b= new MountainBike();
    public void setSuspension(String newSuspension){
        suspension=newSuspension;
    }

    public String getSuspension(){
        return suspension;
    }
    public void printDescription(){
    super.printDescription();
    System.out.println("/n"+"suspension: " + suspension);
    }
    
}

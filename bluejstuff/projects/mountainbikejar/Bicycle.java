
/**
 * Write a description of class Branch here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.ArrayList;
public class Bicycle{
    protected int cadence;
    protected int gear;
    protected int speed;

    public Bicycle(){
        setCadence(0);
        setGear(1);
        setSpeed(0);
    }

    public Bicycle(int newCadence, int newGear, int newSpeed){
        setCadence(newCadence);
        setGear (newGear);
        setSpeed (newSpeed);
    }

    public void setCadence(int newCadence){
        cadence=newCadence;
    }

    public void setGear(int newGear){
        gear=newGear;
    }

    public void setSpeed(int newSpeed){
        speed=newSpeed;
    }

    public void applyBrake(int decrement){
        speed=speed-decrement;
    }

    public void speedUp(int increment){
        speed=speed+increment;
    }

    
    public int getCadence(){
        return cadence;
    }

    public int getGear(){
        return gear;
    }

    public int getSpeed(){
        return speed;
    }

    public void printDescription(){
        System.out.println("Speed is: " + speed +"\n"+"Gear is: " + gear +"\n"+"Cadence is: " + cadence);
    }
}


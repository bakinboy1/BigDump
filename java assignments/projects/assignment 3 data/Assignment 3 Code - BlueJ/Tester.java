
/**
 * Write a description of class Tester here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;
public class Tester
{
    public static void main (String args[]){
        CellDeviceStore link= new CellDeviceStore();
        Device dev= new Device(0);
        Device div= new Device(1);
        link.enqueueDevice(dev);
        link.enqueueDevice(div);
        link.enqueueDevice(div);
        link.enqueueDevice(dev);
        link.enqueueDevice(dev);
        link.enqueueDevice(div);
        
        Device k=link.dequeueAnyDevice();
        
        System.out.println(k);
        
    
    }
    
}

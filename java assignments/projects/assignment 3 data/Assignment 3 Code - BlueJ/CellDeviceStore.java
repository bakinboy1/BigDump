
/**
 * Write a description of class CellDeviceStore here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
  
import java.util.*;
 //class CellDeviceStore implements the Assignment3Store interface
public class CellDeviceStore
{
    
    Queue <Device> Peach = new LinkedList <Device>();
    Queue <Device> Cyborg = new LinkedList <Device>();
    public void enqueueDevice(Device dev){
       
        if (dev.getBrand()==0){
      
           Cyborg.add(dev);
           //Calendar.getInstance().getTimeinMillis(); 
           
        }
       else if (dev.getBrand()==1){
           Peach.add(dev);
           
        }
       dev.setArrivalTime(Calendar.getInstance().getTimeInMillis() );
    }
    public Device dequeueAnyDevice(){
        Device p=Peach.peek(); 
        Device c=Cyborg.peek();
        if (p.isOlder(c)==true){
            return dequeuePeach();
        }
        else{
            return dequeueCyborg();
        }
    }
    public Device dequeuePeach() {
       
            Device d=Peach.remove();
            return d;
    }
    public Device dequeueCyborg(){
        
            Device d=Cyborg.remove();
            return d;
        
        
    }
    
    
}

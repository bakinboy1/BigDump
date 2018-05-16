
/**
 * Practice for project 1
 * 
 * @author Micah Edwards
 * @version 2/3/2016
 */
public class Bass
{
    String fishName;
    int length;
    double weight;
    boolean isLargemouth;
    
    public Bass(){
        fishName = "Jaws";
        length = 12;
        weight = 6.5;
        isLargemouth = true;
    }
    
    public Bass(String newFishName, int newLength, double newWeight, boolean newIsLargemouth){
        fishName = newFishName;
        length = newLength;
        weight = newWeight;
        isLargemouth = newIsLargemouth;
    }
    public String getFishName(){
        return fishName;
    }
    
    public int getLength(){
        return length;
    }
    
    public double getWeight(){
        return weight;
    }
    
    public boolean getIsLargemouth(){
        return isLargemouth;
    }
    
    public String toString(){
        return fishName + "\n" + length + "\n" + weight + "\n" +isLargemouth;
    }
    
    
}

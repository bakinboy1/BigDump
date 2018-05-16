
/**
 * Practice for project 1
 * 
 * @author Micah Edwards 
 * @version 2/3/2016
 */
public class WeighIn
{
    public static void main(String[] args){
        Bass b1 = new Bass();
        System.out.println(b1.toString());
        
        Bass b2 = new Bass("Oscar", 9, 4, true);
        System.out.println(b2.toString());
        
        Bass b3 = new Bass("Kraken", 1000, 800, false);
        System.out.println(b3.toString());
    }
}

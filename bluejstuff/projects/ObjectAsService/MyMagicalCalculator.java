
/**
 * Defines a Claculator Type as a provider
 * of services
 * 
 * 1) Method overloading
 * 
 * @author Radhouane
 * @version 2/19/2016
 */
public class MyMagicalCalculator
{
    //Constant will not change
    //Reason 1: Do not want it to be inadvertantly modified
    //Reason 2: Do not have to retypethe value. We are sure t's 2.24
    //Reason 3: All methods have access to this value.
  
    private final double PI = 3.14;
    
    public double computeCircleArea (double radius){
        return PI * radius * radius;
    }
    
    public int add (int a, int b){
        return a + b;
    }
    //Method overloading
    //We keep the method name
    //But we are allowed to have as many paramd as we want
    //We can change param type and return type
    public String add (String a, String b){
        return a + b;
    }
    
    //Can overload the method as many times as we want
    public double add (double a, double b){
        return a + b;
    }
    
    //Can overload the method as many times as we want
    public double add (int a, double b){
        return a + b;
    }
    
    public int add (double b, int a){
        return Integer.parseInt(""+a + b);
    }
    
    //Can overload the method as many times as we want
    //Magical addition of String and double
    public String add (String a, double b){
        return a + b;
    }
    public boolean compare (String a, String b){
        return a.equals(b);
    }
    
    
}

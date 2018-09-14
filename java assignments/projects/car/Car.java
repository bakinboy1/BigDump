
/**
 * Write a description of class stuff here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
//create at least 4 instance variables with different types
//create a tester for your class
//instatiate at least 2 objects of the class
// print a text description of each variable
//mutate each object at least once
public class Car
{
   String model;
   int year;
   double price;
   boolean isUsed;
   /**
    * default values for object
    */
   public Car(){
       model="Lamborghini";
       year=2002;
       price=210000.00;
       isUsed=false;
       
    }
    /**
     * allows object values to be mutated
     */
    public Car(String newModel, int newYear, double newPrice, boolean newIsUsed){
        model=newModel;
        year=newYear;
        price=newPrice;
        isUsed=newIsUsed;
    }
    /**
     * methods that set and get object values
     */
   public void setModel(String newModel){
       model=newModel;
    }
    public String getModel(){
        return model;
    }
    
    public void setYear(int newYear){
        year=newYear;
    }
    public int getYear(){
        return year;
    }
    
    public void setPrice(double newPrice){
        price=newPrice;
    }
    public double getPrice(){
        return price;
    }
    
    public void setIsUsed( boolean newIsUsed){
        isUsed=newIsUsed;
    }
    public boolean getIsUsed(){
        return isUsed;
    }
    /**
     * toString that prints out all values of a called object
     */
    public String toString(){
        return "The car: "+model+ " costs $"+price+" \n Is it used? "+isUsed+"\n Its year model is "+year+"\n";
    }
}


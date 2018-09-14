
/**
 * Defines a user-defined data type. Must be a singular noun from the problem domain.
 * 
 * This class *by default* extends Object.
 * @author Radhouane
 * @version 1/29/2016
 */
//This one extends the Object class
public class Contact
{
    //Features a.k.a. attributes of a contact
    //Data members
    //instance variables
    private String name; 
    //This one is protected. Only the subclass
    //has direct access to it
    protected int age; 
    private String address; 
    private double income;
    private boolean isMarried;
    private final String city = "Columbus";
    //Default Constructor
    //Its only job is to initialize the instance variables
    public Contact(){
        name = "Joe Darth";
        //age = 10;
        setAge(22);
        address = "Planet Force";
        income = 145265.00;
        isMarried = false;
    }
    //Custom Constructor
    //Its only job is to initialize the instance variables
    public Contact(String newName, int newAge, String newAddress,
                  double newIncome, boolean newIsMarried){
        name = newName;
        setAge(newAge);
        //age = newAge;
        address = newAddress;
        income = newIncome;
        isMarried = newIsMarried;
    }
    //Mechanism for showing the name
    //accessor/getter
    public String getName(){
        return name;
    }
    //Mechanism for changing the name
    //Setter/Mutator
    public void setName(String newName){
        name = newName;
    }
    public void setAddress(String newAddress){
        address=newAddress;
    }
     public void setIncome(double newIncome){
        income=newIncome;
    }
    public void setIsMarried(boolean newIsMarried){
        isMarried=newIsMarried;
    }
    public void setAge(int newAge){
        //Exception throwing
        //if(newAge < 5){
        //    assert false;
        //}
        //ALternatively 
        assert newAge > 5;
        //Input validation
        if(newAge >= 0){
            
            age = newAge;
        }
        else{
            System.out.println("Age is NOT acceptable");
            
        }
        
    }
    public int getAge(){
        return age;
    }
    public String getAddress(){
        return address;
    }
    public double getIncome(){
        return income;
    }
    public boolean getIsMarried(){
        return isMarried;
    }
    //Returns a textual description of a contact object
    public String toString(){
        return  name + "\n"+age + "\n"+address + "\n"+income + "\n"+isMarried;
    }
    
}

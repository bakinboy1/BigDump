   
/**
 * Defines a data type. Must be a singular noun from the problem domain.
 * 
 * @author Julie Tran
 * @version 5/2/2016
 */
//The class does not look like it extends another
//In fact, it extends class Object
public class Person
{
    //Variable declarations
    //These are called features a.k.a attributes
    //Data members
    //Instance variables
    private String name;
    private double income;
    private String birthday;
    //Make varable protected to give
    //subclass full accewss to it
    protected boolean isMarried;
    

    
    //Default Constructor
    //Its only job is to initialize the instance variables
    public Person(){
       setName( "Bob Luke");
       setIncome(10000000);
       setBirthday("April 30, 1983");
       setIsMarried(true);
    }
    

    /**
     * Javadoc for this method
     * Description -- Custom Constructor; Its only job is to initialize the instance variables
     * 
     * @param newName The name that we want for this person object
     * @param newIncome The income that we want for this person object
     * @param newBirthday The birthday that we want for this person object
     * @param newIsMarried The marital status that we want for this person object
     */
    public Person(String newName, double newIncome, 
       String newBirthday, boolean newIsMarried){
       setName(newName);
       //income = newIncome;
       setIncome(newIncome);
       setBirthday(newBirthday);
       setIsMarried(newIsMarried);
    }
    //Getter/Accessor
    
    public void setName(String newName){
        //Crash on very bad input
            //assert newName.equals("The Emporor");
       
        
        //Input validation
        //Ignore not so bad input
        if(newName.equals("Darth Vader")){
            System.out.println("Sorry can't take Darth");
        }
        else{
            name = newName;
        }
    }
   
    /**
     * Javadoc for this method
     * Description -- Sets the birthday of this Person object
     * 
     * @param newBirthday The birthday that we want for this person object
     */
    public void setBirthday(String newBirthday){        
            birthday = newBirthday;
    }
    
    /**
     * Javadoc for this method
     * Description -- Returns the income of this Person object
     * 
     * @return Returns the income of this Person object
     */
    public double getIncome(){
        return income;
    }
    
    public String getName(){
        return name;
    }
    
     //Setter/Mutate
    public void setIncome(double newIncome){     
            income = newIncome;
    }
    public String getBirthday(){
        return birthday;
    }
    
    
    public boolean getIsMarried(){
        return isMarried;
    }
    public void setIsMarried(boolean newIsMarried){        
            isMarried = newIsMarried;
    }
    public String toString(){
        return name + "\n"+ income + 
              "\n"+birthday + "\n" +isMarried;
    }
}


/**
 * Write a description of class Animal here.
 * 
 * @author (Fabian Hucke) 
 * @version (3/15/2016)
 */
public class Animal
/**
 * @onSite instatiates the variable for the animal superclass 
 * @mammal instatiates the variable for the animal superclass 
 * @transfer instatiates the variable for the animal superclass 
 * @diet instatiates the variable for the animal superclass 
 * @name instatiates the variable for the animal superclass 
 * @weight instatiates the variable for the animal superclass 
 * @location instatiates the variable for the animal superclass 
 */
{
    private boolean onSite;
    private boolean mammal;
    private boolean transfer;
    private String diet;
    private String name;
    private double weight;
    private int age;
    private final String location ="Atlanta";
/**
 * @Animal() sets default values for the animal class
 */
    public Animal(){
        setOnSite(true);
        setMammal(false);
        setTransfer(false);
        setDiet("chum");
        setName("dork");
        setWeight(100.00);
        setAge(1);

    }
/**
 * @ public animal assigns the set method for each variable to be for a new variable of that type
 */
    public Animal( boolean newOnSite, boolean newMammal, boolean newTransfer,
    String newDiet, String newName, double newWeight, int newAge){
        setOnSite(newOnSite);
        setMammal(newMammal);
        setTransfer(newTransfer);
        setDiet(newDiet);
        setName(newName);
        setWeight(newWeight);
        setAge(newAge);
    }
/**
 * @ getOnSite() gets the onSite variable
 */
    public boolean getOnsite(){
        return onSite;
    }
/**
 * @setOnSite sets the onSite variable to be newOnSite
 */
    public void setOnSite(boolean newOnSite){
        onSite=newOnSite;
    }
/**
 * @ getMammal() gets the mammal variable
 */
    public boolean getMammal(){
        return mammal;
    }
/**
 * @setMammal sets the mammal variable to be newMammal
 */
    public void setMammal(boolean newMammal){
        mammal=newMammal;
    }
/**
 * @ getTransfer() gets the transfer variable
 */
    public boolean getTransfer(){
        return transfer;
    }
/**
 * @setTransfer sets the transfer variable to be newTransfer
 */
    public void setTransfer(boolean newTransfer){
        transfer=newTransfer;
    }
/**
 * @getDiet() gets the diet variable
 */
    public String getDiet(){
        return diet;
    }
/**
 * @setDiet sets the diet variable to be newDiet
 */
    public void setDiet(String newDiet){
        diet=newDiet;
    }
/**
 * @getName() gets the name variable
 */
    public String getName(){
        return name;
    }
/**
 * @setName sets the name variable to be newName
 */
    public void setName(String newName){
        name=newName;
    }
/**
 * @ getWeight() gets the weight variable
 */
    public double getWeight(){
        return weight;
    }
/**
 * @setWeight sets the weight variable to be newWeight
 */
    public void setWeight(double newWeight){
        weight=newWeight;
    }
/**
 * @ getAge() gets the age variable
 */
    public int getAge(){
        return age;
    }
/**
 * @setAge sets the age variable to be newAge
 */
    public void setAge(int newAge){
        age=newAge;
    }
/**
 * @toString() prints out the toString line describing all the Animal's stats
 */
    public String toString(){
        return name + "\n age: " + age + "\n weight: " + weight + "\n diet: " 
        + diet + "\n is on site?- " + onSite +
        "\n is a mammal?- " + mammal + "\n is scheduled to be transferred?- " + transfer;
    }

}

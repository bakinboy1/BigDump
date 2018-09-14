
/**
 * Write a description of class Female here.
 * 
 * @author (Fabian Hucke) 
 * @version (3/15/2016)
 */
public class Female extends Mammal
{
    /**
     * @milk instatiates the variable for the Female subclass
     */
    private int milk;
    /**
 * @Female() sets default values for the female class
 */
    public Female(){
        setMilk(50);
        setAir(150);
        setMammal(true);
        setOnSite(false);
        setTransfer(true);
        setDiet("chickens");
        setName("lady penguin");
        setWeight(15.00);
        setAge(22);
    }
/**
 * @ public Female assigns the set method for each variable to be for a new variable of that type
 */
    public Female (boolean newOnSite, boolean newFemale,
    boolean newTransfer, String newDiet, String newName, double newWeight, int newAge, int newAir, int newMilk){
        super(newOnSite, newFemale, newTransfer, newDiet, newName, newWeight, newAge, newAir);
        setMilk(newMilk);
    }
/**
 * @getMilk gets the milk variable
 */
    public int getMilk(){
        return milk;
    }
/**
 * @setMilk sets the milk variable to be newMilk
 */
    public void setMilk(int newMilk){
        milk=newMilk;
    }
/**
 * @toString() prints out the toString line describing all the Female's stats
 */
    public String toString(){
        return super.toString()+"\n required air is :" + getAir() + "\n milk produced: " + milk + "\n";
    }
}

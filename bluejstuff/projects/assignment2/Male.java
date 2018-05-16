
/**
 * Write a description of class Male here.
 * 
 * @author (Fabian Hucke) 
 * @version (3/15/2016)
 */
public class Male extends Mammal
{
    /**
 * @male instatiates the variable for the Male subclass
 */
    private boolean male;
    /**
 * @Male() sets default values for the male class
 */
    public Male(){
        setMale(true);
        setAir(150);
        setMammal(true);
        setOnSite(false);
        setTransfer(true);
        setDiet("TACOS");
        setName("dude penguin");
        setWeight(25.00);
        setAge(25);
    }
/**
 * @ public Male assigns the set method for each variable to be for a new variable of that type
 */
    public Male (boolean newOnSite, boolean newMammal,
    boolean newTransfer, String newDiet, String newName, double newWeight, int newAge, int newAir, boolean newMale){
        super(newOnSite, newMammal, newTransfer, newDiet, newName, newWeight, newAge, newAir);
        setMale(newMale);
    }
/**
 * @getMale gets the male variable
 */
    public boolean getMale(){
        return male;
    }
/**
 * @setMale sets the male variable to be newMale
 */
    public void setMale(boolean newMale){
        male=newMale;
    }
/**
 * @toString() prints out the toString line describing all the Male's stats
 */
    public String toString(){
        return super.toString()+"\n required air is :" + getAir() + "\n";
    }
}

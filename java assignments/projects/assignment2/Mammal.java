
/**
 * Write a description of class Mammal here.
 * 
 * @author (Fabian Hucke) 
 * @version (3/15/2016)
 */
public class Mammal extends Animal
{
    /**
     * @air instatiates the variable for the mammal subclass
     */
    private int air;
/**
 * @Mammal() sets default values for the mammal class
 */
    public Mammal(){
        setAir(100);
        setMammal(true);
        setOnSite(true);
        setTransfer(true);
        setDiet("sardines");
        setName("Otter");
        setWeight(12.00);
        setAge(8);
    }
/**
 * @ public Mammal assigns the set method for each variable to be for a new variable of that type
 */
    public Mammal (boolean newOnSite, boolean newMammal,
    boolean newTransfer, String newDiet, String newName, double newWeight, int newAge, int newAir){
        super(newOnSite, newMammal, newTransfer, newDiet, newName, newWeight, newAge);

        setAir(newAir);
    }
/**
 * @getAir() gets the air variable
 */
    public int getAir(){
        return air;
    }
/**
 * @setAir() sets the air variable to be newAir
 */
    public void setAir(int newAir){
        air=newAir;
    }
/**
 * @toString() prints out the toString line describing all the Mammal's stats
 */
    public String toString(){
        return super.toString();
    }

}

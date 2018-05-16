
/**
 * Write a description of class Fish here.
 * 
 * @author (Fabian Hucke) 
 * @version (3/15/2016)
 */
public class Fish extends Animal
{

    /**
     * @gills instatiates the variable for the Fish subclass
     */
    private boolean gills;
    /**
     * @public Fish() sets default values for each fish variable
     */
    public Fish(){
        setMammal(false);
        setOnSite(true);
        setTransfer(false);
        setDiet("sphagetti");
        setName("fish");
        setWeight(20.00);
        setAge(5);
        setGills(true);
    }

    /**
     * @ public Fish assigns the set method for each variable to be for a new variable of that type
     */
    public Fish (boolean newOnSite, boolean newMammal,
    boolean newTransfer, boolean newGills, String newDiet, String newName, double newWeight, int newAge){

        super(newOnSite, newMammal, newTransfer, newDiet, newName, newWeight, newAge);
        setGills(newGills);

    }

    /**
     * @setGills sets the variable gills to be newGills
     */
    public void setGills(boolean newGills){
        gills=newGills;
    }

    /**
     * @getGills() gets the gills variable
     */
    public boolean getGills(){
        return gills;
    }

    /**
     * @toString() prints out the toString line describing all the Fish's stats
     */
    public String toString(){
        return super.toString()+"\n It's a fish, so it doesn't need air \n" ;
    }
}


/**
 * Defines chocolate bar data type. Captures a concept (noun)from a problem domain.
 * 
 * @author (Fabian Hucke) 
 * @version (8/31/15)
 */

//the arrow between chocolateBAr and chocolatebarTester shows that the files depends on it
public class ChocolateBar implements Edible
{
    //The Double class wraps a value of the primitive type double in an object. 
    //An object of type Double contains a single field whose type is double.
    double unitCost;
    //boolean = t/f 
    boolean dark;
    //attributes, fields, data members, instance variable, features --- all mean same thing, data members is what is usually used
    //when things start with uppercase (String) it is a class
    String brand;
    //default constructor
    private ChocolateBar partner;
    public ChocolateBar(){
        setUnitCost(1);
        setDark(true);
        setBrand("KitKat");
        setPartner(new ChocolateBar(2,true, "Twix"));
        //partner= new ChocolateBar(2,true, "Twix");
        partner.setPartner(this);
        
    }
    /**
     * 
     * @postcondition: a chocolate bar object will be created
     */
    public ChocolateBar(double newUnitCost, boolean newDark, String newBrand, ChocolateBar newPartner){
        setUnitCost(newUnitCost);
        setDark(newDark);
        setBrand(newBrand);
        setPartner(newPartner);
    }
    public ChocolateBar(double newUnitCost, boolean newDark, String newBrand){
       // unitCost=newUnitCost;
       //dont assign instance variables outside of set method
        setUnitCost(newUnitCost);
        setDark(newDark);
        setBrand(newBrand);
        setPartner(newPartner);
    }
    /**
     *Description: Returns the unit cost of this chocolate bar object.
     * @return Returns the unit cost of this chocolate bar object.
     */
    public double getUnitCost(){
        return unitCost;
    }
    
    /**
     *Description: Returns the brand of this chocolate bar object.
     * @return Returns the brand of this chocolate bar object.
     */
    public String getBrand(){
        return brand;
    }
    /**
     *Description: Returns the darkness of this chocolate bar object.
     * @return Returns the darkness of this chocolate bar object.
     */
    public boolean getDark(){
        return dark;
    }
    /**
     *Description: Sets the unit cost
     *programming by contract
     *@precondition newUnitCost >= 0
     *@param newUnitCost The unit cost that we want for the chocolateBar
     */
    public void setUnitCost(double newUnitCost){
        //input validation
        assert newUnitCost >=0;
        unitCost=newUnitCost;
    }
    /**
     *Description: Sets dark level
     */
    public void setDark(boolean dark){
        this.dark = dark;
    }
    public void setBrand(String newBrand){
        brand=newBrand;
    }
    //returns text description of chocolatebar
    public String getInfo(){
        return "brand: " +brand + " color: " + dark + " price: " + unitCost+ " Partner: " + partner;
    }
}

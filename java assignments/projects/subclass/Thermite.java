
/**
 * Write a description of class thermite here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Thermite extends operator
{
    private int thermiteSpecial;

    public Thermite(){
        setThermiteSpecial("thermite");
    }

    public Thermite(String newName, String newWeapon, int newDamage, boolean newDefender,String newEquipment){
        super (newName, newWeapon, newDamage, newDefender, newEquipment);
        setThermiteSpecial(newThermiteSpecial);
    }

     public String getThermiteSpecial(){
     return thermiteSpecial;
    }
    public void setThermiteSpecial(String newThermiteSpecial){
        thermiteSpecial=newThermiteSpecial;
    }
   

    public String toString(){
        return super.toString()+"Thermite's special gear is " + thermiteSpecial;
    }
}

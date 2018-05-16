
/**
 * Write a description of class montagne here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Montagne extends operator
{
  private int montagneSpecial;

    public Montagne(){
        setMontagneSpecial("Riot Shield");
    }

    public Montagne(String newName, String newWeapon, int newDamage, boolean newDefender,String newEquipment){
        super (newName, newWeapon, newDamage, newDefender, newEquipment);
        setMontagneSpecial(newMontagneSpecial);
    }
    
    public void setMontagneSpecial(String newMontagneSpecial){
        montagneSpecial=newMontagneSpecial;
    }
    public String getMontagneSpecial(){
     return montagneSpecial;
    }
    
    

    public String toString(){
        return super.toString()+"Montagne's special gear is " + montagneSpecial;
    }
}

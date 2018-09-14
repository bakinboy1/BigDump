
/**
 * Write a description of class fuze here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Fuze extends operator
{
  private int fuzeSpecial;

    public Fuze(){
        setFuzeSpecial("cluster charge");
    }

    public Fuze(String newName, String newWeapon, int newDamage, boolean newDefender,String newEquipment){
        super (newName, newWeapon, newDamage, newDefender, newEquipment);
        setFuzeSpecial(newFuzeSpecial);
    }

    public void setFuzeSpecial(String newFuzeSpecial){
        fuzeSpecial=newFuzeSpecial;
    }
    public String getFuzeSpecial(){
     return fuzeSpecial;
    }

    public String toString(){
        return super.toString()+"Fuze's special gear is " + fuzeSpecial;
    }
    
}

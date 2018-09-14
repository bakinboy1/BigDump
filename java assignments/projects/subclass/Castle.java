
/**
 * Write a description of class glaz here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Castle extends operator
{
   private int castleSpecial;

    public Castle(){
        setCastleSpecial("Reinforced Paneling");
    }

    public Castle(String newName, String newWeapon, int newDamage, boolean newDefender,String newEquipment){
        super (newName, newWeapon, newDamage, newDefender, newEquipment);
        setCastleSpecial(newCastleSpecial);
    }

    public void setCastleSpecial(String newCastleSpecial){
        castleSpecial=newCastleSpecial;
    }
    public String getCastleSpecial(){
     return castleSpecial;
    }

    public String toString(){
        return super.toString()+"Castle's special gear is " + castleSpecial;
    }
}

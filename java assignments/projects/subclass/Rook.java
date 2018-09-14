
/**
 * Write a description of class rook here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Rook extends operator
{
   private int rookSpecial;

    public Rook(){
        setRookSpecial("armor plating");
    }

    public Rook(String newName, String newWeapon, int newDamage, boolean newDefender,String newEquipment){
        super (newName, newWeapon, newDamage, newDefender, newEquipment);
        setRookSpecial(newRookSpecial);
    }

    public void setRookSpecial(String newRookSpecial){
        rookSpecial=newRookSpecial;
    }
    public String getRookSpecial(){
     return rookSpecial;
    }

    public String toString(){
        return super.toString()+ "Rook's special gear is " + rookSpecial;
    }
}


/**
 * Write a description of class operator here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class operator
{
   private String name;
   private String weapon;
   private int damage;
   private boolean defender;
   private String equipment;
   
   public operator(){
    name="unselected";
    weapon="none";
    damage=0;
    defender= true;
    equipment="a box";
    }
    
    
    public String getName() {
        return name;
        
    }
    public void setName(String newName){
        name=newName;
    
    }
    
    
    public String getWeapon(){
        return weapon;
        
    }
    public void setWeapon(String newWeapon){
        weapon=newWeapon;
        
    }
    
    
    public String getEquipment(){
        return equipment;
        
    }
    public void setEquipment(String newEquipment){
        equipment=newEquipment;
        
    }
    
    
    public int getDamage(){
        return damage;
        
    }
    public void setDamage(int newDamage){
        damage=newDamage;
        
    }
    
    
    public boolean getDefender(){
        return defender;
        
    }
    public void setDefender(boolean newDefender){
        defender=newDefender;
        
    }
    public String toString(){
    return "operator "+ name + " is equipped with a " + weapon + " as their primary weapon, and " 
    + equipment + " as their equipment. \n Their " + weapon + " deals " + damage + 
    "and they are a " + defender;
    }
}

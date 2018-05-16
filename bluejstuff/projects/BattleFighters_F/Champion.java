
/**
 * Three Champions fight against each other.
 * 
 * @author (Fabian Hucke, Javen Jester, Kelsey Smith
 * @version (Battle-F
 * 2/12/15
 */
public class Champion{
  private int healthBar;
  private int attackPoints;
private String name;
  


                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                        /**
* Creates the champion health points
* @Requires:
*    healthBar is an integer greater than or equal to 1 but less than or equal to 100
*    attackPoints is and integer greater than or equal to 1 but less than or equal to 100
*/

public Champion(int healthBar, int attackPoints, String name){
  assert healthBar >= 1; 
  assert healthBar <= 100;
  assert attackPoints >= 1;
  assert attackPoints <= 100;

  this.healthBar = healthBar;
  this.attackPoints = attackPoints;
  this.name=name;
}

/**
 * @action:
 * loop subtracts current champion health by other champion's attack value
 * when a champion's health reaches 0 the loop ends
 */
public static void battle(Champion warrior, Champion wizard, Champion warlock){
    System.out.println(warrior.name + ", " + wizard.name + ", and " + warlock.name + " start their battle royale");
  while(warrior.healthBar != 0 || wizard.healthBar != 0 || warlock.healthBar != 0)
   {   
           wizard.healthBar = wizard.healthBar - warlock.attackPoints;
           System.out.println(warlock.name +" does "+ warlock.attackPoints +" damage to "+ wizard.name +" and "+ 
           wizard.name + " has "+ wizard.healthBar +" left.\n");
           if(wizard.healthBar <= 0){
               wizard.healthBar = 0;
               break;
            }

           warrior.healthBar = warrior.healthBar - wizard.attackPoints;
           System.out.println(wizard.name +" does "+ wizard.attackPoints +" damage to "+ 
           warrior.name +" and "+ warrior.name +" has "+ warrior.healthBar +" left.\n");
           if(warrior.healthBar <= 0){
               warrior.healthBar = 0;
               break;
            }
    
           warlock.healthBar = warlock.healthBar - warrior.attackPoints;
           System.out.println(warrior.name +" does "+ warrior.attackPoints +" damage to "+ 
           warlock.name +" and "+ warlock.name +" has "+ warlock.healthBar +" left.\n");
           if(warlock.healthBar <= 0){
               warlock.healthBar = 0;
               break;
            }
        }
  
  if(warrior.healthBar <= 0){
           System.out.println(warrior.name +" has lost the fight");
        }
     else if (warlock.healthBar <= 0){
            System.out.println(warlock.name + " has lost the fight");
        }
     else if (wizard.healthBar <= 0){
            System.out.println(wizard.name +" has lost the fight");
        }
 
}
}
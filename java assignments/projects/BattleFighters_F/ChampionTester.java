
/**
 * Three Champions fight each other in a battle royale.
 * 
 * @author (Fabian Hucke, Javan Jester, Kelsey Smith) 
 * @version (Battle-F
 * 2/12/15
 */
public class ChampionTester{
  private Champion warrior;
  private Champion wizard;
  private Champion warlock;
  /**
   * declare each champion's health, attack value, and name
   */
public ChampionTester(){
   warrior = new Champion(100,25,"warrior");
   wizard = new Champion(100,30,"wizard");
   warlock = new Champion (100,27,"warlock");
   
 }
 /**
   * declare each champion's health, attack value, and name
   */
public static void main(String[] args){
    Champion warrior = new Champion(100,25,"warrior");
    Champion wizard = new Champion(100,30,"wizard");
    Champion warlock = new Champion (100,27,"warlock");

    Champion.battle(warrior, wizard, warlock);
}
}

/**
 * Two Champion fight against each other.
 * 
 * @author (Adam Mott, Kelsey Smith) 
 * @version (02/08/2015)
 */
public class ChampionTester{
  private Champion warrior;
  private Champion wizard;
  private Champion warlock;
  
public ChampionTester(){
   warrior = new Champion(100,25,"warrior");
   wizard = new Champion(100,30,"wizard");
   warlock = new Champion (100,27,"warlock");
   
 }

public static void main(String[] args){
    Champion warrior = new Champion(100,25,"warrior");
    Champion wizard = new Champion(100,30,"wizard");
    Champion warlock = new Champion (100,27,"warlock");

    Champion.battle(warrior, wizard, warlock);
}
}
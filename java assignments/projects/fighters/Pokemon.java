
/**
 * Write a description of class battleArena here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Pokemon{
  private int health;
  private int strength;
  private int speed;

/**
* Constructs the pokemon
* @Require:
*    health is an integer greater than or equal to 1 but less than or equal to 300
*    strength is and integer greater than or equal to 1 but less than or equal to 300
*    speed is an integer greater than or equal to 1 but less than or equal to 300
*/
public Pokemon(int health, int strength, int speed){
  assert health >= 1;
  assert health <= 300;
  assert strength >= 1;
  assert strength <= 300;
  assert speed >= 1;
  assert speed <= 300;

  this.health = health;
  this.strength = strength;
  this.speed = speed;
}

public static void battle(Pokemon pokemon1, Pokemon pokemon2){
  do{
    System.out.println(pokemon1+" begins the fight against "+pokemon2);
    pokemon2.health = pokemon2.health - pokemon1.strength;

    System.out.println(pokemon1 +" does "+ pokemon1.strength +" damage to "+
    pokemon2 +" and "+ pokemon2 +" has "+ pokemon2.health +" left.");

    pokemon1.health = pokemon1.health - pokemon2.strength;

    System.out.println(pokemon2 +" does "+ pokemon2.strength +" damage to "+ 
    pokemon1 +" and "+ pokemon1 +" has "+ pokemon1.health +" left.");

  }while(pokemon1.health >= 1 || pokemon2.health >= 1);
  if(pokemon1.health < 1)
    System.out.println(pokemon1 +" has lost the fight");
  else
    System.out.println(pokemon2 +" has lost the fight");
  }
}
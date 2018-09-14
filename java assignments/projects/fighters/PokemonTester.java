public class PokemonTester{
  private Pokemon charizard;
  private Pokemon blastoise;
  private Pokemon venusaur;

public PokemonTester(){
   charizard = new Pokemon(100,50,50);
   blastoise = new Pokemon(150,25,150);
   venusaur = new Pokemon(300,10,100);
 }

public static void main(String[] args){
    Pokemon charizard = new Pokemon(100,50,50);
    Pokemon blastoise = new Pokemon(150,25,150);
    Pokemon.battle(charizard, blastoise);
}
}
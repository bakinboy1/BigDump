/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author fabian
 */
public class Main {
    public static void main(String[] args){
        Deck d= new Deck();
        System.out.println(d.printDeck());
        d.shuffleDeck();
        System.out.println(d.printDeck());
        Player p = new Player("joe");
        Dealer dude = new Dealer();
        card[] hand1= new card[5];
        for(int i=0;i<hand1.length;i++){
            System.out.println(hand1[i].toString());
        }
        for (int i=0;i<hand1.length;i++){
            d.addCard(hand1[i]);
        }

    }
}

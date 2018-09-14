/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.util.*;
/**
 *
 * @author fabian
 */
public class Deck{
    //private String [][] deck= new String[52][2];   
    private ArrayList<card> deck;
    private String[] suites={"Diamonds","Hearts","Spades","Clubs"};
    private String[] ranks={"Ace","2","3","4","5","6","7","8","9","10","Jack","Queen","King"};

    public Deck(){
        //int index=0;
        deck = new ArrayList<card>();
        for (int i=0; i<suites.length; i++){
            for (int j=0; j<ranks.length; j++){
                //  deck[index][0]=suites[i];
                //  deck[index][1]=ranks[j];
                //  index++;
                deck.add(new card(suites[i], ranks[j]));
            }
        }
    }

    public String printDeck(){
        String output="";
        for (int i=0;i<deck.size();i++){
            // output+= deck[i][1]+" of "+ deck[i][0]+"\n";
            //output+=deck.get(i).getRank()+" of "+deck.get(i).getSuite()+"\n";
            output += deck.get(i).toString()+"\n";
        }
        return output;
    }

    public void shuffleDeck(){
        for (int i=0; i < deck.size(); i++){
            int val= (int)(52 * Math.random());
            //String[] temp=deck[val];
            //deck[val]=deck[i];
            //deck[i]=temp;
            card temp= deck.get(val);
            deck.set(val, deck.get(i));
            deck.set(i,temp);
        }
    }

    public card dealCard(){
        
        return deck.remove(0);
    }

    public void addCard(card c){
        deck.add(c);
    }
}

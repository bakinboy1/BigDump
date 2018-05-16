

import java.util.ArrayList;

public class Deck {
	
	
	private ArrayList<Card> deck;
	
	
	//initializes deck
	public Deck() {
		
		
		deck = new ArrayList<Card>();
	}	
	//creates a full deck unshuffled
	public void fullDeck() {
		for(Suit suit : Suit.values()) {
			for(Rank rank : Rank.values()) {
			
				deck.add(new Card(suit, rank));
			}
		}
	}

	//prints the deck 
	public String printDeck() {
		String output = "";
		
		for(int i=0; i<deck.size();i++) {
		output += deck.get(i).toString() + "\n";
		}
		
		return output;
	}
	//shuffles the deck 
	public void shuffleDeck() {
		for(int i = 0; i < deck.size(); i++) {
			
			int val = (int) (52 * Math.random());
			Card temp = deck.get(val);
			deck.set(val, deck.get(i));
			deck.set(i, temp);
			
			
		}
	}
	//deals card from the deck 
	public Card dealCard() {
		return deck.remove(0);
	}
	//adds a hand back to the deck (not used)
	public void addHand(ArrayList<Card> h) {
		for(Card c : h ) {
			this.addCard(c);
		}
	}
	
	//adds cards to the deck 
	public void addCard(Card c) {
		deck.add(c);
	}
	
        
}

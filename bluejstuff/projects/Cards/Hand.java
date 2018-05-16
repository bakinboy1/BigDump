 

public class Hand {
	
	private card[] hand;
	
	public Hand(int size) {
		hand = new card[size];
		
		for(int i = 0; i < hand.length; i++) {
			hand[i] = new card();
		}
	}

	
	//accessors
	public card[] getHand() {
		return hand;
	}

	//mutators
	public boolean setHand(card[] c) {
		if(c.length == hand.length){
			hand = c;
			return true;
		}
		
		return false;
	}
	
	public boolean addCard(card c) {
		for(int i = 0; i < hand.length; i++) {
			if(hand[i].getRank().equals("") && hand[i].getSuite().equals("")) {
				hand[i] = c;
				return true;
			}
		}
		
		return false;
	}
	
	
	public card removeCard(String suite, String rank) {
		for(int i = 0; i < hand.length; i++) {
			if(hand[i].getRank().equals(rank) && hand[i].getSuite().equals(suite)) {
				card c = hand[i];
				hand[i] = new card();
				return c;
			}
		}
		
		return new card();
	}
	
	
	//
	public boolean hasCard(card c) {
		for(int i = 0; i < hand.length; i++) {
			if(hand[i] == c) {
				return true;
			}
		}
		
		return false;
	}
	
	public boolean hasCard(String suite, String rank) {
		for(int i = 0; i < hand.length; i++) {
			if(hand[i].getRank().equals(rank) && hand[i].getSuite().equals(suite)) {
				return true;
			}
		}
		
		return false;
	}


}

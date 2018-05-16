 

public class card {
	private String suite;
	private String rank;
	
	public card() {
		suite = "";
		rank = "";
	}
	
	public card(String suite, String rank) {
		this.suite = suite;
		this.rank = rank;
	}
	
	public String getSuite() {
		return suite;
	}
	
	public String getRank() {
		return rank;
	}
	
	public String toString() {
		return rank + " of " + suite; 
	}
}

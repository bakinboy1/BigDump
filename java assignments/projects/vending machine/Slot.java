import java.util.ArrayList;

public class Slot {
	private int maxNumItems = 0;
	private ArrayList<Product> inventory;
	private int cost = 0;
	private String id = "";
	
	public Slot(int maxNumItems, String id) {
		this.maxNumItems = maxNumItems;
		this.id = id;
		inventory = new ArrayList<Product>();
	}
	
	public String getId() {
		return id;
	}
	
	public float getCost() {
		return cost;
	}
	
	public void setCost(int cost) {
		this.cost = cost;
	}
	
	public Product removeProduct() {
		return inventory.remove(0);
	}
	
	public int getQuantity() {
		return inventory.size();
	}
	
	public boolean addProduct(Product p) {
		if(inventory.size() < maxNumItems) {
			inventory.add(p);
			return true;
		} else {
			return false;
		}
	}
}

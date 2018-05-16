import java.util.ArrayList;

public class Machine {
    private ArrayList<Slot> machine;
    Coinholder slots= new Coinholder();
    public Machine(int numOfSlots) {
        machine = new ArrayList<Slot>();
        for(int i = 0; i < numOfSlots; i++) {
            machine.add(new Slot(10, Integer.toString(i)));
        }

    }

    public boolean restockProduct(Product p, String slotID) {
        for(int i = 0; i < machine.size(); i++) {
            if (machine.get(i).getId().equals(slotID)){
                return(machine.get(i).addProduct(p));
            }
        }

        return false;
    }

    public boolean restockProduct(Product p, String slotID, int cost) {
        for(int i = 0; i < machine.size(); i++) {
            if (machine.get(i).getId().equals(slotID)){
                machine.get(i).setCost(cost);
                return(machine.get(i).addProduct(p));
            }
        }

        return false;
    }

    public boolean restockProduct(ArrayList<Product> p, String slotID) {

        Slot s = null;

        for(int i = 0; i < machine.size(); i++) {
            if(machine.get(i).getId().equals(slotID)) {
                s = machine.get(i);
            }
        }

        if(s == null) {
            return false;
        }

        boolean added = s.addProduct(p.remove(0));

        while(added && !p.isEmpty()) {
            added = s.addProduct(p.remove(0));
        }

        return true;
    }

    //dont know what to do here
    public Product purchaseProduct(String productID, ArrayList<Coins> c) {
        int cost= machine.getID(productID).getCost();
        int money= c.getValue();
        ProductID.removeProduct();
    }
    
}

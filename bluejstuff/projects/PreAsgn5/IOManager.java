import java.io.*;
import java.util.*;

public class IOManager
{
    public ArrayList<CocaCola> readCocaColaInformation(String fileName) 
    throws FileNotFoundException{
        ArrayList<CocaCola> inventory = new ArrayList<CocaCola>();               
        try{
            File dataFile = new File(fileName);
            Scanner dataScanner = new Scanner(dataFile);

            while(dataScanner.hasNext())
            {
                String kindOfCoke = dataScanner.nextLine();
                int amount = Integer.parseInt(dataScanner.nextLine());
                double unitPrice = Double.parseDouble(dataScanner.nextLine());
                CocaCola c = new CocaCola(kindOfCoke, amount,unitPrice);
                inventory.add(c);
            }
        }catch(IOException e){
            System.out.println("File of Coca Colas not found !!!");
        }
        return inventory;
    }     

    public boolean saveCocaColaInformation (String fileName, ArrayList<CocaCola> inventory)
    throws FileNotFoundException
    {
        //Getting Ready to write back out to the CocaCola file
        System.out.println("Saving the current CocaCola Inventory");
        PrintWriter out = new PrintWriter(fileName);

        for(int i = 0; i < inventory.size(); i++){

            out.println(inventory.get(i).getKindOfCoke());
            out.println(inventory.get(i).getAmount());
            out.println(inventory.get(i).getUnitPrice());
            System.out.println(" Saved " + inventory.get(i).getKindOfCoke());
        }
        out.close();
        return true;
    }

}


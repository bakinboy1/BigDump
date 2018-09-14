import java.util.ArrayList;
import java.io.*;
public class Driver
{
    public static void main(String[] args)
    throws FileNotFoundException{
        IOManager io = new IOManager();
        ArrayList<CocaCola> cokes = io.readCocaColaInformation("CocaColaInventory.txt");
        for(int i = 0; i< cokes.size();i++){
            System.out.println(cokes.get(i));
        }
    }

}

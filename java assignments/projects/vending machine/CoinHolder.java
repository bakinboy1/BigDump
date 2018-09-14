
/**
 * Write a description of class CoinHolder here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;
public class CoinHolder
{

    private Stack penny= new Stack();
    private Stack nickel= new Stack();
    private Stack dime= new Stack();
    private Stack quarter= new Stack();
    
    public void CoinHolder(Stack penny, Stack nickel, Stack dime, Stack quarter)
    {
        penny=null;
        nickel=null;
        dime=null;
        quarter=null;
    }

    public void showCoins(){
		
        System.out.println("pennies: "+penny.size());

        System.out.println("nickels: "+nickel.size());

        System.out.println("dimes: "+dime.size());

        System.out.println("quarters: "+quarter.size());
    }

    public void addPenny(Coins p){
       
            penny.push(p);
        
    }

    public void addNickel(Coins n){
        
            nickel.push(n);
        
    }

    public void addDime(Coins d){
        
            dime.push(d);
        
    }

    public void addQuarter(Coins q){
        
            quarter.push(q);
        
    }

}


/**
 * Write a description of class main here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;
public class main
{

    public static void main(String[] args)
    {
        // initialise instance variables
        int max = 100;
        Coins p=new Coins(1,"penny");
        Coins n=new Coins(5,"nickel");
        Coins d=new Coins(10,"dime");
        Coins q=new Coins(25,"quarter");
        CoinHolder h= new CoinHolder();
        for (int i=0; i<max; i++){
            h.addPenny(p);
            h.addNickel(n);
            h.addDime(d);
            h.addQuarter(q);
        }
    }

}

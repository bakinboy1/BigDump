

import java.util.*;

public class RecursionExercise
{
    
    public static void main (String[] args){
        System.out.println("total cost: $ "+totalCost(27));
        System.out.println("boxes used: "+boxCount(27));
    }

    public static int totalCost(int unit){
        int price=0;     
        if (unit>=100){         
            unit = unit-100;
            price=20;           
        }
        else if (unit>=20){           
            unit = unit-20;
            price=10;          
        }
        else if (unit>=10){         
            unit = unit-10;
            price=7;           
        }
        else if (unit>=5){         
            unit = unit-5;
            price=5;          
        }
        else if (unit>0){           
            unit = unit-1;
            price=3;        
        }
        else if ( unit<=0){
            return 0;
        }       
        return price + totalCost(unit);
    }
    
    public static int boxCount(int tally){
        int counter=0;
        
        if (tally>=100){
            tally=tally-100;
            counter++;
        }
        else if (tally>=20){
            tally=tally-20;
            counter++;
        }
        else if (tally>=10){
            tally=tally-10;
            counter++;
        }
        else if (tally>=5){
            tally=tally-5;
            counter++;
        }
        else if (tally>0){
            tally=tally-1;
            counter++;
        }
        else if ( tally<=0){     
            return 0;
        }       
        return counter + boxCount(tally);

    }
    
    
    
    
}


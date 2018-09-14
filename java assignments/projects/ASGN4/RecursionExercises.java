
/**
 * Write a description of class RecursionExercises here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;
public class RecursionExercises
{
    public static int multiply(int a, int b){
        if(b<0){
            return a+multiply(a,b+1);
        }
        else if(a==0 || b==0){
            return 0;
        }
        else{
            return a+multiply(a,b-1);
        }

    }

    public static int findMin(int array[]){
        if (array.length==1){
            return array[0];
        }
        int min= findMin(Arrays.copyOfRange(array, 1, array.length));
        return array[0]<min ? array[0]:min;
    }

    public static int reverse(int number){
        int k=1;    
        int j=number;
        if (number==0){
            return 0;
        }

        else{
            while(j>=10){
                j=j/10;
                k=k*10;
            }
            return (j+reverse(number-j*k)*10);
        }
    }

    public static int countPaths(int n, int m){
        int Grid[][] = new int[n][m];
        for(int temp=0; temp < n; temp++){
            Grid[temp][0] = 1;
        }

        for(int temp=0; temp < m; temp++){
            Grid[0][temp] = 1;
        }

        
        for(int temp=1; temp < n; temp++){

            
            for(int temp2=1; temp2 < m; temp2++){
                Grid[temp][temp2] = Grid[temp-1][temp2] + Grid[temp][temp2-1];
            }
        }
        return Grid[n-1][m-1];
    }

    public String ordString(int number){
        String reverser="";
        if (0<number){
            for (int i =0;i<number;i++){
                if (0<i){
                    reverser+=", ";

                }
                reverser+=ordString(i);
            }
        }
        return " {"+reverser+"} ";
    }
}

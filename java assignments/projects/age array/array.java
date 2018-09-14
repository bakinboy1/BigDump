
/**
 * Write a description of class array here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.*;
public class array

{
    public static int mode(int m[]){
        int maxValue, maxCount;

        for(int i=0; i<m.length; ++i){
            int count=0;
            for (int j=0; j<m.length; ++j){
                if (m[j]==m[i]){ 
                    ++count;
                }
            }
            if(count>maxCount){
                maxCount=count;
                maxValue=m[i];
            }
        }
        return maxValue;
    }

    public static void main (String[] args){
        int[] list= new int[100];
        int people=(int)(Math.random()*100+1);
        int counter=0;
        int userChoice=10;
        int i=0;
        Scanner input = new Scanner(System.in);
        userChoice=input.nextInt();

        for (i=0; i<100; i++){
            list[i]=people;
            counter++;
        }
        while (userChoice!=0){
            if (userChoice==1){

                System.out.println("the mean age of the people is " + mean(list));
            }
            if (userChoice==2){
                System.out.println("the mode of the people is " + mode(list));
            }
            if (userChoice==3){
                System.out.println("the median of the people is " + median(list));
            }
            if (userChoice==4){
                System.out.println("the range of the people is " + low(list) +" to "+high(list));
            }
            if (userChoice==0){
                System.exit(0);
            }
        }
    } 

    public static String median(int[] median){
        Java.util.Arrays.sort(list);
        return System.out.println(list[49]);
    }
    public static int low(int[] low){
        Java.util.Arrays.sort(list);
        return System.out.println(list[0]);
    }
    public static int high(int[] high){
        Java.util.Arrays.sort(list);
        return System.out.println(list[99]);
    }

    public static double mean(int[] mean){
        double sum = 0;
        for (int i=0; i<mean.length; i++){
            sum+=mean[i];
        }
        double avg= sum / mean.length;
        return avg;
    }
}

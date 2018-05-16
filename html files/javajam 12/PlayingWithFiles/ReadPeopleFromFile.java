
import java.io.*;
import java.util.*;
/**
 * @author Julie Tran
 * @version 5/2/2016
 */
public class ReadPeopleFromFile
{
    public static void main(String[] args) throws FileNotFoundException
    {
        ArrayList<Person> myValues = new ArrayList<Person>();
        try{
            File inputFile = new File("PeopleDB.txt");
            Scanner scan = new Scanner(inputFile);

            while(scan.hasNext()){
                String name = scan.nextLine();
                double income = Double.parseDouble(scan.nextLine());
                String birthday = scan.nextLine();
                String marital = scan.nextLine();
                boolean isMarried;
                if(marital.equals("true"))isMarried = true;
                else {isMarried = false;}
                
                Person p = new Person(name, income, birthday, isMarried);
                myValues.add(p);
                //System.out.println(value);
            }
        }catch(IOException e){
            System.out.println("Sorry could not find myData.txt");
        }
        
       
        
        //Process the array list
        //Maybe sort the list or add to it
        System.out.println("Array list before sorting");
        for(int i = 0; i < myValues.size(); i++){
            System.out.println(myValues.get(i) + " ");
        }
        System.out.println();

        //Process the array list
        //Maybe sort the list or add to it
        //Bubble sort
        for(int bubble = 1; bubble <= myValues.size(); bubble++){
            for(int i = 0; i < myValues.size() - 1; i++){
                if(0 < myValues.get(i).getName().compareTo( 
                                              myValues.get(i+1).getName())
                                            ){
                    Person temp = myValues.get(i);
                    myValues.set(i, myValues.get(i+1));
                    myValues.set(i+1, temp);
                }
            }
        }
        System.out.println("Array list after sorting");
        for(int i = 0; i < myValues.size(); i++){
            System.out.println(myValues.get(i) + " ");
        }
        System.out.println();
        //Then save back to disk
        //         PrintWriter mySaver = new PrintWriter("PeopleDB.txt");
        //         for(int i = 0; i < myValues.size(); i++){
        //             mySaver.println(myValues.get(i).getName());
        //             mySaver.println(myValues.get(i).getIncome());
        //             mySaver.println(myValues.get(i).getBirthday());
        //             mySaver.println(myValues.get(i).getIsMarried());
        //         }
        //         mySaver.close();
        
        
        
        
    }
}


import java.util.*;
import java.io.*;
/**
 * Write a description of class FileWordCounter here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class FileWordCounter
{
    public static void main(String args[]){
        Scanner input = new Scanner(System.in);
        String userChoice="1";
        String filename = "properkjv.txt";

        while (!(userChoice.equals("exit"))){
            System.out.println("Enter one of the following 3 files to read the wordcount from or type 'exit' to exit");
            System.out.println("properkjv.txt   properkjv0.txt   properkjv1.txt");
            userChoice=input.nextLine();

            if(userChoice.equals("properkjv.txt")){
                filename="properkjv.txt";
            }
            else if(userChoice.equals("properkjv0.txt")){
                filename="properkjv0.txt";
            }
            else if(userChoice.equals("properkjv1.txt")){
                filename="properkjv1.txt";
            }
            else if (userChoice.equals("exit")){
                System.exit(0);
            }
            else{

                System.out.println("you must enter one of the three file names");
                userChoice= input.nextLine();
            }

            String records="";
            try{
                BufferedReader reader = new BufferedReader(new FileReader(filename));

                String line;
                while ((line = reader.readLine()) != null)
                {
                    records+=line;
                }
            }
            catch (Exception e)
            {
                System.err.format("Exception occurred trying to read '%s'.", filename);
                e.printStackTrace();

            }
            String text=records;
            String textLower=text.toLowerCase();
            String text2[]=textLower.split(" ");
            HashMap<String, Integer> wordCount= new HashMap<String, Integer>();

            for (String word : text2 ){
                Integer currentCount=wordCount.get(word);
                wordCount.put(word, (currentCount==null ? 1 : (currentCount +1)));
            }

            Set<Map.Entry<String, Integer>> sets= wordCount.entrySet();
            ArrayList<Word> list = new ArrayList<Word>();
            for(Map.Entry<String, Integer> entry : sets){
                if(entry.getValue() > 0){
                    list.add(new Word(entry.getKey(), entry.getValue()));

                }
            }
            Collections.sort(list, new CompareFreq());
            for( int i = 0; i < list.size(); i++){
                System.out.println(list.get(i));
            }
            Date date= new Date();
            try{
                PrintWriter writer = new PrintWriter(filename+date.getTime()+".txt", "UTF-8");
                for( int i = 0; i < list.size(); i++){
                    writer.println(list.get(i));
                }

                writer.close();
            } catch (IOException e) {
                System.err.format("Exception occurred trying to read '%s'.", filename);
                e.printStackTrace();
            }
        }
    }

}

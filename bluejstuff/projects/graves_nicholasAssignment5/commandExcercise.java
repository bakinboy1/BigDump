import java.util.*;
public class commandExcercise
{
    public static void main(String[] args)
    {
        List student = new LinkedList<Student>();
        //Random data generators
        for (int i = 0; i < 20; i++)
        {
            String[] firstNames = {"Linus", "Leon", "Zelma", "Chris", "Chunkers", "Crungy", "John", "Alice", "Frindle", "Spagus", "Gorbonzo", "Stephen", "Gorge", "Hillary", "Christine", "Mareesh", "Shobbins", "Michael", "Kosan", "Ivan"};
            Random rand0 = new Random();
            int firstName = rand0.nextInt(firstNames.length);
            
            String[] lastNames = {"Gibbers", "Nonners", "Markus", "Opeir", "Thompson", "Leonard", "Lincoln", "Obaguns", "Flaggon", "Washington", "Alca", "Moe", "Kosiak", "Kowalski", "Beans", "Bungles", "Pastaboy", "Jian", "Lee", "Potterfield"};
            Random rand1 = new Random();
            int lastName = rand1.nextInt(lastNames.length);
            
            Random rand2 = new Random();
            double number = Math.round(((rand2.nextInt(30) + 10) * 0.1)*100);
            double n = number/100;
            
            
            Student student1 = new Student( firstNames[firstName], lastNames[lastName], n);
            student.add(student1);
        }
       
        //Prints grade sorted list 
        System.out.println("");
        System.out.println("**List sorted by grades**");
        Collections.sort(student, new GradeComparator());
        Collections.reverse(student);
        for (int i = 0; i < student.size(); i++)
        {
            System.out.println(student.get(i));
        }
        //Prints first name sorted list
        System.out.println("");
        System.out.println("**List sorted by first name**");
        Collections.sort(student, new FirstNameComparator());
        for (int i = 0; i < student.size(); i++)
        {
            System.out.println(student.get(i));
        }
        //Prints last name sorted list
        System.out.println("");
        System.out.println("**List sorted by last name**");
        Collections.sort(student, new LastNameComparator());
        for (int i = 0; i < student.size(); i++)
        {
            System.out.println(student.get(i));
        }
    }
}
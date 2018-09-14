import java.util.*;
public class commandExcercise
{
    public static void main(String[] args)
    {
        List student = new LinkedList<Student>();
        //Random data generators
        for (int i = 0; i < 20; i++)
        {
            String[] firstNames = {"Drew", "Zargon", "Zelda", "Taco", "Zordon", "Kronk", "Camel", "Mister", "Argon", "Spaghetti", "Mario", "Krebs", "Gorgon", "Sauromon", "Kirby", "Snake", "Blue", "Oak", "Cumulus", "Irwin"};
            Random firstRandom = new Random();
            int firstName = firstRandom.nextInt(firstNames.length);
            
            String[] lastNames = {"TheDestroyer", "HasNoLastName", "ZZZZ", "Poopybutthole", "SaladBender", "Leotard", "LordOfMarshmellows", "Octagon", "Frappuchino", "Welsh", "Pringles", "Four", "DaPimpNamedSlickBack", "Wizowski", "Polack", "TM", "Feet", "Dork", "Neutron", "Planter"};
            Random lastRandom = new Random();
            int lastName = lastRandom.nextInt(lastNames.length);
            
            Random randomGPA = new Random();
            double number = Math.round(((randomGPA.nextInt(30) + 10) * 0.1)*100);
            double n = number/100;
            
            
            Student student1 = new Student( firstNames[firstName], lastNames[lastName], n);
            student.add(student1);
        }
       
       
        System.out.println("------------------ \n"+"GPA Sort"+"\n------------------ \n");
        Collections.sort(student, new GradeComparator());
        Collections.reverse(student);
        for (int i = 0; i < student.size(); i++)
        {
            System.out.println(student.get(i));
        }
     
        System.out.println("------------------ \n"+"First Name Sort"+"\n------------------ \n");
        Collections.sort(student, new FirstNameComparator());
        for (int i = 0; i < student.size(); i++)
        {
            System.out.println(student.get(i));
        }
      
        System.out.println("------------------ \n"+"Last Name/GPA Sort"+"\n------------------ \n");
        Collections.sort(student, new LastNameComparator());
        for (int i = 0; i < student.size(); i++)
        {
            System.out.println(student.get(i));
        }
    }
}
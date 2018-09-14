
public class Student
{
  
    private String firstName;
    private String lastName;
    private double gpa; 
   
    public Student() 
    {
        this( "", "", 0.0 ); 
    } 

 
    public Student(String first, String last, double gpa)
    {
        
        setFirstName( first );
        setLastName( last );
        setGpa( gpa );
    } 

   
      
    public void setFirstName( String first )
    {
        firstName = first;
    } 

  
    public String getFirstName() 
    { 
        return firstName; 
    } 


    public void setLastName( String last )
    {
        lastName = last;
    } 


    public String getLastName() 
    {
        return lastName; 
    } 


    public void setGpa( double gpaValue )
    {
        gpa = gpaValue;
    } 
 
    public double getGpa() 
    { 
        return gpa; 
    } 
    
    public String toString()
    {
        return "Student name: " + firstName + " " + lastName + "--- GPA: " + gpa+"\n";
    }
} 
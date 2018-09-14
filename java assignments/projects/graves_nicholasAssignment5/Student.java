
public class Student
{
  
    private String firstName;
    private String lastName;
    private double gpa; 
    // no-argument constructor calls other constructor with default values
    public Student() 
    {
        this( "", "", 0.0 ); // call four-argument constructor
    } // end no-argument Student constructor

    // initialize a record
    public Student(String first, String last, double gpa)
    {
        
        setFirstName( first );
        setLastName( last );
        setGpa( gpa );
    } // end four-argument Student constructor

   
    // set first name   
    public void setFirstName( String first )
    {
        firstName = first;
    } // end method setFirstName

    // get first name   
    public String getFirstName() 
    { 
        return firstName; 
    } // end method getFirstName

    // set last name   
    public void setLastName( String last )
    {
        lastName = last;
    } // end method setLastName

    // get last name   
    public String getLastName() 
    {
        return lastName; 
    } // end method getLastName

    // set grade  
    public void setGpa( double gpaValue )
    {
        gpa = gpaValue;
    } // end method setGrade

    // get grade   
    public double getGpa() 
    { 
        return gpa; 
    } // end method getGrade
    
    public String toString()
    {
        return "Student name: " + firstName + " " + lastName + "--- GPA: " + gpa+"\n";
    }
} // end class Student
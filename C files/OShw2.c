//fabian hucke
//9/26/2017
//This program calculates the Fibonnaci sequence.
//It takes user input and will display the fibonacci sequence up to the given number.
//It does so by creating a child thread which calculates the fibonacci numbers using a for loop.

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include<pthread.h>

 
 
//----------------------------------
//child thread 
int printout = 0;

int length = 0;

char buffer[500] = { 0 };


 
void *
fibonacci (void *arg)
{
  
// fib, n1, and, n2 are integer variables used in the calculation of fibonacci numbers
//fib is used to find the sum of n1 and n2
  int fib = 0;
  
// n1 is the first of the two fibonacci numbers added together, being first, it is initialized to 0
  int n1 = 0;
  
// n2 is the second of the two fibonacci numbers added together, being second, it is initialized to 1
  int n2 = 1;
  
 
 
// the fibonacci for loop needs two if statements to print out the first, or first and second numbers
//in the sequence. They cannot be calculated and printed out in the for loop since they are the 
//starting numbers.
    
//snprintf stores the print statement, BUT it IS NOT printing FROM the child thread
//print statements from child thread are stored, then printed from the parent thread
    
 
//prints out n1, the first fibonacci number if the input ==1
    if (printout == 1)
    {
      
	//snprintf stores the print statement
	snprintf (buffer, sizeof (buffer), "%d ", n1);
      
	//the child thread closes 
	pthread_exit (0);
    
 
}
  
 
//prints out n1 and n2, the first two fibonacci numbers if the input ==2
    else if (printout == 2)
    {
      
	//snprintf stores the print statement
	snprintf (buffer, sizeof (buffer), "%d, %d", n1, n2);
      
	//the child thread closes 
	
pthread_exit (0);
    
 
}
  
//if input is 0, no fibonacci numbers are printed out
    else if (printout == 0)
    {
      
	//snprintf stores the print statement
	snprintf (buffer, sizeof (buffer), " ");
      
	//the child thread closes 
	
pthread_exit (0);
    
 
}
  
//if the input is >2 then the program will print out the 2 starting numbers
// and then initiate the for loop to print out the calculated fibonacci numbers beyond that
    else
    {
      
 
//preliminary print for the first 2 numbers
	length = snprintf (buffer, sizeof (buffer), "%d, %d", n1, n2);
      
//----------------------------------------------------------
//for loop to create child to calculate and printout numbers/
//should look like
//0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377
//----------------------------------------------------------
//the for loop adds the two fibonacci numbers together
//then adds the sum to the print storage
//changes the first number's value (n1) to the second number(n2)
//then takes the previous sum(fib) and assigns that value to the second number (n2)
	for (int i = 0; i < printout - 2; i++)
	{
	  
fib = n1 + n2;
	  
length +=
	    snprintf (buffer + length, 250 - sizeof (buffer), ", %d", fib);
	  
n1 = n2;
	  
n2 = fib;
	
}
      
//once the for loop is done, a last blank value is added to the print buffer and the thread closes
	snprintf (buffer + length, 250 - sizeof (buffer), " ");
      
pthread_exit (0);
    
}

}


int
main (int argc, char *argv[])
{
  
 
//heading
    printf
    ("Please enter how many Fibonacci numbers would you like displayed: ");
  
//scanf takes the input and then sends it to the child loop later on
    scanf ("%d", &printout);
  
//no calculation is required to find the # of terms requested, so it is immediately printed
    printf ("Displaying %d terms\n", printout);
  
 
//declares a pthread then passes a pointer down to pthread_create
    pthread_t child;
  
//creates the child thread with parameters for Pthread structure, thread parameters, function, void* to start the thread
    pthread_create (&child, NULL, fibonacci, &printout);
  
//suspends execution of calling thread until the target thread terminates
    pthread_join (child, NULL);
  
//prints all the stored print statements created from the child class
    printf ("%s", &buffer);
  
// ends program
    return (0);

}


//----------------------------------
  
 

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
void* fibonacci(void *printout){
// fib, n1, and, n2 are integer variables used in the calculation of fibonacci numbers
//fib is used to find the sum of n1 and n2
int fib=0;
// n1 is the first of the two fibonacci numbers added together, being first, it is initialized to 0
int n1=0;
// n2 is the second of the two fibonacci numbers added together, being second, it is initialized to 1
int n2=1;


// the fibonacci for loop needs two if statements to print out the first, or first and second numbers
//in the sequence. They cannot be calculated and printed out in the for loop since they are the
//starting numbers.

//atoi() changes string type to int

//prints out n1, the first fibonacci number if the input ==1
if(atoi(printout) ==1){
	printf("Displaying %d terms\n", atoi(printout));
	printf("%d ", n1);
	exit(0);

}

//prints out n1 and n2, the first two fibonacci numbers if the input ==2
else if(atoi(printout) ==2){
	printf("Displaying %d terms\n", atoi(printout));
	printf("%d, %d", n1, n2);
	exit(0);

}
//if the input is >2 then the program will print out the 2 starting numbers
// and then initiate the for loop to print out the calculated fibonacci numbers beyond that
else{
	printf("Displaying %d terms\n", atoi(printout));
	printf("%d, %d", n1, n2);
//for loop to create child to calculate and printout numbers/
//should look like
//0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377
for (int i=0; i<atoi(printout)-2; i++){
	fib=n1+n2;
	printf(", %d", fib);
	n1=n2;
	n2=fib;
}
exit(0);
}
}
//----------------------------------
int main(int argc, char* argv[]){
printf("Please enter how many Fibonacci numbers would you like displayed: ");

//declares a pthread then passes a pointer down to pthread_create
pthread_t child;
//creates the child thread with parameters for Pthread structure, thread parameters, function, void* to start the thread
pthread_create(&child,NULL,fibonacci,(void*)argv[1]);
//suspends execution of calling thread until the target thread terminates
pthread_join(child,NULL);
return(0);
}


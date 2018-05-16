//fabian hucke
//8/31/2017
//9/1/2017
//9/2/2017
//9/3/2017
//9/4/2017
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

//this program takes user input from the command line 
//(loan amount, interest rate, years to pay off loan)
//displays these inputs under the appropriate labels
// it then calculates and displays the 
//month, interest paid, principle paid, and remaining loan amount
//for the first and last 6 months of payment sequentially
int main(int argc, char* argv[]){

//VARIABLE INITIALIZATIONS
//------------------------
//loan + interest
double newLoan=0;
//payments per year
int payment=0;
//monthly payment
double m=0;
// total # of payments to be made
int z=0;
//interest paid
double interest=0;
//principle
double principle=0;
//temp
double temp=0;
//number of payments per year. doesnt say to take user input so just initialize to 12 i guess
payment=12;
//initial loan
double loan;
//interest rate
double r;
//years
int t;

//dont include, not required, probably points off
//printf("enter your loan amount, interest rate, and # of payment years: ");
//set variables----change to take command-line input later
//loan=10000.00;
//r=0.060;
//t=5;

//---------------------------
//USER COMMAND LINE INPUT
//FORMAT: loan r t 
//10000 0.060 5
//INPUT ^ EXACTLY 
//NO INPUT CHECKING IMPLEMENTED- not required. 

//serious pain in the ass to find out it had to be %lf instead of %f. 
//3 hours trying to fix that shit
scanf( "%lf%lf%d", &loan, &r, &t);
//----------------------------


//MATH STUFF
-------------
//total # of payments to be made
z=t*payment;
//monthly interest rate
temp=r/payment;
//monthly payment calculation
m=loan*(temp+(temp/(pow((1+temp),(payment*t))-1)));

 

//HEADER
//-------
//printing all the pre-calculation heading stuff
printf("Amortization Schedule\n");
printf("Initial Balance: $%.2f\n", loan);
printf("APR: %.2f\n", r);
printf("Years: %d\n\n", t);
printf("Monthly Payment: $%.2f\n\n", m);
printf("Month	Int.	Princ.	Balance\n");


//loop that increments month and calculates
//value 'dots' to make line of "..." print once between payment gap
int dots=1;
for (int i=1; i<z+1; ++i){
//interest rate * loan + previous loan amount
newLoan=loan*temp + loan;
//newLoan-loan to get interest paid
interest=newLoan-loan;
//monthly payment - interest paid to get principle
principle=m-interest;
//newLoan - monthly payment = new loan balance
loan=newLoan-m;
//calculate if m exceeds remaining debt balance

	
//variable that tracks first 6 months of payment
int min=7;
//variable that tracks last 6 months of payment
int max=z-6;


//if statement checks to see if monthly payments 
//are within the first or last 6 months of pay period
if (i<min || i>max){
	//monthly report printout
	printf("%d 	$%.2f 	$%.2f $%.2f\n",i,interest,principle,loan);
}
else{
	if (dots==1){
		dots++;
		printf("...\n");
		//inefficient but whatever
	}
}
}


return 0;
}
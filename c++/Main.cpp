//========================================================================
// This conversion was produced by the Free Edition of
// Java to C++ Converter courtesy of Tangible Software Solutions.
// Order the Premium Edition at https://www.tangiblesoftwaresolutions.com
//========================================================================

#include "Main.h"
#include "Loan.h"
Main::Main()
{
	// initialise instance variables
	x = 0;
}

int Main::sampleMethod(int y)
{
	// put your code here
	return x + y;
}


Loan::Loan()
{
	// initialise instance variables
	int amount;
	double interest;
	int years;
}

void Loan::setAmount(int newAmount)
{
	amount = newAmount;
}

int Loan::getAmount()
{
	return amount;
}

void Loan::setInterest(double newInterest)
{
	interest = newInterest;
}

void Loan::setYears(int newYear)
{
	years = newYear;
}

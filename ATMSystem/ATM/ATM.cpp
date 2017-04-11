#include "ATM.h"
#include "Transaction.h"
#include "BalanceEnquiry.h"
#include "Withdrawal.h"
#include "Deposit.h"

// enumeration constant represent main menu options
enum MenuOptions { BALANCE_INQUIRY = 1, WITHDRAWAL, DEPOSIT, EXIT };

ATM::ATM()  // user is not authenticated
	: userAuthenticated(false),
	currentAccountNumber(0)  // no current account number to start
{
}

void ATM::run()
{
	// Welcome and authenticate user; process transactions
	while (true)
	{
		// loop while user is not yet authenticated
		while (!userAuthenticated)
		{
			screen.displayMessage("\n Welcome !");
			authenticateUser(); // authenticate user
		} // end while
		performTransaction(); // user is now authenticated
		userAuthenticated = false; // reset before next ATM session
		currentAccountNumber = 0; // reset before next ATM session
		screen.displayMessageLine("Thank you good bye !!!");
	} // end while
} // end function

void ATM::authenticateUser()
{
	screen.displayMessage("\n Please enter your account number: ");
	int accNumber = keypad.getInput(); // input account number
	screen.displayMessage("\n Enter your PIN: "); // prompt for PIN
	int pin = keypad.getInput(); // input PIN

	// set userAuthenticated too bool value returned by database
	userAuthenticated = bankDatabase.authenticateUser(accNumber, pin);

	// check whether authenticated succeeded
	if (userAuthenticated)
	{
		currentAccountNumber = accNumber; // save user account #
	}
	else
		screen.displayMessageLine("Invalid account number or PIN. Please try again.");
} //end function authenticateUser

// display the main menu and perform transaction
void ATM::performTransaction()
{
	// local pointer to store transaction currently being processed
	Transaction *currentTransactionPtr;
	bool userExited = false; // user has not chosen option to exit

	// loop while user has not chosen option to exit system
	while (!userExited)
	{
		// show main menu and get user selection
		int mainMenuSelection = displayMainMenu();

		// decide how to proceed based on user's menu selection 
		switch (mainMenuSelection)
		{
			// choose to perform one of three transaction types
		case BALANCE_INQUIRY:
		case WITHDRAWAL:
		case DEPOSIT:
			// initialize as new object of chosen type
			currentTransactionPtr = createTransaction(mainMenuSelection);
			currentTransactionPtr->execute(); // execute transaction
			delete currentTransactionPtr;
			break;
		case EXIT: // user chose to terminate session
			screen.displayMessageLine("Exiting the system ... ");
			userExited = true;
			break;
		default:
			screen.displayMessageLine("You did not enter a valid selection. Try again");
			break;
		} // end switch
	} // end while
} // end function performTransaction

int ATM::displayMainMenu() const
{
	screen.displayMessageLine("\n Main menu :");
	screen.displayMessageLine("1 - View my balance :");
	screen.displayMessageLine("2 - Withdraw cash :");
	screen.displayMessageLine("3 - Deposit funds :");
	screen.displayMessageLine("4 - Exit :");
	screen.displayMessageLine(" Enter a choice :");
	return keypad.getInput(); // return user's selection
}

Transaction * ATM::createTransaction(int type)
{
	Transaction *tempPtr; // tempporary transaction pointer

	switch (type)
	{
	case BALANCE_INQUIRY:
		tempPtr = new BalanceEnquiry(currentAccountNumber, screen, bankDatabase);
		break;
	case WITHDRAWAL: // create new withdrawal transaction
		tempPtr = new Withdrawal(currentAccountNumber, screen, bankDatabase, keypad, cashDispenser);
		break;
	case DEPOSIT: // create a new deposit transaction
		tempPtr = new Deposit(currentAccountNumber, screen, bankDatabase, keypad, depositSlot);
		break;
	}
	return tempPtr; // return the newly created object
} // end switch

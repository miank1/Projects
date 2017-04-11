#ifndef ATM_H
#define ATM_H

#include "Screen.h"
#include "Keypad.h"
#include "CashDispenser.h"
#include "DepositSlot.h"
#include "BankDatabase.h"
class Transaction;

class ATM
{
public:
	ATM(); // constructor initializes data members
	void run(); // start the ATM
private:
	bool userAuthenticated;
	int currentAccountNumber;
	Screen screen; // ATM Screen
	Keypad keypad; // ATM Keypad
	CashDispenser cashDispenser; // ATM Cash dispenser
	DepositSlot depositSlot; // ATM deposit slot
	BankDatabase bankDatabase; // Account information database

	// private utility functions
	void authenticateUser(); // attempt to authenticate user
	void performTransaction(); // perform transaction
	int displayMainMenu() const; // display main menu

	// return object to specified transaction derived class
	Transaction *createTransaction(int);
};

#endif 

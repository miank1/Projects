#ifndef WITHDRAWAL_H
#define WITHDRAWAL_H

#include "Keypad.h"
#include "CashDispenser.h"
#include "Transaction.h"

class Keypad;
class CashDispenser;

class Withdrawal : public Transaction
{
private:
	int accountNumbers; // account to withdraw funds from
	double amount; // account to withdraw

	//reference to associated objects
	Keypad &keypad; // reference to keypad
	CashDispenser &cashDispenser; // reference to ATM cash dispenser

public:
	Withdrawal();
	~Withdrawal();
	virtual void execute();
}; 

#endif // !WITHDRAWAL_H
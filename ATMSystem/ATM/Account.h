#ifndef ACCOUNT_H
#define ACCOUNT_H

class Account
{
	int accountNumber; // account number
	int pin; // PIN for authentication
	double availableBalance; // funds available for withdrawal
	double totalBalance; // funds available + funds waiting to clear
public:
	Account(int, int, double, double); // constructor set attribute
	bool validatePin(int) const; // is user-specific PIN correct
	double getAvailableBalance() const; // returns available balance
	double getTotalBalance() const; // return total balance
	void credit(double); // adds an amount to account balance
	void debit(double); // substracts an amount from the account balance
	int getAccountNumber() const;
}; 

#endif // !ACCOUNT_H


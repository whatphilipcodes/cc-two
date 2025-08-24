#include "ATMWithdrawCpp/ATM.h"
#include <libraw/libraw.h>
#include <string>

ATM::ATM(int initialBalance) : balance(initialBalance) {}

bool ATM::withdraw(int amount)
{
    if (balance >= amount)
    {
        balance -= amount;
        return true;
    }
    return false;
}

int ATM::getBalance() const
{
    return balance;
}

const char *ATM::getLibRawVersion() const
{
    return LibRaw::version();
}
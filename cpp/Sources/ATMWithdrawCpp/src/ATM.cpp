#include "ATMWithdrawCpp/ATM.h"
#include <libraw/libraw.h>
#include <iostream>

ATM::ATM(int initialBalance) : balance(initialBalance) {}

bool ATM::withdraw(int amount)
{
    LibRaw rawProcessor;
    std::cout << "LibRaw version: " << LibRaw::version() << std::endl;

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
#include "AberrWithdrawCpp/Aberr.h"
#include <libraw/libraw.h>
#include <string>

Aberr::Aberr(int initialBalance) : balance(initialBalance) {}

bool Aberr::withdraw(int amount)
{
    if (balance >= amount)
    {
        balance -= amount;
        return true;
    }
    return false;
}

int Aberr::getBalance() const
{
    return balance;
}

const char *Aberr::getLibRawVersion() const
{
    return LibRaw::version();
}
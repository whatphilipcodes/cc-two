#pragma once

#include <string>

class ATM
{
public:
    ATM(int initialBalance);
    bool withdraw(int amount);
    int getBalance() const;

    // Returns the LibRaw version info C string (static from LibRaw).
    const char *getLibRawVersion() const;

private:
    int balance;
};
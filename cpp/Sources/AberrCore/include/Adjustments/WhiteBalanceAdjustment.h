#pragma once

#include "IAdjustment.h"

class WhiteBalanceAdjustment : public IAdjustment
{
public:
    WhiteBalanceAdjustment(float kelvin);
    void apply(LibRaw &processor) override;

private:
    float temperature;
};
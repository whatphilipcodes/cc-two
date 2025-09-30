#pragma once

#include "IAdjustment.h"

class WhiteBalanceAdjustment : public IAdjustment
{
public:
    WhiteBalanceAdjustment(float kelvin);
    void apply(LibRaw &iProcessor) override;

private:
    float temperature;
};
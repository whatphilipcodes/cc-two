#pragma once

#include "IAdjustment.h"

class WhiteBalanceAdjustment : public IAdjustment
{
public:
    WhiteBalanceAdjustment(float kelvin);
    void apply(LibRaw &processor) override;
    void setParameter(float value) override;
    float getParameter() const override;

private:
    float temperature;
};
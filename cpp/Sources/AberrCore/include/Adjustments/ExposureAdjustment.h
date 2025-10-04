#pragma once

#include "IAdjustment.h"

class ExposureAdjustment : public IAdjustment
{
public:
    ExposureAdjustment(float stops);
    void apply(LibRaw &processor) override;
    void setParameter(float value) override;
    float getParameter() const override;

private:
    float stops;
};
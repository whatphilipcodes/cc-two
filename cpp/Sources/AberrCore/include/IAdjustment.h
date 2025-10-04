#pragma once

#include "libraw/libraw.h"

class IAdjustment
{
public:
    virtual ~IAdjustment() {}
    virtual void setParameter(float value) = 0;
    virtual float getParameter() const = 0;
    virtual void apply(LibRaw &processor) = 0;
};
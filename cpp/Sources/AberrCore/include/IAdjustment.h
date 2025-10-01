#pragma once

#include "libraw/libraw.h"

class IAdjustment
{
public:
    virtual ~IAdjustment() {}
    virtual void apply(LibRaw &iProcessor) = 0;
};
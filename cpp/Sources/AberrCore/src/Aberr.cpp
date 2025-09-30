#include "Aberr.h"
#include <libraw/libraw.h>

const char *Aberr::getLibRawVersion() const
{
    return LibRaw::version();
}
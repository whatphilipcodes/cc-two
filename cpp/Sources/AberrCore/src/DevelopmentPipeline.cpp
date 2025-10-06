#include "DevelopmentPipeline.h"

void DevelopmentPipeline::process(LibRaw &processor, ProcessingQuality quality)
{
    exp.apply(processor);
    wb.apply(processor);
}
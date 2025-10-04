#include "DevelopmentPipeline.h"

// DevelopmentPipeline::DevelopmentPipeline()
//     : exp(0.0f), wb(5500.0f)
// {
// }

void DevelopmentPipeline::process(LibRaw &processor)
{
    exp.apply(processor);
    wb.apply(processor);
}
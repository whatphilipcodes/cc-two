#include "DevelopmentPipeline.h"

struct DevelopmentPipeline::Impl
{
    std::vector<std::unique_ptr<IAdjustment>> sensorAdjustments;
    std::vector<std::unique_ptr<IAdjustment>> imageAdjustments;
};

DevelopmentPipeline::DevelopmentPipeline() : pimpl(std::make_unique<Impl>()) {}

// generating defaults that were disabled due to pimpl
DevelopmentPipeline::~DevelopmentPipeline() = default;
DevelopmentPipeline::DevelopmentPipeline(DevelopmentPipeline &&) noexcept = default;
DevelopmentPipeline &DevelopmentPipeline::operator=(DevelopmentPipeline &&) noexcept = default;

void DevelopmentPipeline::addSensorAdjustmet(std::unique_ptr<IAdjustment> adjustment)
{
    pimpl->sensorAdjustments.push_back(std::move(adjustment));
}

void DevelopmentPipeline::addImageAdjustment(std::unique_ptr<IAdjustment> adjustment)
{
    pimpl->imageAdjustments.push_back(std::move(adjustment));
}

void DevelopmentPipeline::process(LibRaw &processor)
{
    for (const auto &adjustment : pimpl->sensorAdjustments)
    {
        if (adjustment)
        {
            adjustment->apply(processor);
        }
    }

    processor.raw2image();

    for (const auto &adjustment : pimpl->imageAdjustments)
    {
        if (adjustment)
        {
            adjustment->apply(processor);
        }
    }
}
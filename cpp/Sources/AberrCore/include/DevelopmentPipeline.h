#pragma once

#include <vector>
#include <memory>
#include "libraw/libraw.h"
#include "IAdjustment.h"

class DevelopmentPipeline
{
public:
    DevelopmentPipeline();
    ~DevelopmentPipeline();

    // prevent copy operation (pimpl)
    DevelopmentPipeline(const DevelopmentPipeline &) = delete;
    DevelopmentPipeline &operator=(const DevelopmentPipeline &) = delete;

    // re-enable move (pimpl: rule of 5 compliance)
    DevelopmentPipeline(DevelopmentPipeline &&) noexcept;
    DevelopmentPipeline &operator=(DevelopmentPipeline &&) noexcept;

    void addAdjustment(std::unique_ptr<IAdjustment> adjustment);
    void process(LibRaw &iProcessor);

private:
    // because the interop layer is issues with complex nested types pimpl is used: https://learn.microsoft.com/en-us/cpp/cpp/pimpl-for-compile-time-encapsulation-modern-cpp?view=msvc-170
    struct Impl;
    std::unique_ptr<Impl> pimpl;
};
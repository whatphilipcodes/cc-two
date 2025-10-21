import AberrPackage
import Foundation

func readInput(prompt: String, defaultValue: String) -> String {
    print("\(prompt) (default: \(defaultValue)): ", terminator: "")
    let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines)
    return input?.isEmpty == false ? input! : defaultValue
}

func readFloatInput(prompt: String, defaultValue: Float) -> Float {
    print("\(prompt) (default: \(defaultValue)): ", terminator: "")
    let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines)
    if let input = input, !input.isEmpty, let floatValue = Float(input) {
        return floatValue
    }
    return defaultValue
}

var aberr = AberrWrapper()

print("=== Aberr CLI - RAW Image Editor CXX Functionality Validation ===")
print("LibRaw Version: \(aberr.libRawVersionInfo())")
print()

let imagePath = readInput(
    prompt: "Enter raw image file path", defaultValue: "../cpp/Assets/car.dng")
print("Loading image from: \(imagePath)")
aberr.loadImage(from: imagePath)
print("Image loaded successfully!")
print()

let whiteBalanceKelvin = readFloatInput(
    prompt: "Enter white balance kelvin value", defaultValue: 5500)
print("Setting white balance to: \(whiteBalanceKelvin)K")
print()

let exposureStops = readFloatInput(prompt: "Enter exposure stops", defaultValue: 0)
print("Setting exposure to: \(exposureStops) stops")
print()

print("Applying adjustments...")
aberr.updateAdjustment(type: .WhiteBalance, value: whiteBalanceKelvin)
aberr.updateAdjustment(type: .Exposure, value: exposureStops)

print("Rendering...")
aberr.render()

print("Getting processed image...")
if let processedImage = aberr.getImage() {
    print("Image dimensions: \(processedImage.width) x \(processedImage.height)")
    print("Bits per component: \(processedImage.bitsPerComponent)")
    print("Components per pixel: \(processedImage.componentsPerPixel)")
    print("Data size: \(processedImage.data.count) bytes")
} else {
    print("Failed to get processed image")
}

print("Processing complete!")

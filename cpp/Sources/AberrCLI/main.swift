import AberrPackage
import Foundation

print("=== Aberr CLI - RAW Image Color Temperature Editor ===")
print("LibRaw Version: \(AberrWrapper().libRawVersionInfo())")
print()

var aberr = AberrWrapper()

// Step 1: Get input file path
print("Please enter a filepath (press Enter for test image):")
let input = readLine()
let filepath = input?.isEmpty == false ? input! : "./Assets/car.dng"
print("Loading: \(filepath)")

// Step 2: Load the raw image
if !aberr.loadRawImage(filepath) {
    print("Error loading image: \(aberr.getLastError())")
    exit(1)
}

// Step 3: Get current color temperature and ask for new one
let currentTemp = aberr.getCurrentColorTemperature()
print("Input desired color temperature (current: \(Int(currentTemp))K):")

guard let tempInput = readLine(), !tempInput.isEmpty else {
    print("No temperature specified, using current: \(Int(currentTemp))K")
    // Use current temperature and continue processing
    aberr.setColorTemperature(currentTemp)
    
    // Process and save the image with current temperature
    let outputPath = "output_\(Int(currentTemp))K.ppm"
    print("Processing and saving to: \(outputPath)")
    
    if aberr.processAndSave(outputPath) {
        print("✅ Success! Image processed and saved with original temperature.")
    } else {
        print("❌ Error processing image: \(aberr.getLastError())")
        exit(1)
    }
    exit(0)
}

guard let newTemp = Float(tempInput) else {
    print("Invalid temperature value, using current: \(Int(currentTemp))K")
    // Use current temperature and continue processing
    aberr.setColorTemperature(currentTemp)
    
    // Process and save the image with current temperature
    let outputPath = "output_\(Int(currentTemp))K.ppm"
    print("Processing and saving to: \(outputPath)")
    
    if aberr.processAndSave(outputPath) {
        print("✅ Success! Image processed and saved with original temperature.")
    } else {
        print("❌ Error processing image: \(aberr.getLastError())")
        exit(1)
    }
    exit(0)
}

// Validate temperature range
let clampedTemp = max(2000, min(10000, newTemp))
if clampedTemp != newTemp {
    print("Temperature clamped to valid range: \(Int(clampedTemp))K")
}

// Step 4: Apply the color temperature
aberr.setColorTemperature(clampedTemp)

// Step 5: Process and save the image
let outputPath = "output_\(Int(clampedTemp))K.ppm"
print("Processing and saving to: \(outputPath)")

if aberr.processAndSave(outputPath) {
    print("✅ Success! Image processed and saved.")
    print("Color temperature changed from \(Int(currentTemp))K to \(Int(clampedTemp))K")
} else {
    print("❌ Error processing image: \(aberr.getLastError())")
    exit(1)
}

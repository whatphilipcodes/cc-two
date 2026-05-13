import AberrPackage
import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

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

func savePNG(processedImage: AberrWrapper.ProcessedImage, inputPath: String) -> Bool {
    // Create output path by replacing extension with .png
    let inputURL = URL(fileURLWithPath: inputPath)
    let outputURL = inputURL.deletingPathExtension().appendingPathExtension("png")

    print("Saving to: \(outputURL.path)")
    print(
        "Image info - bits: \(processedImage.bitsPerComponent), components: \(processedImage.componentsPerPixel)"
    )

    // LibRaw outputs 8-bit or 16-bit data
    // For 16-bit, we need to ensure proper handling

    // Create color space
    guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else {
        print("Failed to create color space")
        return false
    }

    // Calculate bytes per row
    let bytesPerComponent = processedImage.bitsPerComponent / 8
    let bytesPerPixel = processedImage.componentsPerPixel * bytesPerComponent
    let bytesPerRow = processedImage.width * bytesPerPixel

    print("Bytes per row: \(bytesPerRow), bytes per pixel: \(bytesPerPixel)")
    print(
        "Expected data size: \(bytesPerRow * processedImage.height), actual: \(processedImage.data.count)"
    )

    // Debug: print first few pixels
    if processedImage.data.count >= 12 {
        print(
            "First pixel RGB: \(processedImage.data[0]), \(processedImage.data[1]), \(processedImage.data[2])"
        )
        print(
            "Second pixel RGB: \(processedImage.data[3]), \(processedImage.data[4]), \(processedImage.data[5])"
        )
    }

    // Create bitmap info
    var bitmapInfo: CGBitmapInfo
    if processedImage.componentsPerPixel == 3 {
        bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
    } else if processedImage.componentsPerPixel == 4 {
        bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue)
    } else {
        print("Unsupported number of components: \(processedImage.componentsPerPixel)")
        return false
    }

    // For 16-bit images, add the 16-bit flag
    if processedImage.bitsPerComponent == 16 {
        bitmapInfo.insert(.byteOrder16Little)
    }

    // Create CGImage from raw data
    guard let dataProvider = CGDataProvider(data: processedImage.data as CFData) else {
        print("Failed to create data provider")
        return false
    }

    guard
        let cgImage = CGImage(
            width: processedImage.width,
            height: processedImage.height,
            bitsPerComponent: processedImage.bitsPerComponent,
            bitsPerPixel: processedImage.bitsPerComponent * processedImage.componentsPerPixel,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: dataProvider,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )
    else {
        print("Failed to create CGImage")
        return false
    }

    // Write PNG file
    guard
        let destination = CGImageDestinationCreateWithURL(
            outputURL as CFURL,
            UTType.png.identifier as CFString,
            1,
            nil
        )
    else {
        print("Failed to create image destination")
        return false
    }

    CGImageDestinationAddImage(destination, cgImage, nil)

    if CGImageDestinationFinalize(destination) {
        print("Successfully saved PNG to: \(outputURL.path)")
        return true
    } else {
        print("Failed to finalize image destination")
        return false
    }
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
    print()

    // Save as PNG
    if savePNG(processedImage: processedImage, inputPath: imagePath) {
        print("PNG export successful!")
    } else {
        print("PNG export failed!")
    }
} else {
    print("Failed to get processed image")
}

print("Processing complete!")

import AberrCore
import Foundation

public typealias AdjustmentType = AberrCore.AdjustmentType

public class AberrWrapper {
    public struct ProcessedImage {
        public let data: Data
        public let width: Int
        public let height: Int
        public let bitsPerComponent: Int
        public let componentsPerPixel: Int
    }

    private var aberr: Aberr

    public init() {
        self.aberr = Aberr()
    }

    public func libRawVersionInfo() -> String {
        return String(aberr.getLibRawVersion())
    }

    public func loadImage(from path: String) {
        path.withCString { cPath in
            aberr.loadImageFromFile(UnsafeMutablePointer(mutating: cPath))
        }
    }

    public func loadImage(from data: Data) {
        data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) in
            if let baseAddress = pointer.baseAddress {
                aberr.loadImageFromBuffer(baseAddress, data.count)
            }
        }
    }

    public func updateAdjustment(type: AdjustmentType, value: Float) {
        aberr.updateAdjustment(type, value)
    }

    public func getImage() -> ProcessedImage? {
        var info = ProcessedImageInfo()

        let imageBytes = aberr.getProcessedImageBytes(&info)

        // Convert std::vector to Swift Data
        var data = Data()
        for i in 0..<imageBytes.size() {
            data.append(imageBytes[i])
        }

        return ProcessedImage(
            data: data,
            width: Int(info.width),
            height: Int(info.height),
            bitsPerComponent: Int(info.bits),
            componentsPerPixel: Int(info.colors)
        )
    }

    public func preview() {
        aberr.preview()
    }

    public func render() {
        aberr.render()
    }
}

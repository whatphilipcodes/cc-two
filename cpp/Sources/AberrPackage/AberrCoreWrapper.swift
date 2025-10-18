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
        var result: ProcessedImage?

        withUnsafeMutablePointer(to: &result) { resultPtr in
            let callback:
                @convention(c) (UnsafePointer<libraw_processed_image_t>?, UnsafeMutableRawPointer?)
                    -> Void = { imagePtr, context in
                        guard let imagePtr = imagePtr,
                            let context = context
                        else {
                            return
                        }

                        let resultPtr = context.assumingMemoryBound(
                            to: Optional<ProcessedImage>.self)

                        var image = imagePtr.pointee
                        let pixelData = Data(bytes: &image.data, count: Int(image.data_size))

                        resultPtr.pointee = ProcessedImage(
                            data: pixelData,
                            width: Int(image.width),
                            height: Int(image.height),
                            bitsPerComponent: Int(image.bits),
                            componentsPerPixel: Int(image.colors)
                        )
                    }

            aberr.withProcessedImage(callback, resultPtr)
        }

        return result
    }

    public func preview() {
        aberr.preview()
    }

    public func render() {
        aberr.render()
    }
}

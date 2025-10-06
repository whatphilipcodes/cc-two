import Foundation

import AberrCore
public typealias AdjustmentType = AberrCore.AdjustmentType

public class AberrWrapper {
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
    
    public func getImage() {
        aberr.getImage()
    }
    
    public func preview() {
        aberr.preview()
    }
    
    public func render() {
        aberr.render()
    }
}
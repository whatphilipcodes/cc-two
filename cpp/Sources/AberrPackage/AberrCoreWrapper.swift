import AberrCore

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
            aberr.loadImage(UnsafeMutablePointer(mutating: cPath))
        }
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
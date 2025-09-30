import AberrCore

public class AberrWrapper {
    private var aberr: Aberr

    public init() {
        self.aberr = Aberr()
    }

    public func libRawVersionInfo() -> String {
        return String(aberr.getLibRawVersion())
    }
}
import AberrCore

public struct AberrWrapper {
  private var underlying: Aberr

  public init() {
    self.underlying = Aberr()
  }

  public func libRawVersionInfo() -> String {
    String(cString: underlying.getLibRawVersion())
  }
}

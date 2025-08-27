import AberrCore

public struct AberrWrapper {
  private var underlying: Aberr

  public init(initialBalance: Int32) {
    underlying = Aberr(initialBalance)
  }

  public mutating func withdraw(amount: Int32) -> Bool {
    return underlying.withdraw(amount)
  }

  public func getBalance() -> Int32 {
    return underlying.getBalance()
  }

  public func libRawVersionInfo() -> String {
    String(cString: underlying.getLibRawVersion())
  }
}

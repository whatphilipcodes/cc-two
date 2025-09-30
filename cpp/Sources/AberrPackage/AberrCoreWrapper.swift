import AberrCore

public class AberrWrapper {
  private var underlying: Aberr

  public init() {
    self.underlying = Aberr()
  }

  public func libRawVersionInfo() -> String {
    String(underlying.getLibRawVersion())
  }
  
  public func loadRawImage(_ filepath: String) -> Bool {
    return underlying.loadRawImage(filepath)
  }
  
  public func getCurrentColorTemperature() -> Float {
    return underlying.getCurrentColorTemperature()
  }
  
  public func setColorTemperature(_ temperature: Float) {
    underlying.setColorTemperature(temperature)
  }
  
  public func processAndSave(_ outputPath: String) -> Bool {
    return underlying.processAndSave(outputPath)
  }
  
  public func getLastError() -> String {
    String(underlying.getLastError())
  }
}

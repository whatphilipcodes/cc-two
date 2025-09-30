import AberrPackage
import Foundation

class AberrViewModel: ObservableObject {
  private var aberr: AberrWrapper
  @Published var libRawVersion: String = ""

  init(aberr: AberrWrapper = AberrWrapper()) {
    self.aberr = aberr
    self.libRawVersion = aberr.libRawVersionInfo()
  }
}

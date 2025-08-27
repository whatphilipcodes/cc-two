import SwiftUI

@main
struct AberrProjApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(viewModel: AberrViewModel())
    }
  }
}

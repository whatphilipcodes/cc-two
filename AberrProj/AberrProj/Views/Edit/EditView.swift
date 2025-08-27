import SwiftUI

struct EditView: View {
  @ObservedObject var viewModel: AberrViewModel
  @State private var showingPicker = false

  init(viewModel: AberrViewModel = AberrViewModel()) {
    self.viewModel = viewModel
  }

  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        Button("Select DNG Photo") {
            print("open picker")
        }
      }
    }
    .navigationTitle("Edit")
    .navigationBarTitleDisplayMode(.large)
  }
}

#Preview {
  EditView()
}

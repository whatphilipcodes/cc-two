import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel: AberrViewModel

  var body: some View {
    TabView {
      EditView()
        .tabItem {
          Image(
            systemName:
              "slider.horizontal.3"
          )
          Text(
            "Edit"
          )
        }
      SettingsView(
        viewModel:
          viewModel
      )
      .tabItem {
        Image(
          systemName:
            "gear"
        )
        Text(
          "Settings"
        )
      }
    }
    .accentColor(
      .blue
    )
  }
}

#Preview {
  ContentView(
    viewModel:
      AberrViewModel()
  )
}

import SwiftUI

@main
struct AberrProjApp: App {
    // 1. Create the error service as a @StateObject at the top level of the app.
    @StateObject private var errorService = ErrorHandlingService()

    var body: some Scene {
        WindowGroup {
            // 2. Wrap your ContentView in a ZStack to allow the toast to hover over it.
            ZStack {
                ContentView(viewModel: AberrViewModel())
                    // 3. Inject the service into the environment for all child views to access.
                    .environmentObject(errorService)
                
                // This is the UI logic for displaying the toast view.
                VStack {
                    if let error = errorService.currentError {
                        ErrorToastView(error: error)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    Spacer() // Pushes the toast to the top
                }
                .animation(.spring(), value: errorService.currentError)
                .padding()
            }
        }
    }
}

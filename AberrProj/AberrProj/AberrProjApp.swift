import SwiftUI

@main
struct AberrProjApp: App {
    @StateObject private var errorService = ErrorHandlingService()

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView(viewModel: AberrViewModel())
                    .environmentObject(errorService)
                VStack {
                    if let error = errorService.currentError {
                        ErrorToastView(error: error)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    Spacer()
                }
                .animation(.spring(), value: errorService.currentError)
                .padding()
            }
        }
    }
}

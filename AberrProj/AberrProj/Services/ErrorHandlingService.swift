import Foundation
import SwiftUI

struct AppError: Equatable, Identifiable {
  let id = UUID()
  let message: String
  let iconName: String = "exclamationmark.triangle.fill"
}

@MainActor
class ErrorHandlingService: ObservableObject {
  @Published private(set) var currentError: AppError?

  func show(message: String) {
    currentError = AppError(message: message)

    Task {
      try? await Task.sleep(for: .seconds(3))
      currentError = nil
    }
  }
}

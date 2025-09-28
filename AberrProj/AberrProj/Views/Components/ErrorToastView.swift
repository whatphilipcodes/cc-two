import SwiftUI

struct ErrorToastView: View {
    let error: AppError
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: error.iconName)
                .font(.headline)
                .foregroundColor(.yellow)
            
            Text(error.message)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.red)
        .clipShape(Capsule())
        .shadow(radius: 10)
    }
}

#Preview {
    ErrorToastView(error: AppError(message: "Could not connect to the server."))
}

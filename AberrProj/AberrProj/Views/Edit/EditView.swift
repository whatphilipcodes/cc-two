import Photos
import SwiftUI

struct EditView: View {
  @State private var isShowingRawPicker = false
  @State private var selectedImage: UIImage?
  @EnvironmentObject var errorService: ErrorHandlingService

  @State private var exposure: Double = 0.0
  @State private var temperature: Double = 6500.0

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        if let finalImage = selectedImage {
          Spacer()
          Image(uiImage: finalImage)
            .resizable()
            .scaledToFit()
          Spacer()
        } else {
          Image(systemName: "photo.on.rectangle.angled")
            .font(.system(size: 100))
            .foregroundStyle(.gray.opacity(0.4))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        if selectedImage != nil {
          EditControlsView(exposure: $exposure, temperature: $temperature)
        }
      }
      .sheet(isPresented: $isShowingRawPicker) {
        RawPhotoGridView { image in
          self.selectedImage = image
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Select") {
            isShowingRawPicker = true
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Export") {
            errorService.show(message: "Export not yet implemented")
          }
        }
      }
    }
  }
}

#Preview {
  EditView()
    .environmentObject(ErrorHandlingService())
}

import Photos
import SwiftUI

struct EditView: View {
  @State private var isShowingRawPicker = false
  @State private var selectedImage: UIImage?
  @EnvironmentObject var errorService: ErrorHandlingService

  var body: some View {
    NavigationStack {
      VStack(spacing: 30) {

        if let finalImage = selectedImage {
          Image(uiImage: finalImage)
            .resizable()
            .scaledToFit()
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 10))
          Text("✅ Photo Loaded!")
            .font(.headline)
            .foregroundStyle(.green)
        } else {
          Image(systemName: "photo.on.rectangle.angled")
            .font(.system(size: 100))
            .foregroundStyle(.gray.opacity(0.4))
        }
      }
      .sheet(isPresented: $isShowingRawPicker) {
        RawPhotoGridView { image in
          self.selectedImage = image
        }
      }
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarLeading) {
          Button("Select") {
            isShowingRawPicker = true
          }
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
}

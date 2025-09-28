import Photos
import SwiftUI

struct EditView: View {
  @State private var isShowingRawPicker = false
  @State private var selectedImage: UIImage?

  var body: some View {
    VStack(spacing: 30) {

      if let finalImage = selectedImage {
        Image(uiImage: finalImage)
          .resizable()
          .scaledToFit()
          .frame(height: 250)
          .clipShape(RoundedRectangle(cornerRadius: 10))
        Text("✅ RAW Photo Loaded!")
          .font(.headline)
          .foregroundStyle(.green)
      } else {
        Image(systemName: "photo.on.rectangle.angled")
          .font(.system(size: 100))
          .foregroundStyle(.gray.opacity(0.4))
      }

      Button {
        isShowingRawPicker = true
      } label: {
        Label("Open RAW Photo Picker", systemImage: "photo.stack")
      }
      .buttonStyle(.borderedProminent)

    }
    .navigationTitle("Edit")
    .sheet(isPresented: $isShowingRawPicker) {
      RawPhotoGridView { image in
        self.selectedImage = image
      }
    }
  }
}

#Preview {
  NavigationStack {
    EditView()
  }
}

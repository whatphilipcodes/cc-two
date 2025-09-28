import Photos
import SwiftUI

struct RawPhotoGridView: View {
  @StateObject private var photoService = PhotoLibraryService()
  @Environment(\.dismiss) var dismiss

  var onPhotoSelected: (UIImage) -> Void

  private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

  var body: some View {
    NavigationStack {
      Group {
        if photoService.rawAssets.isEmpty {
          VStack(spacing: 16) {
            Image(systemName: "photo.stack")
              .font(.system(size: 60))
              .foregroundStyle(.gray)
            Text("No RAW Photos Found")
              .font(.title2)
          }
        } else {
          ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
              ForEach(photoService.rawAssets, id: \.self) { asset in
                PhotoGridItemView(asset: asset) { downloadedImage in
                  onPhotoSelected(downloadedImage)
                  dismiss()
                }
              }
            }
          }
        }
      }
      .navigationTitle("Select a RAW Photo")
      .navigationBarTitleDisplayMode(.inline)
      .onAppear {
        photoService.checkForPermissionAndFetch()
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", action: { dismiss() })
        }
      }
    }
  }
}

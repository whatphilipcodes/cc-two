import Photos
import SwiftUI

struct RawPhotoGridView: View {
  @StateObject private var photoService = PhotoLibraryService()
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var errorService: ErrorHandlingService

  var onPhotoSelected: (UIImage) -> Void

  @State private var activeDownloadAssetID: String? = nil
  @State private var downloadProgress: Double = 0.0
  @State private var downloadRequestID: PHImageRequestID? = nil

  private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 2) {
          ForEach(photoService.rawAssets, id: \.self) { asset in
            let isDownloadingThisAsset = (asset.localIdentifier == activeDownloadAssetID)
            let isAnyAssetDownloading = (activeDownloadAssetID != nil)

            PhotoGridItemView(
              asset: asset,
              isDownloading: isDownloadingThisAsset,
              progress: downloadProgress,
              isDisabled: isAnyAssetDownloading && !isDownloadingThisAsset
            )
            .onTapGesture {
              handleTap(on: asset)
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
          Button("Cancel", action: cancelAndDismiss)
        }
      }
    }
  }

  private func handleTap(on asset: PHAsset) {
    if let activeID = activeDownloadAssetID {
      if activeID == asset.localIdentifier {
        cancelCurrentDownload()
      }
    } else {
      startDownload(for: asset)
    }
  }

  private func startDownload(for asset: PHAsset) {
    activeDownloadAssetID = asset.localIdentifier
    downloadProgress = 0.0

    let options = PHImageRequestOptions()
    options.isNetworkAccessAllowed = true
    options.deliveryMode = .highQualityFormat
    options.resizeMode = .exact

    options.progressHandler = { progress, _, _, _ in
      DispatchQueue.main.async {
        self.downloadProgress = progress
      }
    }

    downloadRequestID = PHImageManager.default().requestImage(
      for: asset,
      targetSize: PHImageManagerMaximumSize,
      contentMode: .aspectFit,
      options: options
    ) { image, info in
      DispatchQueue.main.async {
        resetDownloadState()
        if let downloadedImage = image {
          onPhotoSelected(downloadedImage)
          dismiss()
        } else {
          let isCancelled = (info?[PHImageCancelledKey] as? NSNumber)?.boolValue ?? false
          if !isCancelled {
            errorService.show(message: "Failed to download RAW photo.")
          }
        }
      }
    }
  }

  private func cancelCurrentDownload() {
    if let requestID = downloadRequestID {
      print("Cancelling image request \(requestID)")
      PHImageManager.default().cancelImageRequest(requestID)
    }
    resetDownloadState()
  }

  private func cancelAndDismiss() {
    cancelCurrentDownload()
    dismiss()
  }

  private func resetDownloadState() {
    activeDownloadAssetID = nil
    downloadProgress = 0.0
    downloadRequestID = nil
  }
}

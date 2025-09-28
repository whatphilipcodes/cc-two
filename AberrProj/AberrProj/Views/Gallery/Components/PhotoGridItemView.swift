import Photos
import SwiftUI

struct PhotoGridItemView: View {
  let asset: PHAsset
  var onImageReady: (UIImage) -> Void
  @EnvironmentObject var errorService: ErrorHandlingService

  @State private var thumbnail: UIImage?
  @State private var downloadProgress: Double? = nil

  var body: some View {
    ZStack {
      Group {
        if let image = thumbnail {
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
        } else {
          Rectangle().fill(Color.gray.opacity(0.3))
        }
      }

      if let progress = downloadProgress {
        ZStack {
          Circle()
            .fill(.black.opacity(0.7))
          CircularProgressView(progress: progress)
            .frame(width: 40, height: 40)
        }
        .frame(width: 60, height: 60)
        .transition(.opacity.animation(.easeInOut))
      }
    }
    .aspectRatio(1, contentMode: .fill)
    .clipped()
    .onAppear(perform: loadThumbnail)
    .onTapGesture {
      guard downloadProgress == nil else { return }
      downloadProgress = 0.0
      startFullImageDownload()
    }
  }

  private func loadThumbnail() {
    let manager = PHImageManager.default()
    manager.requestImage(
      for: asset, targetSize: CGSize(width: 250, height: 250), contentMode: .aspectFill,
      options: nil
    ) { image, _ in
      self.thumbnail = image
    }
  }

  private func startFullImageDownload() {
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions()

    options.isNetworkAccessAllowed = true
    options.deliveryMode = .highQualityFormat
    options.resizeMode = .exact

    options.progressHandler = { progress, error, stop, info in
      DispatchQueue.main.async {
        self.downloadProgress = progress
      }
    }

    manager.requestImage(
      for: asset,
      targetSize: PHImageManagerMaximumSize,
      contentMode: .aspectFit,
      options: options
    ) { image, info in
      DispatchQueue.main.async {
        self.downloadProgress = nil
        if let downloadedImage = image {
          self.onImageReady(downloadedImage)
        } else {
          errorService.show(message: "Failed to download image from iCloud. Try again later.")
        }
      }
    }
  }
}

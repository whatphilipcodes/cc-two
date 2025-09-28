import Photos
import SwiftUI

struct PhotoGridItemView: View {
  let asset: PHAsset

  var isDownloading: Bool
  var progress: Double
  var isDisabled: Bool

  @State private var thumbnail: UIImage?

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

      if isDownloading {
        ZStack {
          Circle().fill(.black.opacity(0.7))
          CircularProgressView(progress: progress)
            .frame(width: 40, height: 40)
        }
        .frame(width: 60, height: 60)
      }
    }
    .aspectRatio(1, contentMode: .fill)
    .clipped()
    .onAppear(perform: loadThumbnail)
    .saturation(isDisabled ? 0 : 1)
    .opacity(isDisabled ? 0.5 : 1)
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
}

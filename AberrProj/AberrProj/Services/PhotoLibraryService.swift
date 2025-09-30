import Foundation
import Photos
import SwiftUI

class PhotoLibraryService: ObservableObject {
    @Published var rawAssets: [PHAsset] = []
    @EnvironmentObject var errorService: ErrorHandlingService

    func checkForPermissionAndFetch() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        if status == .authorized {
            fetchRawSmartAlbumAssets()
        } else {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                if newStatus == .authorized {
                    DispatchQueue.main.async {
                        self.fetchRawSmartAlbumAssets()
                    }
                }
            }
        }
    }
    
    @available(iOS 15.0, *)
    private func fetchRawSmartAlbumAssets() {
        let fetchResult = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .smartAlbumRAW,
            options: nil
        )
        
        guard let rawAlbum = fetchResult.firstObject else {
            errorService.show(message: "No RAW smart album found")
            DispatchQueue.main.async { self.rawAssets = [] }
            return
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assetsFetchResult = PHAsset.fetchAssets(in: rawAlbum, options: fetchOptions)
        
        var assets: [PHAsset] = []
        assetsFetchResult.enumerateObjects { (asset, _, _) in
            assets.append(asset)
        }
        
        DispatchQueue.main.async {
            self.rawAssets = assets
        }
    }
}

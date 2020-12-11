//
//  LoadImageAssetManager.swift
//  funi
//
import Foundation
import UIKit

struct LoadAssetResult {
    let asset: ImageAsset
    let image: UIImage
}

class LoadImageAssetManager {
    private let assetDownloadManager = AssetDownloadManager.shared
    private let fileManager = FileManager.default
    
    // MARK: - GalleryAlbum
    func loadAlbumThumbnailAsset(_ asset: ImageAsset, completionHandler: @escaping ((_ result: RequestResult<LoadAssetResult>) -> ())) {
        if fileManager.fileExists(atPath: asset.cachedLocalAssetURL().path) {
            locallyLoadAsset(asset, completionHandler: completionHandler)
        } else {
            remotelyLoadAsset(asset, forceDownload: false, completionHandler: completionHandler)
        }
    }
    
    // MARK: - GalleryItem
    func loadGalleryItemAsset(_ asset: ImageAsset, completionHandler: @escaping ((_ result: RequestResult<LoadAssetResult>) -> ())) {
        if fileManager.fileExists(atPath: asset.cachedLocalAssetURL().path) {
            locallyLoadAsset(asset, completionHandler: completionHandler)
        } else {
            remotelyLoadAsset(asset, forceDownload: true, completionHandler: completionHandler)
        }
    }
    
    func cancelLoadingGalleryItemAsset(_ asset: ImageAsset) {
        assetDownloadManager.cancelDownload(url: asset.url)
    }
    
    // MARK: - Asset
    private func locallyLoadAsset(_ asset: ImageAsset, completionHandler: @escaping ((_ result: RequestResult<LoadAssetResult>) -> ())) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: asset.cachedLocalAssetURL().path))
            
            guard let image = UIImage(data: data) else {
                completionHandler(.fail(APIError.invalidData))
                return
            }
            
            let loadResult = LoadAssetResult(asset: asset, image: image)
            let dataRequestResult = RequestResult<LoadAssetResult>.success(loadResult)
            
            DispatchQueue.main.async {
                completionHandler(dataRequestResult)
            }
        } catch {
            remotelyLoadAsset(asset, forceDownload: false, completionHandler: completionHandler)
        }
    }
    
    private func remotelyLoadAsset(_ asset: ImageAsset, forceDownload: Bool, completionHandler: @escaping ((_ result: RequestResult<LoadAssetResult>) -> ())) {
        
        assetDownloadManager.scheduleDownload(url: asset.url, forceDownload: forceDownload) { (result) in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completionHandler(.fail(APIError.invalidData))
                    return
                }
                
                do {
                    try data.write(to: asset.cachedLocalAssetURL(), options: .atomic)
                } catch {
                    completionHandler(.fail(APIError.invalidData))
                }
                
                let loadResult = LoadAssetResult(asset: asset, image: image)
                let dataRequestResult = RequestResult<LoadAssetResult>.success(loadResult)
                
                DispatchQueue.main.async {
                    completionHandler(dataRequestResult)
                }
            case .fail(let error):
                completionHandler(.fail(error))
            }
        }
    }
}

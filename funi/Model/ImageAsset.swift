//
//  ImageAsset.swift
//  funi
//
import Foundation

struct ImageAsset {
    let id: String
    let url: URL
    let titleAsset: String
    
    func cachedLocalAssetURL() -> URL {
        let cacheURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
        let fileName = url.deletingPathExtension().lastPathComponent
        return cacheURL.appendingPathComponent(fileName)
    }
}

extension ImageAsset: Equatable {
    static func ==(lhs: ImageAsset, rhs: ImageAsset) -> Bool {
        return lhs.id == rhs.id &&
            lhs.url == rhs.url && lhs.titleAsset == rhs.titleAsset
    }
}

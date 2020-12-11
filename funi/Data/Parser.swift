//
//  Parser.swift
//  funi
//
import Foundation

class Parser {
    
    func parseResponse(_ response: [String: Any]) -> [ImageAlbum] {
        var imageAlbums = [ImageAlbum]()
        
        guard let itemsResponse = response["data"] as? [[String: Any]] else {
            return imageAlbums
        }
        
        for itemResponse in itemsResponse {
            if let imageItems = parseItem(itemResponse) {
                if imageItems.count > 0 {
                    let imageItem = imageItems[0]
                    let imageThumbnailURL = generateThumbnailURL(from: imageItem)
                    
                    let thumbnailAsset = ImageAsset(id: fileName(forURL: imageThumbnailURL), url: imageThumbnailURL, titleAsset: imageItem.title)
                    
                    let imageAlbum = ImageAlbum(thumbnail: thumbnailAsset, items: imageItems)
                    imageAlbums.append(imageAlbum)
                }
            }
        }
        
        return imageAlbums
    }
    
    private func parseItem(_ itemResponse: [String: Any]) -> [ImageItem]? {
        guard let isAlbum = itemResponse["is_album"] as? Bool else {
            return nil
        }
        
        if isAlbum {
            return parseItemAlbum(itemResponse)
        } else {
            return parseItemImage(itemResponse)
        }
    }
    
    func parseItemImage(_ itemResponse: [String: Any]) -> [ImageItem]? {
        guard let itemTitle = itemResponse["title"] as? String,
            let imageURLString = itemResponse["link"] as? String,
            let imageURL = URL(string: imageURLString)
            else {
                return nil
        }
        
         let asset = ImageAsset(id: fileName(forURL: imageURL), url: imageURL, titleAsset: itemTitle)
        
        
        return [ImageItem(title: itemTitle, asset: asset)]
    }
    
    func parseItemAlbum(_ itemResponse: [String: Any]) -> [ImageItem]? {
        guard let itemTitle = itemResponse["title"] as? String,
            let imageResponses = itemResponse["images"] as? [[String: Any]]
            else {
                return nil
        }
        
        var imageItems = [ImageItem]()
        
        for imageResponse in imageResponses {
            if let linkURLString = imageResponse["link"] as? String {
                if let linkURL = URL(string: linkURLString) {
                    let title = itemTitle
                    
                    let asset = ImageAsset(id: fileName(forURL: linkURL), url: linkURL, titleAsset: title)
                    
                    let imageItem = ImageItem(title: title, asset: asset)
                    imageItems.append(imageItem) //TODO: DEVOLVER VACIO SI NO CONTIENEN .jpg o .png?
                    break
                }
            }
        }
        
        return imageItems
    }
    
    func generateThumbnailURL(from imageItem: ImageItem) -> URL {
        let pathExtension = imageItem.asset.url.pathExtension
        let linkWithoutPathExtension = imageItem.asset.url.deletingPathExtension()
        
        let thumbnailURLString = "\(linkWithoutPathExtension)t.\(pathExtension)"
        
        return URL(string: thumbnailURLString)!
    }
    
    func fileName(forURL url: URL) -> String {
        return url.deletingPathExtension().lastPathComponent
    }
}

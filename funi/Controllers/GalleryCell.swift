//
//  GalleryCell.swift
//  funi
//
import UIKit

class GalleryCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var thumbnail: ImageAsset?
    private var loadImageAsset = LoadImageAssetManager()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureWithImageData(_ imageObj: ImageAlbum) {
        imageView.contentMode = .scaleAspectFit
        titleLabel.text = "\(imageObj.thumbnail.titleAsset)"
        titleLabel.font = UIFont(name: "GillSans-Light", size: 14.0)
        print("JG URL: \(imageObj.thumbnail.url.absoluteString) TITLE: \(imageObj.thumbnail.titleAsset)")
        imageView.image = nil
        
        thumbnail = imageObj.thumbnail
        
        loadImageAsset.loadAlbumThumbnailAsset(imageObj.thumbnail) { [weak self] (result) in
            switch result {
            case .success(let loadResult):
                if loadResult.asset == self?.thumbnail {
                    self?.imageView.image = loadResult.image
                }
            case .fail(let error):
                //TODO: Handle
                print("JG GalleryCell error: \(error)")
            }
        }
    }
}

//
//  ImageDetailViewController.swift
//  funi
//
import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorDescription: UILabel!
    
    private var index = 0
    private let loadAssetDataManager =  LoadImageAssetManager()
    
    var galleryItems = [ImageItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorDescription.isHidden = true
        loadAsset()
        configureTitle()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            cancelAssertRetrieval()
        }
    }
    
    
    func configureTitle() {
        let galleryItem = galleryItems[index]
        let navigationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        navigationLabel.text = galleryItem.asset.titleAsset
        navigationLabel.textColor = UIColor.black
        navigationLabel.font = UIFont(name: "GillSans-SemiBold", size: 19.0)
        navigationLabel.backgroundColor = UIColor.clear
        navigationLabel.adjustsFontSizeToFitWidth = true
        navigationLabel.textAlignment = .center;
        navigationLabel.numberOfLines = 0
        navigationLabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = navigationLabel
    }
    
    func loadAsset() {
        let galleryItem = galleryItems[index]
        
        activityIndicator.startAnimating()
        imageView.image = nil
        loadAssetDataManager.loadGalleryItemAsset(galleryItem.asset) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            
            guard strongSelf.galleryItems.count > 0 else {
                return
            }
            
            switch result {
            case .success(let loadResult):
                DispatchQueue.main.async {
                    let currentGalleryItem = strongSelf.galleryItems[strongSelf.index]
                    if loadResult.asset == currentGalleryItem.asset {
                        strongSelf.activityIndicator.stopAnimating()
                        strongSelf.imageView.image = loadResult.image
                    }
                }
            case .fail(let error):
                print(error)
                DispatchQueue.main.async {
                    strongSelf.activityIndicator.stopAnimating()
                    if case APIError.invalidData = error {
                        strongSelf.errorDescription.text = "Cannot open the file"
                        strongSelf.errorDescription.isHidden = false
                    }
                }
            }
        }
    }
    
    func cancelAssertRetrieval() {
        let galleryItem = galleryItems[index]
        loadAssetDataManager.cancelLoadingGalleryItemAsset(galleryItem.asset)
    }
}

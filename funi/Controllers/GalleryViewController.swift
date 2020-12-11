//
//  GalleryViewController.swift
//  funi
//
import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var lottieNotFound: UIView!
    @IBOutlet weak var labelNotFound: UILabel!
    private var isFetchInProgress = false //Will avoid multiple requests
    private var currentPageNumber = 1
    private var searchFinished = false
    private let refreshControl = UIRefreshControl()
    let threshold:CGFloat = 11.0
    var searchText = ""
    let request = RequestManager()
    var images = [ImageAlbum]()
    var totalImagesCounter = 0
    
    // MARK: · View Controller ·
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = searchText
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        lottieNotFound.isHidden = true
        requestImages()
    }
    
    // MARK: · Segue ·
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("JG entró al prepare")
        guard let imageDetailVC = segue.destination as? ImageDetailViewController,
            let cell = sender as? GalleryCell,
            let indexPath = galleryCollectionView.indexPath(for: cell) else {
                return
        }
        imageDetailVC.galleryItems = images[indexPath.item].items
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.galleryCollectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    @objc func requestImages() {
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        activityIndicatorView.startAnimating()
        
        request.makeImageSearch(forTerm: searchText, pageNumber: currentPageNumber) { (result) in
            self.activityIndicatorView.stopAnimating()
            
            switch result {
            case .success(let galleryImages):
                self.isFetchInProgress = false
                
                //If array is empty we reached the last page
                if galleryImages.count > 0 {
                    self.currentPageNumber += 1
                    self.totalImagesCounter += galleryImages.count
                    self.images += galleryImages
                    self.galleryCollectionView.reloadData()
                } else {
                    //End of the search
                    print("JG la consulta regresó un arreglo vacío")
                    if self.totalImagesCounter == 0 {
                        print("JG el contador iba en 0 entonces no se encontraron resultados")
                        self.lottieNotFound.isHidden = false
                        self.lottieNotFound.addLottieImage(style: .error)
                    } else {
                        self.searchFinished = true
                        print("JG Fin de la búsqueda")
                    }
                }
            //JG TODO: Handle this case
            case .fail(let error):
                self.isFetchInProgress = false
                print("JG GalleryViewController error: \(error)")
            }
        }
    }
}


extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Note: Por consulta devuelve máximo 59 elementos (ya sea o no que especifiquemos el número de página).
        //
        // En la respuesta de 'Gallery search' no hay campo que indique la cantidad de elementos de la galería en sí que permita hacer un cálculo de la cantidad de páginas existentes.
        // No encontré ejemplo de salida JSON (1) donde se indique el total de páginas (mismo que me sirve para no hacer reloads constantes para actualizar el numberOfItemsInSection y en su lugar utilizar la API de Prefetching).
        //
        // Se sabe que se llega a la última página cuando el resultado arrojó un arreglo vacío
        //
        //
        //
        // 1. Se revisó en los endpoints de Imgur y los Data Models que retorna.
        
        return totalImagesCounter
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width : CGFloat!
        var height :CGFloat!
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            width = collectionView.frame.width/3
            height = collectionView.frame.height/2
        } else {
            width = collectionView.frame.width/2
            height = collectionView.frame.height/3
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellID", for: indexPath) as? GalleryCell else {
            return UICollectionViewCell()
        }
        
        let imageData = images[indexPath.row]
        cell.configureWithImageData(imageData)
        
        return cell
    }
    
    
    
    
}

extension GalleryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !searchFinished else {
            return
        }
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;

        if !isFetchInProgress && (maximumOffset - contentOffset <= threshold) {
            requestImages()
        }
    }
}


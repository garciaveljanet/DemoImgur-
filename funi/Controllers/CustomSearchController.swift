//
//  CustomSearchController.swift
//  funi
//
import UIKit

// MARK: · Delegates ·
protocol CustomSearchControllerDelegate {
    func didStartSearching()
    func didSearchText(searchText: String)
    func didTapOnCancelButton()
}

class CustomSearchController: UISearchController {
    
    var customSearchBar: CustomSearchBar!
    var customDelegate: CustomSearchControllerDelegate!
    var textFromSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: · Initializing ·
    init(searchResultsController: UIViewController!, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor, glassColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        
        configureSearchBar(frame: searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, bgColor: searchBarTintColor, glassColor: glassColor)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: · Configuration ·
    func configureSearchBar(frame: CGRect, font: UIFont, textColor: UIColor, bgColor: UIColor, glassColor: UIColor) {
        customSearchBar = CustomSearchBar(frame: frame, font: font , textColor: textColor, glassColor: glassColor)
        
        customSearchBar.barTintColor = bgColor
        customSearchBar.tintColor = textColor
        customSearchBar.showsCancelButton = false
        
        customSearchBar.delegate = self
    }
    
}


// MARK: · UISearchBarDelegate functions
extension CustomSearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.resignFirstResponder()
        customDelegate.didSearchText(searchText: textFromSearch)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //If there's at least a letter then make the search
        if searchText.count > 0 {
            textFromSearch = searchText
        } else {
            customDelegate.didTapOnCancelButton()
        }
    }
}




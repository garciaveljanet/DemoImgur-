//
//  SearchViewController.swift
//  funi
//
import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lottieView: UIView!
    
    private var updateGUITimer: Timer?
    private var wordsArray = ["fun","entertainment","laughs","wait what?","LOLs","cute pics","new memes","ideas","awesome backgrounds"]
    private var colorsArray = [UIColor.papayaColor, UIColor.mustardColor, UIColor.aquaColor, UIColor.blushColor]
    private var lottiesArray:[LottieStyle] = [.laugh, .apple, .dog, .game, .mountain]
    private var randomWordPosition = 0
    private var randomLottiePosition = 0
    var dataArray = [String]()
    var customSearchController: CustomSearchController!
    var textSearched = ""
    
    // MARK: · View Controller Cycle ·
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordsArray.shuffle()
        lottiesArray.shuffle()
        randomWordPosition = Int(arc4random_uniform(UInt32(wordsArray.count)))
        randomLottiePosition = Int(arc4random_uniform(UInt32(lottiesArray.count)))
        
        configureTextLabel()
        configureCustomSearchController()
        configureLottieView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activateGUITimer()
        
        configureLottieView()
        lottieView.playWithLoop()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidateGUITimer()
        
        lottieView.stopLottieComponent()
    }
    
    // MARK: · App cycle ·
    @objc func willEnterForeground() {
//        print("will enter foreground")
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        configureLottieView()
        lottieView.playWithLoop()
    }
    
    
    @objc func willEnterBackground() {
//        print("will enter background")
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        lottieView.stopLottieComponent()
    }
    
    // MARK: · Overrides ·
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("JG sender \(String(describing: sender))")
        
        guard let galleryVC = segue.destination as? GalleryViewController else {
            return
        }
        
        galleryVC.searchText = textSearched
    }
    
    // MARK: Custom functions
    @objc func configureTextLabel() {
        randomWordPosition += 1
        if randomWordPosition == wordsArray.count {
            randomWordPosition = 0
        }
        let randomWord = wordsArray[randomWordPosition]
        let randomColor:UIColor = colorsArray.randomElement() ?? UIColor.white
        let helloText = NSAttributedString(string:
            """
            Hello there!
            
            Get
            """,
                                           attributes: [NSAttributedString.Key.font: UIFont.init(name: "GillSans-BoldItalic", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0), NSAttributedString.Key.foregroundColor: UIColor.white])
        let word = NSAttributedString(string:
            " \(randomWord) ",
            attributes: [NSAttributedString.Key.font: UIFont.init(name: "GillSans-BoldItalic", size: 30.0) ?? UIFont.systemFont(ofSize: 30.0), NSAttributedString.Key.foregroundColor: randomColor])
        let endingText = NSAttributedString(string:
            """

            searching images
            """,
                                            attributes: [NSAttributedString.Key.font: UIFont.init(name: "GillSans-BoldItalic", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0), NSAttributedString.Key.foregroundColor: UIColor.white])
        let completeText = NSMutableAttributedString(attributedString: helloText)
        completeText.append(word)
        completeText.append(endingText)
        descriptionLabel.attributedText = completeText
    }
    
    func configureCustomSearchController() {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height:50.0), searchBarFont: UIFont(name: "GillSans-Italic", size: 16.0)!, searchBarTextColor: UIColor.aquaColor, searchBarTintColor: UIColor.orange, glassColor: UIColor.glassColor)
        customSearchController.customSearchBar.placeholder = "Search"
        customSearchController.searchBar.sizeToFit()
        navigationItem.titleView = customSearchController.customSearchBar
        navigationController?.navigationBar.backgroundColor = UIColor.navigationBarBackgroundColor
        customSearchController.hidesNavigationBarDuringPresentation = false
        customSearchController.customDelegate = self
    }
    
    func configureLottieView() {
        randomLottiePosition += 1
        if randomLottiePosition == lottiesArray.count {
            randomLottiePosition = 0
        }
        lottieView.addLottieImage(style: lottiesArray[randomLottiePosition])
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
//        print("JG handletap")
        customSearchController.customSearchBar.endEditing(true)
        customSearchController.customSearchBar.text = ""
    }
    
    // MARK: · Timers ·
    func activateGUITimer() {
        if updateGUITimer == nil {
            updateGUITimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.9), target: self, selector: (#selector(self.configureTextLabel)), userInfo: nil, repeats: true)
        }
    }
    func invalidateGUITimer() {
        if updateGUITimer != nil {
            updateGUITimer?.invalidate()
            updateGUITimer = nil
        }
    }
    
}

extension SearchViewController: CustomSearchControllerDelegate {
    // MARK: CustomSearchControllerDelegate functions
    func didStartSearching() {
        showSearchResults(true)
    }
    
    func didTapOnCancelButton() {
        showSearchResults(false)
    }
    
    func didSearchText(searchText: String) {
        textSearched = searchText
        showSearchResults(true)
    }
    
    func showSearchResults(_ show: Bool) {
        customSearchController.customSearchBar.text = ""
        if show {
            self.performSegue(withIdentifier: "showGallery", sender: nil)
        } else {
            customSearchController.customSearchBar.resignFirstResponder()
            customSearchController.customSearchBar.endEditing(true)
        }
    }
}

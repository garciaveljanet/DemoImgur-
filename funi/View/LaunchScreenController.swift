//
//  LaunchScreenController.swift
//  funi
//
import UIKit
import Lottie
import Foundation

class LaunchScreenController: UIViewController {
    
    @IBOutlet weak var subView: UIView!
    //    private var subview = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subView.addLottieImage(style: .logo)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+4.4) {
            self.sendToMainController()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        subView.layoutIfNeeded()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendToMainController(){
        let NavController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "rootNavigationController")
        if UIApplication.shared.windows.count > 1 {
            UIApplication.shared.windows[0].rootViewController = NavController
        }else{
            UIApplication.shared.keyWindow?.rootViewController = NavController
        }
    }
    
}

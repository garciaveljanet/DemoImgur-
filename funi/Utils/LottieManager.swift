//
//  LottieManager.swift
//  funi
//

import UIKit
import Lottie

class LottieManager: NSObject {
    
}

enum LottieStyle:Int{
    case logo = 0
    case laugh
    case apple
    case dog
    case game
    case mountain
    case error
}


extension UIView{
    func addLottieImage(style:LottieStyle){
        for view in self .subviews{
            if let lottieview = view as? LOTAnimationView{
                lottieview.removeFromSuperview()
            }
        }

        var lottieView = LOTAnimationView()
        switch style {
        case .logo:
            lottieView = LOTAnimationView(name: "logo")
            break
        case .laugh:
            lottieView = LOTAnimationView(name: "laugh")
            break
        case .apple:
            lottieView = LOTAnimationView(name: "apple")
            break
        case .dog:
            lottieView = LOTAnimationView(name: "dog")
            break
        case .game:
            lottieView = LOTAnimationView(name: "game")
            break
        case .mountain:
            lottieView = LOTAnimationView(name: "mountain")
            break
        case .error:
            lottieView = LOTAnimationView(name: "error")
            break
        }
        lottieView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        lottieView.contentMode = UIView.ContentMode.scaleAspectFit
        lottieView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        self.addSubview(lottieView)
        self.backgroundColor = UIColor.clear
        lottieView.play()
    }
    
    func playWithLoop(){
        for view in self.subviews {
            if let lottieview = view as? LOTAnimationView{
                lottieview.loopAnimation = true
                lottieview.play()
            }
        }
    }
    
    func stopLottieComponent(){
        for view in self.subviews {
            if let lottieview = view as? LOTAnimationView{
                lottieview.stop()
            }
        }
    }
    
}



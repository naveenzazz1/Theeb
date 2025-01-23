//
//  SplashVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 16/10/1443 AH.
//
import UIKit
import Lottie
import AppsFlyerLib
class SplashVC: BaseViewController {


    var viewModel : SplashViewModel = .init()

    // MARK: - Outlets
        
    @IBOutlet weak var lottieAnimationView: LottieAnimationView! {
        didSet {
            lottieAnimationView.animation = LottieAnimation.named("Splashanimation")
          //  lottieAnimationView.backgroundBehavior = .pauseAndRestore
        }
    }

    
    // MARK: - Initialization
    
    class func initializeFromStoryboard() -> SplashVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.Login, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: SplashVC.self)) as! SplashVC
    }
    

    
    
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     //   viewModel.getToken()
        
        lottieAnimationView.play { [weak self] (finished) in
            
            let rootVC = LandingPageVC.initializeWithNavigationController()
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = rootVC
            if Language.currentLanguage == .arabic {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            } else {

                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
            
        }
    }
}

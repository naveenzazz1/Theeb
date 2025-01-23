//
//  EnableBiometricVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 18/09/1443 AH.
//

import UIKit
import LocalAuthentication
import SwiftUI

class EnableBiometricVC: UIViewController {
   
    
    // MARK: - Outlets
 
    @IBOutlet weak var skipBtn: UIButton! {
        didSet {
            skipBtn.setTitle("faceid_skip_btn".localized, for: .normal)
        }
    }
   
    @IBOutlet weak var enableBtn: UIButton! {
        didSet {
            enableBtn.setTitle( "faceid_enble_btn".localized, for: .normal)
            enableBtn.setTitleColor(.white, for: .normal)
        }
    }
    @IBOutlet weak var enableVerificationHint: UILabel! {
        didSet {
            enableVerificationHint.text  = "faceid_skip_hint".localized
        }
    }
    @IBOutlet weak var enableVerificationTitle: UILabel! {
        didSet {
            enableVerificationTitle.text = "faceid_skip_title".localized
        }
    }
   
    
    // MARK: - Variables
    
     let biometricIDAuth = BiometricIDAuth()

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsManager.logScreenView(screenName: String(describing: AnalyticsKeys.BiometricLogin), screenClass: String(describing: EnableBiometricVC.self))
        AppsFlyerManager.logScreenView(screenName: String(describing: AnalyticsKeys.BiometricLogin), screenClass: String(describing: EnableBiometricVC.self))
    }
    
    
    // MARK: -Intialization
    
    class func initializeFromStoryboard() -> EnableBiometricVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.Login, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: EnableBiometricVC.self)) as! EnableBiometricVC
    }
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: EnableBiometricVC.initializeFromStoryboard())
    }
    
   
    
    // MARK: - Actions
    
    @IBAction func enableBtnAction(_ sender: Any) {

        handleTouchID()
    
    }
    

    @IBAction func skipBtnAction(_ sender: Any) {
   
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  LandingPageVC.initializeWithNavigationController()
    
        
    }
    
    func handleTouchID() {
        
        biometricIDAuth.canEvaluate { (canEvaluate, _, canEvaluateError) in
            guard canEvaluate else {
                alert(title: "Error",
                      message: canEvaluateError?.localizedDescription ?? "Face ID/Touch ID may not be configured",
                      okActionTitle: "Ok!")
                return
            }
            
            biometricIDAuth.evaluate { [weak self] (success, error) in
                guard success else {
                    self?.alert(title: "Error",
                                message: error?.localizedDescription ?? "Face ID/Touch ID may not be configured",
                                okActionTitle: "Ok!")
                    return
                }
                
                CachingManager.isFaceIdEnabled = true
                CachingManager.isFirstLogin = false
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  LandingPageVC.initializeWithNavigationController()
                
            }
        }
    }
    
    
    func alert(title: String, message: String, okActionTitle: String) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
}

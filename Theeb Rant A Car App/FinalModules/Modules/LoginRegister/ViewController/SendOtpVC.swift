//
//  SendOtpVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 05/06/1443 AH.
//

import UIKit

class SendotpVC : UIViewController {
    
    // MARK: -Outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setTitle("forget_password_next_button_title".localized, for: .normal)
        }
    }
    @IBOutlet weak var hintLabel: UILabel! {
        didSet {
            hintLabel.text = "forget_password_title_label".localized
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.placeholder = "forget_password_otp_place_holder".localized
            emailTextField.setLeftPaddingPoints(35.0)
            emailTextField.setRightPaddingPoints(35.0)
        }
    }
    
  
    // MARK: -View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        bindSendOtp()
    }
    
   lazy  var viewModel = LoginViewModel()
    
    // MARK: - Initialization
    
    class func initializeFromStoryboard() -> SendotpVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.CreatePassword, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: SendotpVC.self)) as! SendotpVC
    }
    
    
    // MARK: - Setup ViewModel

    func setupViewModel() {
        
        viewModel.presentViewController = { [unowned self] (vc) in
            
            self.present(vc, animated: true, completion: nil)
        }
        
        viewModel.dismissViewController = { [weak self] in
            
            self?.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func bindSendOtp(){
        viewModel.otpSent.listen(on: { [weak self] value in
            
            print(value)
            self?.viewModel.navigateToResetPassword(self?.emailTextField.text)
        })
    }
    
    
    // MARK: -Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextBtnAction(_ sender: Any) {
   
        if emailTextField.text != "" && ((emailTextField.text?.isValidEmail() ?? false) ) {
           // viewModel.sendOtp(emailTextField.text)
            viewModel.sendOtp2(emailTextField.text, Mode: "S")
        }
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsManager.logScreenView(screenName: String(describing: AnalyticsKeys.Opt), screenClass: String(describing: SendotpVC.self))
        
        AppsFlyerManager.logScreenView(screenName: String(describing: AnalyticsKeys.Opt), screenClass: String(describing: SendotpVC.self))
    }
    
}

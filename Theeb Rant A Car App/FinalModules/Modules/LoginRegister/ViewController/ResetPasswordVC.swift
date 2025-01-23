//
//  ResetPasswordVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 05/06/1443 AH.
//

import UIKit

class ResetpasswordVC : UIViewController {
    
    
    // MARK: -Outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resetPassword: UIButton!
    @IBOutlet weak var hintLabel: UILabel! {
        didSet {
            hintLabel.text =  "forget_password_title_label".localized
        }
    }
    
    @IBOutlet weak var otpCodeTextField: UITextField! {
        didSet {
            otpCodeTextField.placeholder = "create_password_enter_otp_placeholder".localized
            otpCodeTextField.setLeftPaddingPoints(35.0)
            otpCodeTextField.setRightPaddingPoints(35.0)
        }
    }
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
            passwordTextField.placeholder =  "login_invalid_input_password".localized
            passwordTextField.setLeftPaddingPoints(35.0)
            passwordTextField.setRightPaddingPoints(35.0)
        }
    }
    
    // MARK: -Variabels
    var email : String?
    lazy var viewModel = LoginViewModel()
    var isFromUSerProfile = false
    
    
    // MARK: -View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetPassword.setTitle("password_reset".localized, for: .normal)
        setupViewModel()
        bindSendOtp()
        if isFromUSerProfile{
          //  viewModel.sendOtp(email)
            viewModel.sendOtp2(email, Mode: "S")
        }
    }
    
    func bindSendOtp(){
        viewModel.otpSent.listen(on: { [weak self] value in
            
            print(value)
            self?.viewModel.navigateToResetPassword(self?.email)
        })
    }
    
    
    // MARK: - Setup ViewModel
    
    func setupViewModel() {
        
        viewModel.dismissViewController = { [weak self] in
            let presentingViewController = self?.presentingViewController
            self?.dismiss(animated: false, completion: {
                presentingViewController?.dismiss(animated: true, completion: {})
            })
        }
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        GoogleAnalyticsManager.logScreenView(screenName: String(describing: AnalyticsKeys.ResetPassword), screenClass: String(describing: ResetpasswordVC.self))
        
        AppsFlyerManager.logScreenView(screenName: String(describing: AnalyticsKeys.ResetPassword), screenClass: String(describing: ResetpasswordVC.self))
    }
    
    
    // MARK: - Initialization
    
    
    class func initializeFromStoryboard() -> ResetpasswordVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.CreatePassword, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: ResetpasswordVC.self)) as! ResetpasswordVC
    }
    
    
    // MARK: -Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func showPasswordAction(_ sender: Any) {
        
        showPassword.isSelected = passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        
    }
    
    @IBAction func restPassowrdButtonAction(_ sender: Any) {
       // viewModel.finalizeResetPassword(email ?? "", otpCodeTextField.text ?? "", newPassword: passwordTextField.text ?? "")
        viewModel.finalizeResetPassword2(email ?? "", otpCodeTextField.text ?? "", newPassword: passwordTextField.text ?? "")
    }
    
}


extension ResetpasswordVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField {
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            textField.text = updatedString;

        }
  
        return false
    }
}

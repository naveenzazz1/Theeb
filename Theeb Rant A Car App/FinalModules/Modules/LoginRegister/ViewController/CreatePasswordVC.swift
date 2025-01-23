//
//  CreatePasswordVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 01/05/1443 AH.
//

import UIKit


class CreatePasswordVC : UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel! {
        didSet {
            
            hintLabel.text = "create_password_hint_label".localized
        }
    }
    
    @IBOutlet weak var showPasswordHintButton: UIButton!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField! {
        didSet {
            confirmPasswordTextField.setLeftPaddingPoints(35.0)
            confirmPasswordTextField.setRightPaddingPoints(35.0)
            confirmPasswordTextField.placeholder = "create_password_text_field_place_holder".localized
        }
    }
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.setTitle("create_password_submit_button_title".localized, for: .normal)
        }
    }
    @IBOutlet weak var verificationCodeTextField: UITextField! {
        didSet {
            verificationCodeTextField.setLeftPaddingPoints(35.0)
            verificationCodeTextField.setRightPaddingPoints(35.0)
            verificationCodeTextField.placeholder = "create_password_enter_otp_placeholder".localized
        }
    }
    
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.setLeftPaddingPoints(35.0)
            passwordTextField.placeholder = "login_password_place_holder".localized
        }
    }
    
    // MARK: - Variabels
    
    lazy var viewModel = CreatePasswordViewModel()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GoogleAnalyticsManager.logScreenView(screenName: String(describing: CreatePasswordVC.self), screenClass: String(describing: CreatePasswordVC.self))
        
        AppsFlyerManager.logScreenView(screenName: String(describing: CreatePasswordVC.self), screenClass: String(describing: CreatePasswordVC.self))
    }
    
    // MARK: - Data Passing
    
    func setRegistrationModel(email: String?  , fullName: String? = nil, idNumber: String? = nil , phoneNumber: String? = nil) {
        
        viewModel.email  = email
        viewModel.fullName = fullName
        viewModel.idNumber = idNumber
        viewModel.phoneNumber = phoneNumber
        
    }
    
    // MARK: -Intialization
    
    class func initializeFromStoryboard() -> CreatePasswordVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.CreatePassword, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: CreatePasswordVC.self)) as! CreatePasswordVC
    }
    
  
    
    
    // MARK: - Setup ViewModel
    
    func setupViewModel() {
        
        viewModel.dismissViewController = { [weak self] in
            AppsFlyerManager.logPrimaryEvent(eventName: "af_SignUp")
            let presentingViewController = self?.presentingViewController
            self?.dismiss(animated: false, completion: {
                presentingViewController?.dismiss(animated: true, completion: {})
            })
        }
    }
    
    //MARK: -Actions
  
    @IBAction func backButtonAction(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showPasswordButtonAction(_ sender: Any) {
        
        showPasswordButton.isSelected = passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    
    @IBAction func showPasswordForConfirmAction(_ sender: Any) {
    
        showPasswordHintButton.isSelected = confirmPasswordTextField.isSecureTextEntry
        confirmPasswordTextField.isSecureTextEntry = !confirmPasswordTextField.isSecureTextEntry
    
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        if passwordTextField.text == confirmPasswordTextField.text {
           // viewModel.finalizeRegistation2(viewModel.email ?? "", temp: verificationCodeTextField.text ?? "", newPassword: confirmPasswordTextField.text ?? "")
            viewModel.finalizeRegistation2(viewModel.email ?? "", verificationCodeTextField.text ?? "", newPassword: confirmPasswordTextField.text ?? "")
        } else {
            CustomLoader.customLoaderObj.stopAnimating()
            CustomAlertController.initialization().showAlertWithOkButton(message: "create_password_text_field_password_not_match_error".localized) { (index, title) in
                 print(index,title)
            }
            
        }
        

        
        
    }
    
    
    
}

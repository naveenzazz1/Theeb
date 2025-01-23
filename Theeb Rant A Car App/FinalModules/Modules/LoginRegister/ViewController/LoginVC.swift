//
//  LoginVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 26/04/1443 AH.
//

import UIKit

class LoginVC : UIViewController {
    
    // MARK: -Outlets
    
    
    
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton! {
        didSet {
            forgetPasswordButton.setTitle("login_forgetpassword_button_title".localized, for: .normal)
        }
    }
    @IBOutlet weak var loginWithAbsherHintLabel: UILabel! {
        didSet {
            loginWithAbsherHintLabel.text =  "login_with_absher_hint_label".localized
        }
    }
    @IBOutlet weak var loginWithAbsher: LoadingButton! {
        didSet {
            loginWithAbsher.createNafazBtn()
        }
    }
    @IBOutlet weak var loginButton: LoadingButton! {
        didSet {
            loginButton.setTitle("login_button_title".localized, for: .normal)
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            
            
            //passwordTextField.setLeftPaddingPoints(35.0)
            //passwordTextField.clearsOnBeginEditing = false
            
            
            passwordTextField.delegate = self
            passwordTextField.placeholder = "login_password_place_holder".localized
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            //  emailTextField.setLeftPaddingPoints(35.0)
            emailTextField.placeholder  = "login_email_place_holder".localized
            
        }
    }
    
    // MARK: -View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViewModel()
        bindUserData()
        
        //        if CachingManager.isFaceIdEnabled ?? false {
        //            handleTouchID()
        //        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginWithAbsher.createNafazBtn()
        
        if  CachingManager.isFaceIdEnabled ?? false && CachingManager.storedPassword != nil && CachingManager.storedPassword != ""{
            handleTouchID()
        }
       
    }
    
   
    // MARK: -Variabels
    
    let  viewModel = LoginViewModel()
    
    // MARK: -Intialization
    
    class func initializeFromStoryboard() -> LoginVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.Login, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: LoginVC.self)) as! LoginVC
    }
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: LoginVC.initializeFromStoryboard())
    }
    

    
    // MARK: -Setup ViewModel
    
    func setupViewModel() {
        
        viewModel.presentViewController = { [unowned self] (vc) in
            
            self.present(vc, animated: true, completion: nil)
        }
        
        viewModel.pushViewController = { [unowned self] (vc) in
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        viewModel.showLoading = {  [unowned self] in
            
            self.loginButton.showLoading()
            
        }
        
        viewModel.hideLoadding = {  [unowned self] in
            
            self.loginButton.hideLoading()
        }
        viewModel.hideLoaddingForIam = { [unowned self] in
            
            self.loginWithAbsher.hideLoading()
            
        }
        
        viewModel.dismissTillCarDetails = {  [unowned self] in
        
                guard let vc = self.presentingViewController else { return }
                while (vc.presentingViewController != nil) {
                    vc.dismiss(animated: true, completion: nil)
                }
        }
        
    }
    
    
    
    func loginWithNafaz() {
        //        let dateOfBirth = DateUtils.changeDateFormatFromStringUser(stringDate: userRegisterationObject.dateOfBirth, formatInput: "YYYYMMDD" , formatOutPut: "dd/MM/yyyy")
        //
        //        let licenseExpiryOfBirth = DateUtils.changeDateFormatFromStringUser(stringDate: userRegisterationObject.licenseExpiryDate, formatInput: "YYYYMMDD" , formatOutPut: "dd/MM/yyyy")
        
    }
    
    // MARK: -helper Methods
    
    func isValidInputData() ->  Bool? {
        
        var valid: Bool? = true
        if emailTextField.text == nil || emailTextField.text == "" || !(emailTextField.text?.isValidEmail() ?? false)   {
            CustomAlertController.initialization().showAlertWithOkButton(message: "login_invalid_input_email".localized) { (index, title) in
                print(index,title)
            }
            self.view.endEditing(true)
            valid = false
            
            
        } else if passwordTextField.text == nil || passwordTextField.text == "" {
            
            CustomAlertController.initialization().showAlertWithOkButton(message: "login_invalid_input_password".localized) { (index, title) in
                print(index,title)
            }
            self.view.endEditing(true)
            valid = false
        }
        
        return valid
    }
    
    func setisGuest(_ isGuest: Bool?) {
        
        viewModel.isGuest = isGuest
    }
    
    
    func bindUserData(){
        viewModel.userData.listen(on: { [weak self] value in
            if let result = value {
                if (result.UserLogOut?.success ?? "False") == "False" {
                    CustomAlertController.initialization().showAlertWithOkButton(message: result.UserLogOut?.varianceReason ?? "") { (index, title) in
                    }
                } else {
                  //  CachingManager.store(value: result.UserLogOut?.email!, forKey: CachingKeys.email)
                   // CachingManager.storedPassword = result.UserLogOut?.password
                    // CachingManager.setLoginObject(result.UserLogOut)
                    
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        GoogleAnalyticsManager.logScreenView(screenName: String(describing: AnalyticsKeys.Login), screenClass: String(describing: LoginVC.self))
        AppsFlyerManager.logScreenView(screenName: String(describing: AnalyticsKeys.Login), screenClass: String(describing: LoginVC.self))
    }
    
    // MARK: -Actions
    
    @IBAction func loginWithAbsherAction(_ sender: Any) {
      
        loginWithAbsher.showLoading()
        viewModel.fetchIamServiceUrl()
        
    }
    
    @IBAction func forgetPasswordAction(_ sender: Any) {
        
        viewModel.navigateToForgetPassword()
        
    }
    
    @IBAction func normalLoginAction(_ sender: Any) {
        
        
        if (isValidInputData() ?? false ) {
            
           // viewModel.login(emailTextField.text ?? "", password: passwordTextField.text ?? "")
            viewModel.login2(emailTextField.text ?? "", password: passwordTextField.text ?? "")
        }
        
        
    }
    
    @IBAction func showPasswordButtonAction(_ sender: Any) {
        
        showPasswordButton.isSelected = passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
}
//
//extension LoginVC: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("====== Range \(range)")
//        print("====== string \(string)")
//        print("====== textfield \(textField.text)")
//        
//        if string.isEmpty && textField.text?.count == range.location {
//            return false
//        }
//        if textField == passwordTextField {
//            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
//            textField.text = updatedString;
//        }
//        return true
//    }
//}

extension LoginVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField {
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            textField.text = updatedString;

        }
  
        return false
    }
}

extension LoginVC {
    func handleTouchID() {
        let biometricIDAuth = BiometricIDAuth()
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
                
                print("should call login")
                
                self?.viewModel.login2(CachingManager.email(), password: CachingManager.storedPassword)
                
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

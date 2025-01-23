//
//  RegisterVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 26/04/1443 AH.
//

import Foundation
import UIKit
import FlagPhoneNumber
import JVFloatLabeledTextField

enum UserIDType {
    case saudiID
    case passport
}

class RegisterVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var containerStackvIEW: UIStackView!
    @IBOutlet weak var UserIDTypeStack: UIStackView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var passportView: UIView!
    @IBOutlet weak var passportLabel: UILabel!
    //@IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullNameView: UIView!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var birthDateView: UIView!
    @IBOutlet weak var mobileArrowImage: UIImageView!
    @IBOutlet weak var mobileFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var forgetPasswordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = "login_password_place_holder".localized
        }
    }
    @IBOutlet weak var loginWithAbsherHintLabel: UILabel! {
        didSet {
            loginWithAbsherHintLabel.text = "".localized
        }
    }
    @IBOutlet weak var loginWithAbsherButton: LoadingButton! {
        didSet {
            loginWithAbsherButton.createNafazBtn()
        }
    }
    @IBOutlet weak var signUpButton: LoadingButton! {
        didSet {
            signUpButton.setTitle("sign_up_button_title".localized, for: .normal)
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.textAlignment = UIApplication.isRTL() ? .right : .left
            emailTextField.placeholder = "login_email_place_holder".localized
        }
    }
    @IBOutlet weak var mobileTextField: FPNTextField! {
        didSet {
            mobileTextField.delegate = self
            mobileTextField.displayMode = .list
            mobileTextField.flagButtonSize = CGSize(width: 40, height: 40)
            mobileTextField.setFlag(countryCode: FPNCountryCode.SA)
            mobileTextField.keyboardType = .asciiCapableNumberPad
            mobileTextField.hasPhoneNumberExample = false
            mobileTextField.placeholder = "sign_up_phone_number_placeholder".localized
            mobileTextField.leftView?.semanticContentAttribute = .forceLeftToRight
            mobileTextField.semanticContentAttribute = UIApplication.isRTL() ? .forceRightToLeft : .forceLeftToRight
        }
    }
    @IBOutlet weak var fullNameTextField: UITextField! {
        didSet {
            fullNameTextField.placeholder = "sign_up_full_name_placeholder".localized
        }
    }
    @IBOutlet weak var idorIqamaTextField: UITextField! {
        didSet {
            idorIqamaTextField.delegate = self
            idorIqamaTextField.placeholder = "ID Number/ Iqama".localized
        }
    }
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var birthDateTextField: JVFloatLabeledTextField! {
        didSet {
            birthDateTextField.isEnabled = true
        }
    }
    
    @IBAction func selectPassport(_ sender: Any) {
        idView.backgroundColor = UIColor.clear
        passportView.backgroundColor = UIColor.theebColor
        
        idLabel.textColor = UIColor.systemGray
        passportLabel.textColor = UIColor.white
        mobileArrowImage.isHidden = false
        mobileFieldLeadingConstraint.constant = 10
        fullNameView.isHidden = false
        mobileNumberView.isHidden = false
        emailView.isHidden = false
        birthDateView.isHidden = true
      //  mainViewHeightConstraint.constant = 570
        selectedUserIDType = .passport
        idorIqamaTextField.placeholder = "Passport".localized
        idorIqamaTextField.text = ""
        fullNameTextField.text = ""
        mobileTextField.text = ""
        emailTextField.text = ""
        mobileTextField.displayMode = .picker
    }
    @IBAction func selectID(_ sender: Any) {
        idView.backgroundColor = UIColor.theebColor
        passportView.backgroundColor = UIColor.clear
        
        idLabel.textColor = UIColor.white
        passportLabel.textColor = UIColor.systemGray
        mobileArrowImage.isHidden = true
        mobileFieldLeadingConstraint.constant = 0
        fullNameView.isHidden = true
        mobileNumberView.isHidden = false
        emailView.isHidden = false
        birthDateView.isHidden = false
      //  mainViewHeightConstraint.constant = 620
        selectedUserIDType = .saudiID
        idorIqamaTextField.placeholder = "ID Number/ Iqama".localized
        idorIqamaTextField.text = ""
        fullNameTextField.text = ""
        mobileTextField.text = ""
        emailTextField.text = ""
        mobileTextField.displayMode = .list
        mobileTextField.setFlag(countryCode: FPNCountryCode.SA)
        mobileTextField.resignFirstResponder()
        
    }
    
    // MARK: - Variables
    lazy var viewModel = RegistrationViewModel()
    lazy var loginViewModel = LoginViewModel()
    lazy var createPasswordViewModel = CreatePasswordViewModel()
    var birthdayString = ""
    var birthdayDate: Date?
    var trimmedString = ""
    var selectedUserIDType: UserIDType = .saudiID
    var userEmail = ""
    var userPhone = ""
    var userFullName = ""
    private var keyboardManager: KeyboardManager?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthDateTextField.setInputViewDatePicker(target: self, selector: #selector(datePickerChanged))
        setupViewModel()
        setupUI()
        viewModel.setDefaultCountryCode()
        bindCreateAccount()
        bindSendOtp()
        bindYaqeenValidation()
        
        keyboardManager = KeyboardManager(viewController: self, bindedView: scrolView)
    }
    
    // MARK: - Setup UI
    func setupUI() {
        UserIDTypeStack.layer.cornerRadius = 12
        UserIDTypeStack.layer.borderColor = UIColor.systemGray.cgColor
        UserIDTypeStack.layer.borderWidth = 1
        UserIDTypeStack.clipsToBounds = true
        idView.backgroundColor = UIColor.theebColor
        passportView.backgroundColor = UIColor.clear
        idLabel.textColor = UIColor.white
        passportLabel.textColor = UIColor.systemGray
        mobileArrowImage.isHidden = true
        mobileFieldLeadingConstraint.constant = 0
        fullNameView.isHidden = true
        mobileNumberView.isHidden = false
        emailView.isHidden = false
        birthDateView.isHidden = false
      //  mainViewHeightConstraint.constant = 620
        selectedUserIDType = .saudiID
        idorIqamaTextField.placeholder = "ID Number/ Iqama".localized
        idorIqamaTextField.text = ""
        mobileTextField.displayMode = .list
        mobileTextField.setFlag(countryCode: FPNCountryCode.SA)
    }
    
    // MARK: - Date Picker
    @objc func datePickerChanged() {
        if let datePicker = birthDateTextField.inputView as? UIDatePicker {
            let calendar = Calendar.current
            let eighteenYearsAgo = calendar.date(byAdding: .year, value: 0, to: Date())
            datePicker.maximumDate = eighteenYearsAgo
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            birthdayString = dateFormatter.string(from: datePicker.date)
            birthdayDate =  datePicker.date
            birthDateTextField.text = DateUtils.formatArabicDate(date: datePicker.date)//birthdayString
        }
        birthDateTextField.resignFirstResponder()
    }
    
    // MARK: - Binding ViewModel
    func bindCreateAccount() {
        viewModel.createAccount.listen(on: { [weak self] value in
            self?.loginViewModel.sendOtp2(self?.emailTextField.text, Mode: "S")
        })
    }
    
    func bindSendOtp() {
        loginViewModel.otpSent.listen(on: { [weak self] value in
            let mobileString = self?.mobileTextField.text ?? ""
            let arrStr = mobileString.components(separatedBy: .whitespaces)
            let trimmed = "0" + arrStr.joined()
            self?.trimmedString = trimmed
            self?.viewModel.navigateToCreatePassword(self?.emailTextField.text, fullName: self?.fullNameTextField.text, idNumber: self?.idorIqamaTextField.text, phoneNumber: self?.mobileTextField.text)
        })
    }
    
    func bindYaqeenValidation() {
        viewModel.yaqeenResponse.listen(on: { [weak self] value in
            guard let value = value else { return }
            if value.driverImportRS?.success == "Y" {
                self?.checkIsYaqeenCalled(response: value)
            } else {
                CustomLoader.customLoaderObj.stopAnimating()
                self?.alertUser(msg: value.driverImportRS?.varianceReason ?? "")
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginWithAbsherButton.createNafazBtn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsManager.logScreenView(screenName: String(describing: AnalyticsKeys.Register), screenClass: String(describing: RegisterVC.self))
        AppsFlyerManager.logScreenView(screenName: String(describing: AnalyticsKeys.Register), screenClass: String(describing: RegisterVC.self))
    }
    
    // MARK: - Setup ViewModel
    func setupViewModel() {
        viewModel.setCountryCode = { [unowned self] (countryCode) in
            if let code = countryCode,
               let isoCode = FPNCountryCode(rawValue: code) {
                self.mobileTextField.setFlag(countryCode: isoCode)
            }
        }
        
        viewModel.showContinueLoading = {
            self.signUpButton.showLoading()
        }
        
        viewModel.dismissContinueLoading = {
            self.signUpButton.hideLoading()
        }
        
        viewModel.presentViewController = { [unowned self] (vc) in
            self.present(vc, animated: true, completion: nil)
        }
        
        loginViewModel.presentViewController = { [unowned self] (vc) in
            self.present(vc, animated: true, completion: nil)
        }
        
        loginViewModel.hideLoaddingForIam = { [unowned self] in
            self.loginWithAbsherButton.hideLoading()
        }
        
        viewModel.clearAll = { [unowned self] in
            self.emailTextField.text = ""
            self.mobileTextField.text = ""
            self.idorIqamaTextField.text = ""
            self.fullNameTextField.text = ""
        }
    }
    
    // MARK: - Initialization
    class func initializeFromStoryboard() -> RegisterVC {
        let storyboard = UIStoryboard(name: StoryBoards.Register, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: RegisterVC.self)) as! RegisterVC
    }
    
    // MARK: - Actions
    @IBAction func idOrEqamaTxtFieldDidChanged(_ sender: UITextField) {
        // Additional logic if needed
    }
    
    @IBAction func loginWithAbsherButtonAction(_ sender: Any) {
        loginWithAbsherButton.showLoading()
        loginViewModel.fetchIamServiceUrl()
    }
    
    func validateCreateAccountForSaudiID() {
        var trimmed = ""
        if !(idorIqamaTextField.text ?? "").isValidSaudiOrIqama() {
            alertUser(msg: "Please enter a valid ID number, or Iqama.".localized)
            return
        }
        
        let mobileString = mobileTextField.text ?? ""
        let arrStr = mobileString.components(separatedBy: .whitespaces)
        if arrStr.first != "0" {
            trimmed = "0" + arrStr.joined()
        }
        print(trimmed)
        
        if trimmed.count != 10 {
            alertUser(msg: "login_invalid_MobileNumber".localized)
            return
        }
        
        if !(emailTextField.text?.isValidEmail() ?? false) {
            alertUser(msg: "Please enter a valid email".localized)
            return
        }
        
        if birthDateTextField.text?.count ?? 0 < 1 {
            alertUser(msg: "Please enter a valid BirthDate".localized)
            return
        }
        
        CustomLoader.customLoaderObj.startAnimating()
        Authentication.shared.refreshToken { result in
            if result {
                self.viewModel.yaqeenValidation(DriverID: self.idorIqamaTextField.text ?? "", DriverDOB: (DateUtils.formatEnglishDate(date: self.birthdayDate ?? Date())))
            }
        }
    }
    
    func validateCreateAccountForPassport(phone: String) {
        if !(idorIqamaTextField.text ?? "").isValidPassport() {
            alertUser(msg: "Please enter a valid passport".localized)
            return
        }
        
        if fullNameTextField.text?.count ?? 0 < 1 {
            alertUser(msg: "Please enter a full name".localized)
            return
        }
        
        if phone.count < 5 {
            alertUser(msg: "login_invalid_MobileNumber".localized)
            return
        }
        
        if !(emailTextField.text?.isValidEmail() ?? false) {
            alertUser(msg: "Please enter a valid email".localized)
            return
        }
        
        viewModel.navigatetoOtp(email: emailTextField.text ?? "", fullName: fullNameTextField.text ?? "", idNumber: idorIqamaTextField.text ?? "", phoneNumber: phone.withoutSpaces, iSDCode1: String(mobileTextField.selectedCountry?.phoneCode.dropFirst() ?? "").withoutSpaces, password: passwordTextField.text ?? "")
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        let mobileString = mobileTextField.text ?? ""
        let arrStr = mobileString.components(separatedBy: .whitespaces)
        let trimmed = "0" + arrStr.joined()
        if selectedUserIDType == .saudiID {
            validateCreateAccountForSaudiID()
        } else {
            validateCreateAccountForPassport(phone: trimmed.withoutSpaces)
        }
    }
    
    func alertUser(msg: String) {
        CustomAlertController.initialization().showAlertWithOkButton(message: msg) { (index, title) in
            print(index, title)
        }
    }
    
    // MARK: - Date Conversion
    func convertDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy" // Update date format to match input string format
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

// MARK: - FPNTextFieldDelegate and UITextFieldDelegate
extension RegisterVC: FPNTextFieldDelegate, UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == idorIqamaTextField {
            // Additional logic if needed
        }
    }
    
    func fpnDisplayCountryList() {
        // Additional logic if needed
    }
    
    @objc func dismissCountryPicker() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showPasswordButtonAction(_ sender: Any) {
        showPasswordButton.isSelected = passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {}
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {}
}




import UIKit

class KeyboardManager {
    
    private weak var viewController: UIViewController?
    private var originalY: CGFloat = 0.0
    private var bindedView:UIView
    
    init(viewController: UIViewController, bindedView:UIView) {
        self.viewController = viewController
        self.bindedView = bindedView
        self.originalY = bindedView.frame.origin.y
        setupKeyboardObservers()
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let visibleHeight = bindedView.frame.height - keyboardHeight
        
        // Find the first responder within the view controller's view
        if let activeField = bindedView.findFirstResponder(),
           let globalPoint = activeField.superview?.convert(activeField.frame.origin, to: viewController?.view) {
            
            let activeFieldY =  activeField.frame.height
            
            if activeFieldY > visibleHeight {
                UIView.animate(withDuration: 0.3) {
                    self.bindedView.frame.origin.y = self.originalY - (activeFieldY - visibleHeight + 20)
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.bindedView.frame.origin.y = self.originalY
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension UIView {
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        for subview in self.subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}

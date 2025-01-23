//
//  LoginViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 25/04/1443 AH.
//

import UIKit
import XMLMapper
import ObjectMapper
import SwiftyXMLParser
import Combine

class LoginViewModel: BaseViewModel   {
    var userData: Publisher<UserResponse> = .init()
    
    var presentViewController: ((_ vc: UIViewController) -> Void)?
    var pushViewController: ((_ vc: UIViewController) -> Void)?
    var showLoading: (() -> Void)?
    var hideLoadding: (() -> Void)?
    var hideLoaddingForIam: (() -> Void)?
    var dismissTillCarDetails: (() -> Void)?
    var dismissViewController: (() -> Void)?
    var email : String?
    lazy  var loginService = LoginRegisterService()
    var otpSent : Publisher<ForgetPasswordResponseModel> = .init()

    lazy var forgetPasswordService = ForgetPasswordService()
    var isGuest : Bool?
    var isFromIAM : Bool?
    
    func login2(_ email : String? , password: String?) {
        CustomLoader.customLoaderObj.startAnimating()
        
        // Create the object
//        let params: [String: Any] = [
//            "driverLogin_Request": [
//                "UserName": "mudassar@theeb.sa",
//                "Password": "Theeb$1234"
//            ]
//        ]
        
        let paramsDic: [String: Any] = [
            "UserName": email,
            "Password": password
        ]
       
        
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.login.rawValue, type: .post,UserResponse.self)?.response(error: { [weak self] error in
            CustomLoader.customLoaderObj.stopAnimating()
            self?.error.send(error)
        }, receiveValue: { [weak self] model in
            guard let model = model else { return }
            CustomLoader.customLoaderObj.stopAnimating()
            self?.userData.send(model)
            if model.UserLogOut?.success != "False" &&  model.UserLogOut?.success != nil{
                CachingManager.store(value: model.UserLogOut?.email!, forKey: CachingKeys.email)
                CachingManager.storedPassword = password
                CachingManager.setLoginObject(model.UserLogOut)
                
                if self?.isGuest ?? false || (self?.isFromIAM  ?? false)  {
                    
                    if self?.isFromIAM ?? false {
                        
                        // UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  LandingPageVC.initializeWithNavigationController()
                        
                    } else {
                        UIViewController.topMostViewController()?.dismiss(animated: true)
                    }
                    
                } else {
                    
                    
                    if !(CachingManager.isFaceIdEnabled ?? false) {

                        let bioMetricVC = EnableBiometricVC.initializeFromStoryboard()

                        UIApplication.topViewController()?.present(bioMetricVC, animated: true, completion: nil)

                    } else {
                        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  LandingPageVC.initializeWithNavigationController()
                    }
                    
                }
            }
           
        }).store(self)
        
    }
    func login(_ email : String? , password: String?) {
        
//        CustomLoader.customLoaderObj.startAnimating()
        
        self.showLoading?()
        
        loginService.login(email: email, password: password, success: { (response) in
            
            guard let response = response as? String else {return}
            
            
            if let userModel = XMLMapper<UserLoginMappable>().map(XMLString: response) {
               
                if userModel.soapEnvelopeOuter?.success == TrueAndFalse.TRUE  {
                    
                    self.hideLoadding?()
                    CachingManager.store(value: email!, forKey: CachingKeys.email)
                  //  CachingManager.store(value: userModel.soapEnvelopeOuter.password, forKey: CachingKeys.password)
                    CachingManager.storedPassword = password
                    CustomLoader.customLoaderObj.stopAnimating()
                  //  CachingManager.setLoginObject(userModel.soapEnvelopeOuter)
                    
                    if self.isGuest ?? false || (self.isFromIAM  ?? false)  {
                        
                        if self.isFromIAM ?? false {

                           // UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  LandingPageVC.initializeWithNavigationController()
                     
                        } else {
                            UIViewController.topMostViewController()?.dismiss(animated: true)
                        }
                       
                    } else {
                        
                        if !(CachingManager.isFaceIdEnabled ?? false) {
                            
                            let bioMetricVC = EnableBiometricVC.initializeFromStoryboard()
                            
                            UIApplication.topViewController()?.present(bioMetricVC, animated: true, completion: nil)
                            
                        } else {
                            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  LandingPageVC.initializeWithNavigationController()
                        }
                   
                    }
                    
                    
                    
                } else {
                    CustomLoader.customLoaderObj.stopAnimating()
                    self.hideLoadding?()
                    CustomAlertController.initialization().showAlertWithOkButton(message: "login_worng_email_or_password".localized) { (index, title) in
                         print(index,title)
                    }
                }
            } else {
                CustomLoader.customLoaderObj.stopAnimating()
                self.hideLoadding?()
                CustomAlertController.initialization().showAlertWithOkButton(message: "login_worng_email_or_password".localized) { (index, title) in
                     print(index,title)
                }
            }
            
            
            
        }, failure: nil)
        
    }
    
    func sendOtp2( _ email : String?, Mode: String? = nil) {
        CustomLoader.customLoaderObj.startAnimating()
        let paramsDic: [String: Any] = [
            "Mode": Mode ?? "",
            "Email": email ?? "",
            "Password": "",
            "NewPassword": ""
        ]
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.resetPassword.rawValue, type: .post,ForgetPasswordResponseModel.self)?.response(error: { [weak self] error in
            CustomLoader.customLoaderObj.stopAnimating()
//            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                 print(index,title)
//            }
        }, receiveValue: { [weak self] model in
            CustomLoader.customLoaderObj.stopAnimating()
            if model?.PasswordRS?.Success == "Y"  {
                guard let model = model else { return }
                self?.otpSent.send(model)
            } else {
                CustomAlertController.initialization().showAlertWithOkButton(message: model?.PasswordRS?.VarianceReason ?? "") { (index, title) in
                     print(index,title)
                }
            }
        }).store(self)
        
    }
    func sendOtp( _ email : String?) {
        CustomLoader.customLoaderObj.startAnimating()
        forgetPasswordService.resetPasswordForSpecificOperation(operation: ForgetPasswordOperations.Save, email: email) { [weak self](response) in
            let frorgetReponse = XMLMapper<ForgetPasswordModel>().map(XMLString: response as! String)
            
            if frorgetReponse?.success == "Y"  {
                CustomLoader.customLoaderObj.stopAnimating()
                self?.navigateToResetPassword(email)
            } else {
                CustomLoader.customLoaderObj.stopAnimating()
                CustomAlertController.initialization().showAlertWithOkButton(message: frorgetReponse?.varianceReason ?? "") { (index, title) in
                     print(index,title)
                }
            }
            
            
        } failure: { (response, error) in
            
            CustomLoader.customLoaderObj.stopAnimating()
            
        }
        
    }
    
    
    
    func finalizeResetPassword2(_ email: String ,_ tempPassword: String? , newPassword: String?) {
        CustomLoader.customLoaderObj.startAnimating()
        let paramsDic: [String: Any] = [
            "Mode": "V",
            "Email": email ,
            "Password": tempPassword ?? "",
            "NewPassword": newPassword ?? ""
        ]
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.resetPassword.rawValue, type: .post,ForgetPasswordResponseModel.self)?.response(error: { [weak self] error in
            CustomLoader.customLoaderObj.stopAnimating()
//            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                 print(index,title)
//            }
        }, receiveValue: { [weak self] model in
            CustomLoader.customLoaderObj.stopAnimating()
            if model?.PasswordRS?.Success == "Y"  {
                CustomAlertController.initialization().showAlertWithOkButton(title: "".localized, message: "password_changed".localized) { (index, title) in
                    self?.dismissViewController?()
                }
            } else {
                CustomAlertController.initialization().showAlertWithOkButton(message: model?.PasswordRS?.VarianceReason ?? "") { (index, title) in
                     print(index,title)
                }
            }
        }).store(self)
        
    }
    
    func finalizeResetPassword(_ email: String ,_ tempPassword: String? , newPassword: String?) {
        CustomLoader.customLoaderObj.startAnimating()
        forgetPasswordService.resetPasswordForSpecificOperation(operation: ForgetPasswordOperations.Validate, email: email , password: tempPassword , newPassword: newPassword) {  (response) in
          
            let frorgetReponse = XMLMapper<ForgetPasswordModel>().map(XMLString: response as! String)
            
            if frorgetReponse?.success == "Y"  {
                
                CustomLoader.customLoaderObj.stopAnimating()
                self.dismissViewController?()
            } else {
                CustomLoader.customLoaderObj.stopAnimating()

                CustomAlertController.initialization().showAlertWithOkButton(message: frorgetReponse?.varianceReason ?? "") { (index, title) in
                     print(index,title)
                }
            }
            
            
        } failure: { (response, error) in
            
            CustomLoader.customLoaderObj.stopAnimating()
            
        }
        
    }
    
    func loginWithIamService(idNo : String?) {
        loginService.loginWithIAMService(idNo: idNo, success: { response in
            
            
        }, failure: nil)
        
    }
    
    func fetchIamServiceUrl() {
        
        
        
        loginService.iamServiceXMLString { response in
            guard let response = response as? String else {return}
            
            if let responseObject  = XMLMapper<IAMServiceRequest>().map(XMLString: response ){
                
                
                let urlTogo = responseObject.response?.urlString
                let imServiceVC = LoginWithIAMVC.initializeFromStoryboard()
                imServiceVC.urlToGo = urlTogo
                self.hideLoaddingForIam?()
                self.presentViewController?(imServiceVC)
                
                
            }
            
            
            
        } failure: { response, error in
            
        }
        
        
    }
    
    
    func navigateToForgetPassword()  {
        
        let sendotpVC = SendotpVC.initializeFromStoryboard()
        self.presentViewController?(sendotpVC)
    }
    
    func navigateToResetPassword(_ email: String?)  {
        
        let sendotpVC = ResetpasswordVC.initializeFromStoryboard()
        sendotpVC.email = email
        self.presentViewController?(sendotpVC)
    }
    
    
    
}

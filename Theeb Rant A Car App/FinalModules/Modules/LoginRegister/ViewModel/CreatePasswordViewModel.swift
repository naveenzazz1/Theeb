//
//  CreatePasswordViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 30/05/1443 AH.
//

import UIKit
import XMLMapper

class CreatePasswordViewModel: BaseViewModel {
    
    lazy var service =  ForgetPasswordService()
    var dismissViewController: (() -> Void)?
  
    // MARK: - Variables
    
    var idNumber: String?
    var email: String?
    var phoneNumber:String?
    var fullName: String?
    var isFromIam: Bool? = false
    lazy  var loginService = LoginRegisterService()

    
    func finalizeRegistation2(_ email: String ,_ tempPassword: String? , newPassword: String?) {
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
            if self?.isFromIam ?? false {
                
                if model?.PasswordRS?.Success == "Y"  {
    
                } else {
                    
                    CustomLoader.customLoaderObj.stopAnimating()
                    CustomAlertController.initialization().showAlertWithOkButton(message: model?.PasswordRS?.VarianceReason ?? "") { (index, title) in
                         print(index,title)
                    }

                }
             
                
            } else {
                if model?.PasswordRS?.Success == "Y"  {
                    
                    CustomLoader.customLoaderObj.stopAnimating()
                    CachingManager.store(value: email, forKey: CachingKeys.email)
                    CachingManager.storedPassword = newPassword
                    self?.dismissViewController?()
                    UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = LoginRegisterVC.initializeFromStoryboard()

                } else {
                    
                    CustomLoader.customLoaderObj.stopAnimating()
                    CustomAlertController.initialization().showAlertWithOkButton(message: model?.PasswordRS?.VarianceReason ?? "") { (index, title) in
                         print(index,title)
                    }

                }
                
            }
        }).store(self)
        
    }
    
    
    func finalizeRegistation(_ email : String? , password: String? , newPassword: String?) {
      
        service.resetPasswordForSpecificOperation(operation: ForgetPasswordOperations.Validate, email: email, password: password, newPassword: newPassword) { [weak self] (resposne) in
            guard let response = resposne as? String else {return}
            let sendOtpResponse = XMLMapper<ForgetPasswordModel>().map(XMLString: response )
            if self?.isFromIam ?? false {
                
                if sendOtpResponse?.success == "Y"  {
                    
                    CustomLoader.customLoaderObj.stopAnimating()
                  //  self?.dismissViewController?()
//                    UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = LoginRegisterVC.initializeFromStoryboard()
                    
               //     self?.login(email, password: password)


                } else {
                    
                    CustomLoader.customLoaderObj.stopAnimating()
                    CustomAlertController.initialization().showAlertWithOkButton(message: sendOtpResponse?.varianceReason ?? "") { (index, title) in
                         print(index,title)
                    }

                }
             
                
            } else {
                if sendOtpResponse?.success == "Y"  {
                    
                    CustomLoader.customLoaderObj.stopAnimating()
                    self?.dismissViewController?()
                    UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = LoginRegisterVC.initializeFromStoryboard()

                } else {
                    
                    CustomLoader.customLoaderObj.stopAnimating()
                    CustomAlertController.initialization().showAlertWithOkButton(message: sendOtpResponse?.varianceReason ?? "") { (index, title) in
                         print(index,title)
                    }

                }
                
            }
            
        
            
        } failure: { (response, error) in
            
        }

        
        
    }
    
    
    func login2(_ email : String? , password: String?) {

        let paramsDic: [String: Any] = [
            "UserName": email ?? "",
            "Password": password ?? ""
        ]
       
        
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.login.rawValue, type: .post,UserResponse.self)?.response(error: { [weak self] error in
            CustomLoader.customLoaderObj.stopAnimating()

            CustomAlertController.initialization().showAlertWithOkButton(message: "login_worng_email_or_password".localized) { (index, title) in
                 print(index,title)
            }
        }, receiveValue: { [weak self] model in
            guard let model = model else { return }
            CustomLoader.customLoaderObj.stopAnimating()
                if (model.UserLogOut?.success ?? "False") == "False" {
                    CustomAlertController.initialization().showAlertWithOkButton(message: model.UserLogOut?.varianceReason ?? "") { (index, title) in
                    }
                } else {
                    CachingManager.store(value: model.UserLogOut?.email!, forKey: CachingKeys.email)
                    CachingManager.storedPassword = model.UserLogOut?.password
                     CachingManager.setLoginObject(model.UserLogOut)
                    
                   
                    
                    if !(CachingManager.isFaceIdEnabled ?? false) {

                        let bioMetricVC = EnableBiometricVC.initializeFromStoryboard()

                        UIApplication.topViewController()?.present(bioMetricVC, animated: true, completion: nil)

                    } else {
                        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  LandingPageVC.initializeWithNavigationController()
                    }
                    
                }
           
        }).store(self)
        
    }
    
    
    func login(_ email : String? , password: String?) {
        
//        CustomLoader.customLoaderObj.startAnimating()
        
     
        
        loginService.login(email: email, password: password, success: { (response) in
            
            guard let response = response as? String else {return}
            
            
            if let userModel = XMLMapper<UserLoginMappable>().map(XMLString: response) {
               
                if userModel.soapEnvelopeOuter?.success == TrueAndFalse.TRUE  {
                    
                 
                    CachingManager.store(value: email!, forKey: CachingKeys.email)
                  //  CachingManager.store(value: userModel.soapEnvelopeOuter.password, forKey: CachingKeys.password)
                    CachingManager.storedPassword = password
                    CustomLoader.customLoaderObj.stopAnimating()
                    // to be done here ??
                   // CachingManager.setLoginObject(userModel.soapEnvelopeOuter)
                    
                
                    if !(CachingManager.isFaceIdEnabled ?? false) {

                        let bioMetricVC = EnableBiometricVC.initializeFromStoryboard()

                        UIApplication.topViewController()?.present(bioMetricVC, animated: true, completion: nil)

                    } else {
                        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  LandingPageVC.initializeWithNavigationController()
                    }
               
//                    if self.isGuest ?? false {
//                        UIViewController.topMostViewController()?.dismiss(animated: true)
//                    } else {
//
//                        if CachingManager.isFirstLogin ?? false {
//
//                            let bioMetricVC = EnableBiometricVC.initializeFromStoryboard()
//
//                            UIApplication.topViewController()?.present(bioMetricVC, animated: true, completion: nil)
//
//                        } else {
//                            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  LandingPageVC.initializeWithNavigationController()
//                        }
//
//                    }
                    
                    
                    
                } else {
                    CustomLoader.customLoaderObj.stopAnimating()

                    CustomAlertController.initialization().showAlertWithOkButton(message: "login_worng_email_or_password".localized) { (index, title) in
                         print(index,title)
                    }
                }
            } else {
                CustomLoader.customLoaderObj.stopAnimating()
                CustomAlertController.initialization().showAlertWithOkButton(message: "login_worng_email_or_password".localized) { (index, title) in
                     print(index,title)
                }
            }
            
            
            
        }, failure: nil)
        
    }
    
    
    
}

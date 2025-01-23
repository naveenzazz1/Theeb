//
//  RegistrationViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 30/05/1443 AH.
//

import UIKit
import XMLMapper
import Combine

class RegistrationViewModel: BaseViewModel  {
    
    var setCountryCode: ((_ countryCode: String?) -> Void)?
    var dismiss: (() -> Void)?
    var switchToLogin: (() -> Void)?
    var clearAll: (() -> Void)?
    var showContinueLoading: (() -> Void)?
    var dismissContinueLoading: (() -> Void)?
    var presentViewController: ((_ vc: UIViewController) -> Void)?
    lazy var service = LoginRegisterService()
    lazy var forgetPasswordService = ForgetPasswordService()
    lazy var loginService = LoginRegisterService()
    var loginWithIamViewModel = LoginWithIAmViewModel()
    
    var isFromIam: Bool? = false
    var registratoinObject :  TheebDriverSetNSObject?
    var iAmResponseObject : IAMServiceRequestBookingResponseObject?
    
    var createAccount : Publisher<CreateAccountResponseModel> = .init()
    var yaqeenResponse : Publisher<YaqeenResponseModel> = .init()
    
    // MARK: - Setup
    
    func setDefaultCountryCode() {
        
        setCountryCode?(CountryCodes.saudiArabia)
    }
    
    
    // MARK: - Validations
    
    func isValidMobileNumber(_ mobileNumber: String) -> Bool {
        
        return !(mobileNumber.count < MinEntryDigits.Mobile)
    }
    
    func updateButtonState(for mobileNumber: String) {
        
        let _ = isValidMobileNumber(mobileNumber)
        
    }
    
    func navigatetoOtp(email:String? ,
                       fullName: String?,
                       idNumber : String? ,
                       phoneNumber: String?,iSDCode1: String?, password: String? = nil) {
    CustomLoader.customLoaderObj.startAnimating()
      //  self.getDriverProfile(idNo: idNumber, email: email, fullName: fullName, phoneNumber: phoneNumber, password: password)
        self.createDriverAccount(idNo: idNumber, email: email, fullName: fullName, phoneNumber: phoneNumber,isDcode1: iSDCode1, password: password, Model: "C")
    
        
    }
    
    
  

    
    // MARK: - Helper Methods
    
    func dismissVC() {
        self.dismiss?()
    }
    
    func navigateToCreatePassword(_ email: String?, fullName: String? ,idNumber: String? ,phoneNumber: String?)  {
        
        let createPasswordVC = CreatePasswordVC.initializeFromStoryboard()
        createPasswordVC.setRegistrationModel(email:email , fullName: fullName, idNumber: idNumber, phoneNumber: phoneNumber)
        
        self.presentViewController?(createPasswordVC)
    }
    
    func yaqeenValidation(DriverID: String?,
                          DriverDOB: String?){
        let paramsDic: [String: Any] = [
              "DriverID": DriverID ?? "",
              "DriverDOB": DriverDOB ?? "",
              "FlagType": (DriverID?.first == "1") ? "S" : "I"
              ]
        
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.request(NetworkConfigration.EndPoint.yaqeenValidation.rawValue, type: .get,YaqeenResponseModel.self, isResponsetypeRequired: false)?.response(error: {  error in
            CustomLoader.customLoaderObj.stopAnimating()
            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription, completion: nil)
        }, receiveValue: { [weak self] model in
            guard let model = model else { return }
            self?.yaqeenResponse.send(model)
            
        }).store(self)
    }
    func createDriverAccount(idNo : String?,
                             email:String? ,
                             fullName: String?,
                             phoneNumber: String?,
                             isDcode1: String?,
                             password: String? =  nil, Model: String? = nil) {
        CustomLoader.customLoaderObj.startAnimating()
        //self.showContinueLoading?()
        
        let slicedName = fullName?.sliceFullname()
        let idType = self.getIdTypeValueForIdNumber(idNo: idNo)
        
        let paramsDic: [String: Any] = [
              "UpdateDriverInfo": "",
              "UpdateDriverImage": "",
              "UpdateLicenceInfo": "",
              "UpdateLicenceImage": "",
              "UpdateIDInfo": "",
              "UpdateIDImage": "",
              "CalledFrom": "",
              "LastName": slicedName?.1 ?? "",
              "FirstName": slicedName?.0 ?? "",
              "DateOfBirth": "",
              "Nationality": "",
              "LicenseId": idNo ?? "",
              "LicenseIssuedBy": "",
              "LicIssueDate": "",
              "LicenseExpiryDate": "",
              "LicenseDoc": "",
              "Address1": "",
              "Address2": "",
              "HomeTel": "",
              "WorkTel": "",
              "ISDCode1": isDcode1 ?? "",
              "Mobile": phoneNumber ?? "",
              "Email": email ?? "",
              "IdType": idType ?? "",
              "IdNo": idNo ?? "",
              "IDIssueDate": "",
              "IDExpiryDate": "",
              "IdDoc": "",
              "MembershipNo": "",
              "Operation": Model ?? "",
              "ContactCity": "",
              "PostalCode": "",
              "Province": "",
              "Country": "",
              "WorkIdDoc": "",
              "DriverImage": ""
        ]
       
        
        
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.createAccount.rawValue, type: .post,CreateAccountResponseModel.self)?.response(error: { [weak self] error in
            CustomLoader.customLoaderObj.stopAnimating()

//            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                 print(index,title)
//            }
        }, receiveValue: { [weak self] model in
            guard let model = model else { return }
            CustomLoader.customLoaderObj.stopAnimating()
           
            if model.DriverImportRS?.Success == "Y"  {
                
                self?.createAccount.send(model)
                
            } else {
               // if email != "" {
                
                    CustomAlertController.initialization().showAlertWithOkButton(message: model.DriverImportRS?.VarianceReason ?? "") { (index, title) in
                     print(index,title)
            }
             //   }
            }
        }).store(self)
        
    }
    
    func getDriverProfile(idNo : String?,
                          email:String? ,
                          fullName: String?,
                          phoneNumber: String?,
                          password: String? =  nil) {
        
        CustomLoader.customLoaderObj.startAnimating()
     //   CustomLoader.customLoaderObj.stopAnimating()
        self.showContinueLoading?()
        CustomLoader.customLoaderObj.startAnimating()
        let slicedName = fullName?.sliceFullname()
        loginService.getDriverProfile(idNo: idNo) { response in
            self.dismissContinueLoading?()
            if let responseString = response as? String {
                var resultString = responseString.replacingOccurrences(of: "DriverImportRS", with: "DriverProfileRS")
                resultString = resultString.replacingOccurrences(of: "LicenseID", with: "LicenseId")
                
               // CustomLoader.customLoaderObj.stopAnimating()
                if let reponspobject = XMLMapper<DriverProfileRequestMappable>().map(XMLString: resultString) {
                    if ((reponspobject.driverProfileRS?.oTPVerified == "Y") && (reponspobject.driverProfileRS?.email != nil)  && (reponspobject.driverProfileRS?.password != nil ))  {
                    //    self.caseForLoginAndRegistration(driverProfileRS: reponspobject.driverProfileRS!)
                        self.switchToLogin?()
                        self.clearAll?()
                    } else {
                        
                        if self.isFromIam ?? false {
                            self.loginWithIamViewModel.regiterIam  = true
                            self.loginWithIamViewModel.password = password
                            self.loginWithIamViewModel.mobileNumber = phoneNumber
                            self.loginWithIamViewModel.email = email
                            self.loginWithIamViewModel.iAmResponseObject = self.iAmResponseObject
                            self.loginWithIamViewModel.registratoinObject = self.registratoinObject!
                            self.loginWithIamViewModel.loginWithIamService(idNo:  UserDefaults.standard.object(forKey: "iAMKey") as? String ?? "")
                            
                        } else {
                            
                            let idType = self.getIdTypeValueForIdNumber(idNo: idNo)
                            CustomLoader.customLoaderObj.startAnimating()
                            self.service.registerNewCustomer(email: email, firstName: slicedName?.0, lastName: slicedName?.1, idNumber: idNo, phoneNumer: phoneNumber, password: "", idType: idType) { response in
                                let updateProfileResponse = XMLMapper<DriverUpdateMappable >().map(XMLString: response as! String)
                                
                                CustomLoader.customLoaderObj.stopAnimating()
                                if updateProfileResponse?.success == "Y"  {
                                    
                                    self.forgetPasswordService.resetPasswordForSpecificOperation(operation: ForgetPasswordOperations.Save, email: email) { (response) in
                                 //       CustomLoader.customLoaderObj.startAnimating()
                                        let sendOtpResponse = XMLMapper<ForgetPasswordModel>().map(XMLString: response as! String)
                                        if sendOtpResponse?.success == "Y"  {
                                            CustomLoader.customLoaderObj.startAnimating()
                                            self.navigateToCreatePassword(email, fullName: fullName, idNumber: idNo, phoneNumber: phoneNumber)

                                        } else {
                                            if email != "" {
                                          
                                                CustomLoader.customLoaderObj.stopAnimating()
                                                CustomAlertController.initialization().showAlertWithOkButton(message: sendOtpResponse?.varianceReason ?? "") { (index, title) in
                                                     print(index,title)
                                                    
                                                }
                                            } else {
                                                
                                            }
                                        }
                                        
                                        
                                    } failure: { (respnse, error) in
                                        
                                    }
                                    
                                    
                                    
                                    
                                } else {
                                    if email != "" {
                                    
                                    CustomLoader.customLoaderObj.stopAnimating()
                                    CustomAlertController.initialization().showAlertWithOkButton(message: updateProfileResponse?.varianceReason ?? "") { (index, title) in
                                         print(index,title)
                                }
                                    }
                                }
                                
                            } failure: { response, error in
                                
                                
                            }

                            
                        }
                        
                    }
                    
                    
                }
            }
       //     CustomLoader.customLoaderObj.stopAnimating()
        
        } failure: { response, error in
            
        }
    
}
    
    func finalizeRegistation(_ email : String? , password: String? , newPassword: String?, idNo: String? = nil) {
      
        forgetPasswordService.resetPasswordForSpecificOperation(operation: ForgetPasswordOperations.Reset, email: email, password: password, newPassword: newPassword) { [weak self] (resposne) in
            guard let response = resposne as? String else {return}
            let sendOtpResponse = XMLMapper<ForgetPasswordModel>().map(XMLString: response )
            if self?.isFromIam ?? false {
                
                if sendOtpResponse?.success == "Y"  {
                 
                        
                    self?.loginService.getDriverProfile(idNo: idNo) { response in
                        
                        if let responseString = response as? String {
                            if let reponspobject = XMLMapper<DriverProfileRequestMappable>().map(XMLString: responseString) {
                                if reponspobject.driverProfileRS?.success == "Y" {
                                    
                                    self?.login2(email, password: reponspobject.driverProfileRS?.password)
                                }
                                
                                
                            }
                        }
                      
                            
                        
                        
                    }
                failure: { response, error in
                        
                        
                    }


                } else {
                    
                  //  CustomLoader.customLoaderObj.stopAnimating()
                    CustomAlertController.initialization().showAlertWithOkButton(message: sendOtpResponse?.varianceReason ?? "") { (index, title) in
                         print(index,title)
                    }

                }
             
                
            } else {
                if sendOtpResponse?.success == "Y"  {
                    
                    CustomLoader.customLoaderObj.stopAnimating()
//                    self?.dismissViewController?()
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
    
    func getIdTypeValueForIdNumber(idNo: String?) -> String?
    {
        let arrayChar = Array(idNo!)
        
        
        var idType = String()
        
        switch arrayChar.first {
        case "1":
            idType = "S"
        case "2":
            idType = "I"
        default:
            idType = "P"
        }
        
        if(!self.specialCharacterNotEnter(txtField: idNo ?? "") )
        {
            idType = "P"
        }
        if(idNo!.count != 10 )
        {
            idType = "P"
        }
        
    
        return idType
        
        print("IDTYPE  - \(idType)")
    }
    
    func specialCharacterNotEnter(txtField:String)->Bool{
        
        let characterset = CharacterSet(charactersIn: "0123456789")
        if txtField.rangeOfCharacter(from: characterset.inverted) != nil {
            print("string contains special characters")
            return false
        }
        return true
    }


}

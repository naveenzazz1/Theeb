//
//  UserProfileViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 13/03/2022.
//

import UIKit
import XMLMapper

class UserProfileViewModel : BaseViewModel{
   
    //MARK: - vars
    let profileServices = ViewProfileService()
    var memberService = MemberTransferPointsService()
    var startLoadingIndicator: (() -> ())?
    var stopLoadingIndicator: (() -> ())?
    var userProfile: Publisher<DriverProfileResponse> = .init()
    var userProfileFaild: Publisher<String> = .init()
    var yaqeenResponse : Publisher<YaqeenResponseModel> = .init()
    
    func updateDriverAccount(firstName:String? = nil,
                             lastName:String? = nil,
                             dateOfBirth:String? = nil,
                             nationality:String? = nil,
                             licenseId:String? = nil,
                             licenseIssuedBy:String? = nil,
                             licenseExpiryDate:String? = nil,
                             licenseDoc:String? = nil,
                             licenseDocFileExt:String? = nil,
                             address1:String? = nil,
                             address2:String? = nil,
                             homeTel:String? = nil,
                             ISDCode1:String? = nil,
                             workTel:String? = nil ,
                             mobile:String? = nil,
                             email:String? = nil,
                             idType:String? = nil,
                             idNo:String? = nil,
                             idDoc:String? = nil,
                             idDocFileExt:String? = nil,
                             membershipNo:String? = nil,
                             operation:String? = nil,
                             iDSerialNo :String? = nil,
                             workIdDoc :String? = nil,
                             workIdDocFileExt :String? = nil,
                             driverImage :String? = nil,
                             driverImageFileExt :String? = nil,
                             gender:String? = nil,
                             fomIAMService:String? = nil,
                             arabicName:String? = nil,
                             passLicExpDate:String? = nil,
                             password:String? = nil,
                             isFromAlForsan: Bool = false,
                             alfursanID:String? = nil,
                             complition: (()->Void)? = nil) {
        CustomLoader.customLoaderObj.startAnimating()
        
        let paramsDic: [String: Any] = [
              "UpdateDriverInfo": "Y",
              "UpdateDriverImage": "",
              "UpdateLicenceInfo": "",
              "UpdateLicenceImage": "",
              "UpdateIDInfo": "",
              "UpdateIDImage": "",
              "CalledFrom": "",
              "LastName": lastName ?? "",
              "FirstName": firstName ?? "",
              "DateOfBirth": dateOfBirth ?? "",
              "Nationality": nationality ?? "",
              "LicenseId": licenseId ?? "",
              "LicenseIssuedBy": licenseIssuedBy ?? "",
              "LicIssueDate": "",
              "LicenseExpiryDate": licenseExpiryDate ?? "",
              "LicenseDoc": licenseDoc ?? "",
              "Address1": address1 ?? "",
              "Address2": address2 ?? "",
              "HomeTel": homeTel ?? "",
              "WorkTel": workTel ?? "",
              "ISDCode1":ISDCode1 ?? "",
              "Mobile": mobile ?? "",
              "Email": email ?? "",
              "IdType": idType ?? "",
              "IdNo": idNo ?? "",
              "IDIssueDate": "",
              "IDExpiryDate": "",
              "IdDoc": idDoc ?? "",
              "MembershipNo": membershipNo ?? "",
              "Operation": "M",
              "ContactCity": "",
              "PostalCode": "",
              "Province": "",
              "Country": "",
              "Password": password ?? "",
              "Gender": gender ?? "",
              "WorkIdDoc": workIdDoc ?? "",
              "DriverImage": driverImage ?? "",
              "AlfursanID" : alfursanID ?? ""
        ]
       
        
        
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.createAccount.rawValue, type: .post,CreateAccountResponseModel.self)?.response(error: { error in
            CustomLoader.customLoaderObj.stopAnimating()
            print(error.localizedDescription)
            
        }, receiveValue: { [weak self] model in
            guard let model = model else { return }
            CustomLoader.customLoaderObj.stopAnimating()
           
            if model.DriverImportRS?.Success == "Y" {
                DispatchQueue.main.async{
                    if isFromAlForsan{
                        complition?()
                    }else{
                        self?.alertUser(title: "alert_success".localized,msg: "profile_updateSuccesull".localized)
                    }
                }
            }else{
                DispatchQueue.main.async{
                    self?.alertUser(msg: "profile_updateFailed".localized)
                }
            }
        }).store(self)
        
    }
    
    func updateProfile (firstName:String? = nil,
                        lastName:String? = nil,
                        dateOfBirth:String? = nil,
                        nationality:String? = nil,
                        licenseId:String? = nil,
                        licenseIssuedBy:String? = nil,
                        licenseExpiryDate:String? = nil,
                        licenseDoc:String? = nil,
                        licenseDocFileExt:String? = nil,
                        address1:String? = nil,
                        address2:String? = nil,
                        homeTel:String? = nil,
                        workTel:String? = nil ,
                        mobile:String? = nil,
                        email:String? = nil,
                        idType:String? = nil,
                        idNo:String? = nil,
                        idDoc:String? = nil,
                        idDocFileExt:String? = nil,
                        membershipNo:String? = nil,
                        operation:String? = nil,
                        iDSerialNo :String? = nil,
                        workIdDoc :String? = nil,
                        workIdDocFileExt :String? = nil,
                        driverImage :String? = nil,
                        driverImageFileExt :String? = nil,
                        gender:String? = nil,
                        fomIAMService:String? = nil,
                        arabicName:String? = nil,
                        passLicExpDate:String? = nil,
                        password:String? = nil) {
        CustomLoader.customLoaderObj.startAnimating()
        profileServices.updateProfile(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, nationality: nationality, licenseId: licenseId, licenseIssuedBy: licenseIssuedBy, licenseExpiryDate: licenseExpiryDate, licenseDoc: licenseDoc, licenseDocFileExt: licenseDocFileExt, address1: address1, address2: address2, homeTel: homeTel, workTel: workTel, mobile: mobile, email: email, idType: idType, idNo: idNo, idDoc: idDoc, idDocFileExt: idDocFileExt, membershipNo: membershipNo, operation: operation, iDSerialNo: iDSerialNo, workIdDoc: workIdDoc, workIdDocFileExt: workIdDocFileExt, driverImage: driverImage, driverImageFileExt: driverImageFileExt, gender: gender, fomIAMService: fomIAMService, arabicName: arabicName, passLicExpDate: passLicExpDate, password: password) { (response) in
            guard let response = response as? String else {return}
            let userModel = XMLMapper<DriverUpdateModel>().map(XMLString: response )
            CustomLoader.customLoaderObj.stopAnimating()
            if userModel?.success == "Y" {
                DispatchQueue.main.async{
                    self.alertUser(title: "alert_success".localized,msg: "profile_updateSuccesull".localized)
                }
            }else{
                DispatchQueue.main.async{
                    self.alertUser(msg: "profile_updateFailed".localized)
                }
            }
        } failure: { (response, error) in
            print(error?.localizedDescription)
        }

        
    }
    
    func yaqeenValidation(DriverID: String?,
                          DriverDOB: String?){
        CustomLoader.customLoaderObj.startAnimating()
        let paramsDic: [String: Any] = [
              "DriverID": DriverID ?? "",
              "DriverDOB": DriverDOB ?? "",
              "FlagType": CachingManager.loginObject()?.iDType ?? ""
              ]
        
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.request(NetworkConfigration.EndPoint.yaqeenValidation.rawValue, type: .get,YaqeenResponseModel.self, isResponsetypeRequired: false)?.response(error: {  error in
            CustomLoader.customLoaderObj.stopAnimating()
            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription, completion: nil)
        }, receiveValue: { [weak self] model in
            CustomLoader.customLoaderObj.stopAnimating()
            guard let model = model else { return }
            self?.yaqeenResponse.send(model)
            
        }).store(self)
    }
    
    func subscribeToMemberShip(idNo:String){
        memberService.subscribeMemberShip(idNo: idNo) { response in
            guard let response = response as? String else {return}
            let userModel = XMLMapper<ApplicantImportRSModel>().map(XMLString: response )
                DispatchQueue.main.async{
                    print(userModel)
                    self.alertUser(msg: userModel?.applecationRS?.successString == "Y" ? "MemberShip request is under processing":(userModel?.applecationRS?.varianceString ?? "Error in application"))
                }
        } failure: { response, error in
            print(error?.localizedDescription)
        }

    }
    private func alertUser(title:String = "login_error".localized,msg:String){
//        let banner = Banner(title: msg, image: UIImage(named: "logo"), backgroundColor: UIColor().returnColorBlue())
//        banner.dismissesOnTap = true
//        banner.show(duration: 5.0)
        CustomAlertController.initialization().showAlertWithOkButton(title:title,message: msg) { (index, title) in
            print(index,title)
       }
    }
    
    func mutateCashing(){
        
    }
    
    func getUserProfile(licenseNo: String,mobile: String,passportNo: String,email: String) {
        let paramsDic: [String: Any] = [
              "LicenseIdNo": licenseNo,
               "MobileNumber": mobile,
               "PassportIdNumber": passportNo,
               "InternetAddress": email
        ]
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.profile.rawValue, type: .post,DriverProfileResponse.self)?.response(error: { [weak self] error in
           // send error
//            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                 print(index,title)
//            }
        }, receiveValue: { [weak self] model in
            guard let model = model else { return }
            self?.userProfile.send(model)

        }).store(self)
        
    }
    
}

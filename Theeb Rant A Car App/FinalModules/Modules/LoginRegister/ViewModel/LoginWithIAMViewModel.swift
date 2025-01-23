//
//  LoginWithIAMViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 04/09/1443 AH.
//

import UIKit
import XMLMapper
class LoginWithIAmViewModel {
    
    var iAmResponseObject  : IAMServiceRequestBookingResponseObject?
    var registratoinObject  =  TheebDriverSetNSObject()
    lazy var loginService = LoginRegisterService()
    lazy var loginViewModel = LoginViewModel()
    var publicDriverProfileRS  : DriverProfileRS?
    var regiterIam: Bool? = false
    var password: String?
    var email: String?
    var mobileNumber: String?
    var presentViewController: ((_ vc: UIViewController) -> ())?
    var actionForRegsiterOrLogin: (() -> ())?
    //    var registratoinObject :  TheebDriverSetNSObject?
    //    var iAmResponseObject : IAMServiceRequestBookingResponseObject?
    
    func loginWithIamService(idNo : String?) {
        
        
        loginService.loginWithIAMService(idNo: idNo, success: { response in
            guard let responsse = response as? String else {return}
            
            if let responseModel = XMLMapper<IAMServiceRequestBookingResponse>().map(XMLString: responsse ) {
                
                self.iAmResponseObject = responseModel.response
                
                self.registratoinObject.iDSerialNO = responseModel.response?.IDVERSIONNO ?? ""
                self.registratoinObject.licenseExpiryDate = responseModel.response?.IDEXPIRYDATEGREGORIAN ?? ""
                self.registratoinObject.dateOfBirth = responseModel.response?.DOB ?? ""
                self.registratoinObject.licenseId = responseModel.response?.USERID ?? ""
                self.registratoinObject.idNo = responseModel.response?.USERID ?? ""
                self.registratoinObject.nationality = responseModel.response?.NATIONALITY ?? ""
                self.registratoinObject.gender = responseModel.response?.GENDER
                self.registratoinObject.firstName = responseModel.response?.AR_FIRSTNAME ?? ""
                self.registratoinObject.lastName = responseModel.response?.AR_FAMILYNAME ?? ""
                self.registratoinObject.licenseIssuedBy = "KSA"
                self.registratoinObject.idNo = responseModel.response?.USERID ?? ""
                if responseModel.response?.GENDER == "M" {
                    self.registratoinObject.title = "Mr"
                } else if responseModel.response?.GENDER == "F"  {
                    self.registratoinObject.title = "M/S"
                }
                
                
                //   self.registratoinObject.email = responseModel.response.
                if self.regiterIam ?? false {
                    self.setValueForIdType()
                    
                    self.getDriverProfileee(idNo: responseModel.response?.USERID ?? "")
                } else {
                    self.getDriverProfile(idNo: responseModel.response?.USERID ?? "")
                }
                
                
            }
            
            
        }, failure: nil)
        
    }
    
    func withIAMServiceNormal(){
        
        print("Success")
        let dateOfBirth = self.changeDateFormatFromStringUser(stringDate: self.registratoinObject.dateOfBirth ?? "", formatInput: "YYYYMMDD" , formatOutPut: "dd/MM/yyyy")
        // dateOfBirth = "02/07/1990"
        let licenseExpiryOfBirth = self.changeDateFormatFromStringUser(stringDate: self.registratoinObject.licenseExpiryDate ?? "", formatInput: "YYYYMMDD" , formatOutPut: "dd/MM/yyyy")
        
        
        let soapRequestString = self.registrationUpdateRequest(FirstName: iAmResponseObject?.AR_FIRSTNAME,                                                                       LastName:iAmResponseObject?.AR_FAMILYNAME,
                                                               dateOfBirth: dateOfBirth,
                                                               nationality:  registratoinObject.nationality,
                                                               licenseId:  registratoinObject.licenseId,
                                                               licenseIssuedBy:  "",
                                                               LicenseExpiryDate:  licenseExpiryOfBirth,
                                                               LicenseDoc: "",
                                                               LicenseDocFileExt: "",
                                                               Address1: "",
                                                               Address2: "",
                                                               HomeTel: "",
                                                               WorkTel: "",
                                                               Mobile: self.mobileNumber,
                                                               Email:self.email,
                                                               IdType:registratoinObject.idType ,
                                                               IdNo: registratoinObject.idNo,
                                                               IdDoc: "",
                                                               IdDocFileExt: "",
                                                               MembershipNo: "",
                                                               Operation: "",Password:"",
                                                               IDSerialNo:registratoinObject.iDSerialNO! ,
                                                               WorkIdDoc: "",
                                                               WorkIdDocFileExt: "",
                                                               DriverImage:"",
                                                               DriverImageFileExt: "", gender: registratoinObject.title, FromIAMService: "Y",ArabicName: iAmResponseObject?.ENG_NAME ?? "" ,PassLicExpDate: licenseExpiryOfBirth,password : self.password, title: registratoinObject.title)
        
        
        loginService.registerNewCustomer(soapXmlString: soapRequestString, fromIam:  true) { response in
            guard let response = response as? String else {return}
            
            if let updateResponseModel = XMLMapper<DriverUpdateMappable>().map(XMLString: response) {
                
                if updateResponseModel.success == "Y" {
                    self.loginViewModel.isFromIAM = true
                    self.loginViewModel.login(self.email, password: self.password )
                    
                    CachingManager.store(value: self.email, forKey: CachingKeys.email)
                   
                    CachingManager.storedPassword = self.password
                } else {
                    CustomAlertController.initialization().showAlertWithOkButton(message: updateResponseModel.varianceReason) { (index, title) in
                         print(index,title)
                    }
                }
                
            }
        } failure: { response, error in
            
        }
        
        
    }
    
    func getDriverProfilee(idNo : String?)  {
        
        CustomLoader.customLoaderObj.startAnimating()
        
        loginService.getDriverProfile(idNo: idNo) { response in
            if let responseString = response as? String {
                var resultString = responseString.replacingOccurrences(of: "DriverImportRS", with: "DriverProfileRS")
                resultString = resultString.replacingOccurrences(of: "LicenseID", with: "LicenseId")
                if let reponspobject = XMLMapper<DriverProfileRequestMappable>().map(XMLString: resultString) {
                    if ((reponspobject.driverProfileRS?.success == "Y")  &&  (reponspobject.driverProfileRS?.email != nil) && ( reponspobject.driverProfileRS?.password != nil) && (reponspobject.driverProfileRS?.oTPVerified == "N" || reponspobject.driverProfileRS?.oTPVerified == "Y")){
                        self.caseForLoginAndRegistrationn(driverProfileRS: reponspobject.driverProfileRS!)
                        self.publicDriverProfileRS = reponspobject.driverProfileRS
                    } else {
                        let loginRegisterVC = LoginRegisterVC.initializeFromStoryboard()
                        loginRegisterVC.modalPresentationStyle = .fullScreen
                        loginRegisterVC.isFromRegister = true
                        loginRegisterVC.iAmResponseObject = self.iAmResponseObject
                        loginRegisterVC.driverProfileRS = reponspobject.driverProfileRS
                        loginRegisterVC.registratoinObject = self.registratoinObject
                        self.presentViewController?(loginRegisterVC)
                    }
                    
                    
                    
                }
            }
            CustomLoader.customLoaderObj.stopAnimating()
            
        } failure: { response, error in
            
        }
        
        
    }
    
    
    func getDriverProfileee (idNo : String?)  {
        CustomLoader.customLoaderObj.startAnimating()
        
        loginService.getDriverProfile(idNo: idNo) { response in
            if let responseString = response as? String {
                var resultString = responseString.replacingOccurrences(of: "DriverImportRS", with: "DriverProfileRS")
                resultString = resultString.replacingOccurrences(of: "LicenseID", with: "LicenseId")
                if let reponspobject = XMLMapper<DriverProfileRequestMappable>().map(XMLString: resultString) {
                    
                    self.caseForLoginAndRegistrationn(driverProfileRS: reponspobject.driverProfileRS!)
                    
                    
                }
            }
            CustomLoader.customLoaderObj.stopAnimating()
            
        } failure: { response, error in
            
        }
        
        
    }
    
    
    func getDriverProfile(idNo : String?) {
        CustomLoader.customLoaderObj.startAnimating()
        
        loginService.getDriverProfile(idNo: idNo) { response in
            if let responseString = response as? String {
                var resultString = responseString.replacingOccurrences(of: "DriverImportRS", with: "DriverProfileRS")
                resultString = resultString.replacingOccurrences(of: "LicenseID", with: "LicenseId")
                if let reponspobject = XMLMapper<DriverProfileRequestMappable>().map(XMLString: resultString) {
                    if ((reponspobject.driverProfileRS?.success == "Y")  &&  (reponspobject.driverProfileRS?.email != nil) && ( reponspobject.driverProfileRS?.password != nil) && (reponspobject.driverProfileRS?.oTPVerified == "N" || reponspobject.driverProfileRS?.oTPVerified == "Y")) {
                        self.caseForLoginAndRegistrationn(driverProfileRS: reponspobject.driverProfileRS!)
                        self.publicDriverProfileRS = reponspobject.driverProfileRS
                    } else {
                        let loginRegisterVC = LoginRegisterVC.initializeFromStoryboard()
                        loginRegisterVC.isFromRegister = true
                        loginRegisterVC.modalPresentationStyle = .fullScreen
                        loginRegisterVC.iAmResponseObject = self.iAmResponseObject
                        loginRegisterVC.driverProfileRS = reponspobject.driverProfileRS
                        loginRegisterVC.registratoinObject = self.registratoinObject
                        self.presentViewController?(loginRegisterVC)
                    }
                    
                    
                    
                }
            }
            CustomLoader.customLoaderObj.stopAnimating()
            
        } failure: { response, error in
            
        }
        
        
    }
    
    
    func checkIfRegistered(driverProfileRS:DriverProfileRS)->Bool
    {
        if(driverProfileRS.email ?? "" == "")
        {
            return false
        }
        if(driverProfileRS.password ?? "" == "")
        {
            return false
        }
        if(driverProfileRS.oTPVerified ?? "" == "")
        {
            return false
        }
        if(driverProfileRS.FromIAMService ?? "" == "")
        {
            return false
        }
        if(driverProfileRS.oTPVerified ?? "" != "Y")
        {
            return false
        }
        if(driverProfileRS.FromIAMService ?? "" != "Y" && driverProfileRS.FromIAMService ?? "" != "N"  )
        {
            return false
        }
        return true
    }
    
    
    func checkForProfileUpdate(driverProfileRS:DriverProfileRS)-> Bool {
        
        if(driverProfileRS.iDSerialNo != iAmResponseObject?.IDVERSIONNO)
        {
            return false
        }
        if(!self.convertDateAndCompare(dobDateStr: iAmResponseObject?.DOB ?? "", idExpiryDateStr: iAmResponseObject?.IDEXPIRYDATEGREGORIAN ?? "",driverProfileRS: driverProfileRS))
        {
            return false
        }
        return true
    }
    
    
    func convertDateAndCompare(dobDateStr:String,idExpiryDateStr:String,driverProfileRS:DriverProfileRS)-> Bool {
        
        
        if(self.changeDateFormatFromStringUser(stringDate: dobDateStr, formatInput: "YYYYMMDD", formatOutPut: "DD/MM/YYYY") != driverProfileRS.dateOfBirth ?? "")
        {
            return false
        }
        print(self.changeDateFormatFromStringUser(stringDate: idExpiryDateStr, formatInput: "YYYYMMDD", formatOutPut: "DD/MM/YYYY"))
        print(driverProfileRS.dateOfBirth ?? "")
        
        if(self.changeDateFormatFromStringUser(stringDate: idExpiryDateStr, formatInput: "YYYYMMDD", formatOutPut: "DD/MM/YYYY") != driverProfileRS.licenseExpiryDate ?? "")
        {
            return false
        }
        return true
        // print(CommonFunction.changeDateFormat(changeDate: datePicker.date, format: "dd/MM/yyyy hh:mm a"))
    }
    
    func checkForUpdatedriver(driverProfileRS:DriverProfileRS) {
        if checkForProfileUpdate(driverProfileRS: driverProfileRS) {
            self.signInAction(driverProfileRS: driverProfileRS)
        } else {
            self.updateAction(driveProfileObj: publicDriverProfileRS!)
            
        }
        
    }
    
    func caseForLoginAndRegistration(driverProfileRS:DriverProfileRS) {
        if regiterIam ?? false {
            
            if checkForProfileUpdate(driverProfileRS: driverProfileRS) {
                self.signInAction(driverProfileRS: driverProfileRS)
            } else {
                self.updateAction(driveProfileObj: driverProfileRS)
                
            }
            
            
        } else {
            if(checkIfRegistered(driverProfileRS: driverProfileRS))
            {
                
                self.signInAction(driverProfileRS: driverProfileRS)
                
                
                
            } else {
                let loginRegisterVC = LoginRegisterVC.initializeFromStoryboard()
                loginRegisterVC.isFromRegister = true
                loginRegisterVC.modalPresentationStyle = .fullScreen
                loginRegisterVC.iAmResponseObject = self.iAmResponseObject
                loginRegisterVC.registratoinObject = self.registratoinObject
                self.presentViewController?(loginRegisterVC)
                
            }
        }
        
    }
    
    //MARK: Case to determine if user is already registered or not
    //***********************************************//
    func caseForLoginAndRegistrationn(driverProfileRS:DriverProfileRS)
    {
        if(checkIfRegistered(driverProfileRS: driverProfileRS))
        {
            //If User is already Registered
            if(checkForProfileUpdate(driverProfileRS: driverProfileRS))
            {
                self.signInAction(driverProfileRS: driverProfileRS)
                //If profile is already updated
                
            }
            else
            {
                self.updateAction(driveProfileObj: driverProfileRS)
                //If profile is not update
                
            }
            
        }else {
            
            withIAMServiceNormal()
        }
    }
    
    func signInAction(driverProfileRS: DriverProfileRS) {
        loginViewModel.isFromIAM = true
        loginViewModel.login(driverProfileRS.email, password: driverProfileRS.password ?? password )
        
        CachingManager.storedPassword =  driverProfileRS.password
        CachingManager.store(value: driverProfileRS.email, forKey: CachingKeys.email)
        CustomLoader.customLoaderObj.startAnimating()
        
        
    }
    
    func changeDateFormatFromStringUser(stringDate: String ,formatInput: String , formatOutPut : String) -> String
    {
        let arrStr = Array(stringDate)
        let formatted = "\(arrStr[6])\(arrStr[7])/\(arrStr[4])\(arrStr[5])/\(arrStr[0])\(arrStr[1])\(arrStr[2])\(arrStr[3])"
        
        
        return formatted
        
    }
    func setValueForIdType()
    {
        var arrayChar = Array(registratoinObject.idNo!)
        
        
        var idType = String()
        
        switch arrayChar[0] {
        case "1":
            idType = "S"
        case "2":
            idType = "I"
        default:
            idType = "P"
        }
        
        if(!self.specialCharacterNotEnter(txtField: registratoinObject.idNo!) )
        {
            idType = "P"
        }
        if(registratoinObject.idNo!.count != 10 )
        {
            idType = "P"
        }
        
        registratoinObject.idType = idType
        
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
    
    
    //***********************************************//
    //MARK: When user is registered But Profile is not updated
    //***********************************************//
    func updateAction(driveProfileObj : DriverProfileRS)
    {
        let driveProfileObj1 = driveProfileObj
        
        
        
        
        if(driveProfileObj1.licenseDoc == nil)
        {
            driveProfileObj1.licenseDoc = ""
        }
        if(driveProfileObj1.licenseDocExt == nil)
        {
            driveProfileObj1.licenseDocExt = ""
        }
        if(driveProfileObj1.wordIdDoc == nil)
        {
            driveProfileObj1.wordIdDoc = ""
        }
        if(driveProfileObj1.wordIdDocExt == nil)
        {
            driveProfileObj1.wordIdDocExt = ""
        }
        if(driveProfileObj1.operation == nil)
        {
            driveProfileObj1.operation = ""
        }
        if(driveProfileObj1.idDocExt == nil)
        {
            driveProfileObj1.idDocExt = ""
        }
        if(driveProfileObj1.idDoc == nil)
            
        {
            driveProfileObj1.idDoc = ""
            
        }
        if(driveProfileObj1.licenseIssuedBy == nil)
            
        {
            driveProfileObj1.licenseIssuedBy = ""
            
        }
        if(driveProfileObj1.workTel == nil)
            
        {
            driveProfileObj1.workTel = ""
            
        }
        if(driveProfileObj1.homeTel == nil)
            
        {
            driveProfileObj1.homeTel = ""
            
        }
        var membershipNo = ""
        if(driveProfileObj1.membership != nil)
        {
            if(driveProfileObj1.membership?.membershipNo ?? "" == "")
            {
                driveProfileObj1.membership.membershipNo = ""
                membershipNo = ""
            }
            else
            {
                membershipNo = driveProfileObj1.membership.membershipNo
            }
            
        }
        else
        {
            membershipNo =  ""
        }
        if(driveProfileObj1.alfursanID == nil)
            
        {
            //self.driveProfileObj1?.alfursanID = ""
            
        }
        driveProfileObj1.dateOfBirth = self.changeDateFormatFromStringUser(stringDate: iAmResponseObject?.DOB ?? "" ,formatInput: "YYYYMMDD", formatOutPut: "dd/MM/yyyy")
        driveProfileObj1.licenseExpiryDate = self.changeDateFormatFromStringUser(stringDate: iAmResponseObject?.IDEXPIRYDATEGREGORIAN ?? "" ,formatInput: "YYYYMMDD", formatOutPut: "dd/MM/yyyy")
        if iAmResponseObject?.GENDER == "M" {
            driveProfileObj1.gender = "Mr"
        } else if iAmResponseObject?.GENDER == "F"  {
            driveProfileObj1.gender = "M/S"
        }
        driveProfileObj1.idVersion = iAmResponseObject?.IDVERSIONNO
        driveProfileObj1.nationality = iAmResponseObject?.NATIONALITY
      
        
        print(self.changeDateFormatFromStringUser(stringDate: iAmResponseObject?.IDEXPIRYDATEGREGORIAN ?? "" ,formatInput: "YYYYMMDD", formatOutPut: "dd/MM/yyyy"))
        
        
        let soapRequestString = self.registrationUpdateRequest(FirstName: iAmResponseObject?.AR_FIRSTNAME ?? "",
                                                               LastName: iAmResponseObject?.AR_FAMILYNAME ?? "",
                                                               dateOfBirth:  driveProfileObj1.dateOfBirth ?? "",
                                                               nationality: driveProfileObj1.nationality ?? "",
                                                               licenseId: iAmResponseObject?.USERID ?? "",
                                                               licenseIssuedBy: driveProfileObj1.licenseIssuedBy ?? "",
                                                               LicenseExpiryDate: driveProfileObj1.licenseExpiryDate ?? "",
                                                               LicenseDoc: driveProfileObj1.licenseDoc ?? "",
                                                               LicenseDocFileExt: driveProfileObj1.licenseDocExt ?? "",
                                                               Address1: driveProfileObj1.address1 ?? "",
                                                               Address2:  driveProfileObj1.address2 ?? "",
                                                               HomeTel: driveProfileObj1.homeTel ?? "",
                                                               WorkTel: driveProfileObj1.workTel ?? "",
                                                               Mobile: mobileNumber ?? "",
                                                               Email: driveProfileObj1.email ?? "",
                                                               IdType:  driveProfileObj1.idType ?? "",
                                                               IdNo: iAmResponseObject?.USERID ?? "",
                                                               IdDoc: driveProfileObj1.idDoc ?? "",
                                                               IdDocFileExt: driveProfileObj1.idDocExt ?? "",
                                                               MembershipNo: membershipNo,
                                                               Operation: driveProfileObj1.operation ?? "",
                                                               Password: password,
                                                               IDSerialNo:  driveProfileObj1.idVersion ?? "",
                                                               WorkIdDoc: driveProfileObj1.wordIdDoc ?? "",
                                                               WorkIdDocFileExt: driveProfileObj1.wordIdDocExt ?? "",
                                                               DriverImage: driveProfileObj1.driverImage ?? "",
                                                               DriverImageFileExt:  driveProfileObj1.driverImageExt ?? "",
                                                               gender: driveProfileObj1.gender ?? "",
                                                               FromIAMService: "Y",
                                                               ArabicName: iAmResponseObject?.ENG_NAME ?? "",
                                                               PassLicExpDate:  driveProfileObj1.licenseExpiryDate,
                                                               password: driveProfileObj1.password, title: driveProfileObj1.gender ?? "")
        
        
        
        loginService.registerNewCustomer( soapXmlString: soapRequestString, fromIam: true) { [self] response in
            
            guard let response = response as? String else {return}
            
            
            if let updateResponseModel = XMLMapper<DriverUpdateMappable>().map(XMLString: response) {
                
                
                if updateResponseModel.success == "Y" {
                    loginViewModel.isFromIAM = true
                    self.loginViewModel.login(driveProfileObj1.email ?? "", password: driveProfileObj1.password)
                    CachingManager.storedPassword = driveProfileObj1.password
                    CachingManager.store(value:driveProfileObj1.email, forKey: CachingKeys.email)
                }
            }
            
            
            
            
            
        } failure: { response, error in
            
        }
        //
        //        //        userServices.driverProfileUpdate(callback: requestCallBackUPDATE, soapAction: MethodAction.driverProfile.rawValue, soapString: soapRequestString!)
        //        CustomLoader.customLoaderObj.startAnimating()
    }
    func registrationUpdateRequest(FirstName:String?,LastName:String?,dateOfBirth:String?,nationality:String?,licenseId:String?,licenseIssuedBy:String?,LicenseExpiryDate:String?,LicenseDoc:String?,LicenseDocFileExt:String?,Address1:String?,Address2:String?,HomeTel:String? ,WorkTel:String? ,Mobile:String?,Email:String?,IdType:String?,IdNo:String?,IdDoc:String?,IdDocFileExt:String?,MembershipNo:String?,Operation:String?,Password:String?,IDSerialNo :String?,WorkIdDoc :String?,WorkIdDocFileExt :String?,DriverImage :String?,DriverImageFileExt :String?,gender:String?,FromIAMService:String?,ArabicName:String?,PassLicExpDate:String?,password:String?, title: String?) -> String?
    {
        
        return  "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:DriverImportRQ xmlns:m=\"CarProDriver\"><m:LastName>\(LastName ?? "")</m:LastName><m:FirstName>\(FirstName!)</m:FirstName><m:DateOfBirth>\(dateOfBirth ?? "")</m:DateOfBirth><m:Nationality>\(nationality!)</m:Nationality><m:LicenseId>\(licenseId ?? "")</m:LicenseId><m:LicenseIssuedBy>\(licenseIssuedBy ?? "")</m:LicenseIssuedBy><m:LicenseExpiryDate>\(LicenseExpiryDate ?? "")</m:LicenseExpiryDate><m:LicenseDoc>\(LicenseDoc ?? "" )</m:LicenseDoc><m:LicenseDocFileExt>\(LicenseDocFileExt ?? "")</m:LicenseDocFileExt><m:Address1>\(Address1 ?? "")</m:Address1><m:Gender>\(gender ?? "")</m:Gender> <m:Title>\(title ?? "")</m:Title><m:Address2>\(Address2!)</m:Address2><m:HomeTel>\(HomeTel  ?? "")</m:HomeTel><m:WorkTel>\(WorkTel!)</m:WorkTel><m:Mobile>\(Mobile ?? "")</m:Mobile><m:Email>\(Email ?? "")</m:Email><m:IdType>\(IdType ?? "")</m:IdType><m:IdNo>\(IdNo!)</m:IdNo><m:IdDoc>\(IdDoc!)</m:IdDoc><m:IdDocFileExt>\(IdDocFileExt!)</m:IdDocFileExt><m:MembershipNo>\(MembershipNo!)</m:MembershipNo><m:Operation></m:Operation><m:IDSerialNo>\(IDSerialNo!)</m:IDSerialNo><m:WorkIdDoc>\(WorkIdDoc!)</m:WorkIdDoc><m:WorkIdDocFileExt>\(WorkIdDocFileExt!)</m:WorkIdDocFileExt><m:DriverImage>\(DriverImage!)</m:DriverImage><m:DriverImageFileExt>\(DriverImageFileExt!)</m:DriverImageFileExt><FromIAMService>\(FromIAMService ?? "")</FromIAMService><ArabicName>\(ArabicName ?? "")</ArabicName><PassLicExpDate>\(PassLicExpDate ?? "")</PassLicExpDate><Password>\(password ?? "")</Password></m:DriverImportRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
        
    }
    
    func registrationUpdateRequestProfile(FirstName:String?,LastName:String?,dateOfBirth:String?,nationality:String?,licenseId:String?,licenseIssuedBy:String?,LicenseExpiryDate:String?,LicenseDoc:String?,LicenseDocFileExt:String?,Address1:String?,Address2:String?,HomeTel:String? ,WorkTel:String? ,Mobile:String?,Email:String?,IdType:String?,IdNo:String?,IdDoc:String?,IdDocFileExt:String?,MembershipNo:String?,Operation:String?,Password:String?,IDSerialNo :String?,WorkIdDoc :String?,WorkIdDocFileExt :String?,DriverImage :String?,DriverImageFileExt :String?,gender:String?,alphursanId : String?, fromIAMService : String?) -> String? {
        
        return  "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:DriverImportRQ xmlns:m=\"CarProDriver\"><m:LastName>\(LastName!)</m:LastName><m:FirstName>\(FirstName!)</m:FirstName><m:DateOfBirth>\(dateOfBirth!)</m:DateOfBirth><m:Nationality>\(nationality!)</m:Nationality><m:LicenseId>\(licenseId!)</m:LicenseId><m:LicenseIssuedBy>\(licenseIssuedBy!)</m:LicenseIssuedBy><m:LicenseExpiryDate>\(LicenseExpiryDate!)</m:LicenseExpiryDate><m:LicenseDoc>\(LicenseDoc!)</m:LicenseDoc><m:LicenseDocFileExt>\(LicenseDocFileExt!)</m:LicenseDocFileExt><m:Address1>\(Address1!)</m:Address1><m:Gender>\(gender!)</m:Gender><m:Address2>\(Address2!)</m:Address2><m:HomeTel>\(HomeTel!)</m:HomeTel><m:WorkTel>\(WorkTel!)</m:WorkTel><m:Mobile>\(Mobile!)</m:Mobile><m:Email>\(Email!)</m:Email><m:IdType>\(IdType!)</m:IdType><m:IdNo>\(IdNo!)</m:IdNo><m:IdDoc>\(IdDoc!)</m:IdDoc><m:IdDocFileExt>\(IdDocFileExt!)</m:IdDocFileExt><m:MembershipNo>\(MembershipNo!)</m:MembershipNo><m:Operation></m:Operation><m:IDSerialNo>\(IDSerialNo!)</m:IDSerialNo><m:WorkIdDoc>\(WorkIdDoc!)</m:WorkIdDoc><m:WorkIdDocFileExt>\(WorkIdDocFileExt!)</m:WorkIdDocFileExt><m:DriverImage>\(DriverImage!)</m:DriverImage><m:DriverImageFileExt>\(DriverImageFileExt!)</m:DriverImageFileExt><m:AlfursanID>\(alphursanId ?? "")</m:AlfursanID><FromIAMService>\(fromIAMService ?? "")</FromIAMService></m:DriverImportRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
        
    }
    
    
    
}

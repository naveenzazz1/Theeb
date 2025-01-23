//
//  LoginRegisterService.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 24/04/1443 AH.
//

import Foundation


class LoginRegisterService  {

    
    func login(email : String? ,
               password: String?,
               success: APISuccess,
               failure: APIFailure) {
        
        
        NetworkManager.manager.request(soapAction: SOAPACTIONS.signin, xmlString: self.loginRequestXmlString(email: email, password: password), url: BaseURL.production,success: success, failure: failure)
        
    }
    
    func registerNewCustomer(email: String? = nil,
                             firstName: String? = nil ,
                             lastName: String? = nil ,
                             idNumber:String? = nil,
                             phoneNumer: String? = nil,
                             password: String? = nil,
                             idType: String? = nil,
                             soapXmlString : String? = nil,
                             fromIam: Bool? = false ,
                             success: APISuccess,
                             failure: APIFailure) {
        if fromIam ?? false {
            NetworkManager.manager.request(soapAction: SOAPACTIONS.driverProfile, xmlString:  soapXmlString , url: BaseURL.production, success: success, failure: failure)
            
        }else {
            NetworkManager.manager.request(soapAction: SOAPACTIONS.driverProfile, xmlString: self.registrationRequestXmlString(firstName: firstName, lastName: lastName, mobile: phoneNumer, email: email,idType: idType, idNo: idNumber) ?? soapXmlString , url: BaseURL.production, success: success, failure: failure)
           
        }
        
        
    }
    
    func loginWithIAMService(idNo : String?,
                             success: APISuccess,
                             failure: APIFailure) {
        
        NetworkManager.manager.request(soapAction: SOAPACTIONS.IAMServiceGetDataWS, xmlString: self.IAMServiceWSRQString(id: idNo), url: BaseURL.production, success: success, failure: failure)
        
        
        
    }
    
  
    func loginRequestXmlString(email: String?,password: String?) -> String? {
      
        let xmlString =  "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:car=\"CarProUserLogin\"><soapenv:Header/><soapenv:Body><car:LoginRQ><car:UserName>\(email ?? "")</car:UserName><car:Password>\(password ?? "")</car:Password></car:LoginRQ></soapenv:Body></soapenv:Envelope>"
      

       return xmlString
   }
    
    func iamServiceXMLString( success: APISuccess,
                              failure: APIFailure) {
        
        NetworkManager.manager.request(soapAction: SOAPACTIONS.IAMServiceWS, xmlString: self.IAMServiceWSXMLString(), url: BaseURL.production, success: success, failure: failure)
    }
    
    func getDriverProfile(idNo : String?,
                          success: APISuccess,
                        failure: APIFailure) {
        
        NetworkManager.manager.request(soapAction: SOAPACTIONS.driverProfile, xmlString: self.driverProfileGet(idNumber: idNo) ,url: BaseURL.production, success: success, failure: failure)
        
    }
    
     func registrationRequestXmlString(firstName:String? = nil,
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
                                       password:String? = nil) -> String?
    {
        
        return  "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:DriverImportRQ xmlns:m=\"CarProDriver\"><m:LastName>\(lastName ?? "")</m:LastName><m:FirstName>\(firstName ?? "")</m:FirstName><m:DateOfBirth>\(dateOfBirth ?? "")</m:DateOfBirth><m:Nationality>\(nationality ?? "")</m:Nationality><m:LicenseId>\(idNo ?? "")</m:LicenseId><m:LicenseIssuedBy>\(licenseIssuedBy ?? "")</m:LicenseIssuedBy><m:LicenseExpiryDate>\(licenseExpiryDate ?? "")</m:LicenseExpiryDate><m:LicenseDoc>\(licenseDoc ?? "")</m:LicenseDoc><m:LicenseDocFileExt>\(licenseDocFileExt ?? "")</m:LicenseDocFileExt><m:Address1>\(address1 ?? "")</m:Address1><m:Gender>\(gender ?? "")</m:Gender><m:Address2>\(address2 ?? "")</m:Address2><m:HomeTel>\(homeTel ?? "")</m:HomeTel><m:WorkTel>\(workTel ?? "")</m:WorkTel><m:Mobile>\(mobile ?? "")</m:Mobile><m:Email>\(email ?? "")</m:Email><m:IdType>\(idType ?? "")</m:IdType><m:IdNo>\(idNo ?? "")</m:IdNo><m:IdDoc>\(idDoc ?? "")</m:IdDoc><m:IdDocFileExt>\(idDocFileExt ?? "")</m:IdDocFileExt><m:MembershipNo>\(membershipNo ?? "")</m:MembershipNo><m:Operation></m:Operation><m:IDSerialNo>\(iDSerialNo ?? "")</m:IDSerialNo><m:WorkIdDoc>\(workIdDoc ?? "")</m:WorkIdDoc><m:WorkIdDocFileExt>\(workIdDocFileExt ?? "")</m:WorkIdDocFileExt><m:DriverImage>\(driverImage ?? "")</m:DriverImage><m:DriverImageFileExt>\(driverImageFileExt  ?? "")</m:DriverImageFileExt><FromIAMService>\(fomIAMService ?? "")</FromIAMService><ArabicName>\(arabicName ?? "")</ArabicName><PassLicExpDate>\(passLicExpDate ?? "")</PassLicExpDate><Password>\(password ?? "")</Password></m:DriverImportRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
      
    }
    
    
     func IAMServiceWSRQString(id:String?)->String {
        
        let xmlString = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:iam=\"IAMServiceGetDataRQ\"><soapenv:Header/><soapenv:Body><iam:IAMServiceGetDataRQ><iam:userid></iam:userid><iam:idVersionNo></iam:idVersionNo><iam:driverCode></iam:driverCode><iam:autoGenKey>\(id ?? "")</iam:autoGenKey></iam:IAMServiceGetDataRQ></soapenv:Body></soapenv:Envelope>"
      
        
        
        return xmlString
    }
    
     func driverProfileGet(idNumber: String?) -> String? {
        let xmlString = "<?xml version=\"1.0\" encoding=\"us-ascii\" ?><SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Body><m:DriverImportRQ xmlns:m=\"CarProDriver\"><m:LastName>String</m:LastName><m:FirstName>String</m:FirstName><m:DateOfBirth>String</m:DateOfBirth><m:LicenseId>String</m:LicenseId><m:LicenseIssuedBy>String</m:LicenseIssuedBy><m:LicenseExpiryDate>String</m:LicenseExpiryDate><m:LicenseDoc>String</m:LicenseDoc><m:Address1>String</m:Address1><m:Address2>String</m:Address2><m:HomeTel>String</m:HomeTel><m:WorkTel>String</m:WorkTel><m:Mobile>String</m:Mobile><m:Email>String</m:Email><m:IdType>String</m:IdType><m:IdNo>\(idNumber ?? "")</m:IdNo><m:IdDoc></m:IdDoc><m:MembershipNo>String</m:MembershipNo><m:Operation>V</m:Operation><m:Password>String</m:Password></m:DriverImportRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
        return xmlString
    }
    
     func IAMServiceWSXMLString() -> String?
    {
        let startMiliSecond = "\(Date().millisecondsSince1970/1000)"
   
        let language = "Ar"
        let random = DateUtils.randomAlphaNumericString(length: 32)
        DateUtils.getIdForUserIAM(bool: nil, str: "\(random)")
        UserDefaults.standard.setValue(random, forKey: "iAMKey")
        let xmlString =  "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:iam=\"IAMServiceRQ\"><soapenv:Header/><soapenv:Body><iam:IAMServiceRQ><iam:autoGenKey>\(random)</iam:autoGenKey><iam:epochTime>\(startMiliSecond)</iam:epochTime><iam:langCode>\(language)</iam:langCode></iam:IAMServiceRQ></soapenv:Body></soapenv:Envelope>"
        
      
        return xmlString

    }
    
    
    class func registrationUpdateRequest(FirstName:String?,LastName:String?,dateOfBirth:String?,nationality:String?,licenseId:String?,licenseIssuedBy:String?,LicenseExpiryDate:String?,LicenseDoc:String?,LicenseDocFileExt:String?,Address1:String?,Address2:String?,HomeTel:String? ,WorkTel:String? ,Mobile:String?,Email:String?,IdType:String?,IdNo:String?,IdDoc:String?,IdDocFileExt:String?,MembershipNo:String?,Operation:String?,Password:String?,IDSerialNo :String?,WorkIdDoc :String?,WorkIdDocFileExt :String?,DriverImage :String?,DriverImageFileExt :String?,gender:String?,FromIAMService:String?,ArabicName:String?,PassLicExpDate:String?,password:String?,  title: String?) -> String? {
        

        return  "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:DriverImportRQ xmlns:m=\"CarProDriver\"><m:LastName>\(LastName!)</m:LastName><m:FirstName>\(FirstName!)</m:FirstName><m:DateOfBirth>\(dateOfBirth!)</m:DateOfBirth><m:Nationality>\(nationality!)</m:Nationality><m:LicenseId>\(licenseId!)</m:LicenseId><m:LicenseIssuedBy>\(licenseIssuedBy!)</m:LicenseIssuedBy><m:LicenseExpiryDate>\(LicenseExpiryDate!)</m:LicenseExpiryDate><m:LicenseDoc>\(LicenseDoc!)</m:LicenseDoc><m:LicenseDocFileExt>\(LicenseDocFileExt!)</m:LicenseDocFileExt>   <Title>\(title ?? "")</Title><m:Address1>\(Address1!)</m:Address1><m:Gender>\(gender!)</m:Gender><m:Address2>\(Address2!)</m:Address2><m:HomeTel>\(HomeTel!)</m:HomeTel><m:WorkTel>\(WorkTel!)</m:WorkTel><m:Mobile>\(Mobile!)</m:Mobile><m:Email>\(Email!)</m:Email><m:IdType>\(IdType!)</m:IdType><m:IdNo>\(IdNo!)</m:IdNo><m:IdDoc>\(IdDoc!)</m:IdDoc><m:IdDocFileExt>\(IdDocFileExt!)</m:IdDocFileExt><m:MembershipNo>\(MembershipNo!)</m:MembershipNo><m:Operation></m:Operation><m:IDSerialNo>\(IDSerialNo!)</m:IDSerialNo><m:WorkIdDoc>\(WorkIdDoc!)</m:WorkIdDoc><m:WorkIdDocFileExt>\(WorkIdDocFileExt!)</m:WorkIdDocFileExt><m:DriverImage>\(DriverImage!)</m:DriverImage><m:DriverImageFileExt>\(DriverImageFileExt!)</m:DriverImageFileExt><FromIAMService>\(FromIAMService ?? "")</FromIAMService><ArabicName>\(ArabicName ?? "")</ArabicName><PassLicExpDate>\(PassLicExpDate ?? "")</PassLicExpDate><Password>\(password ?? "")</Password></m:DriverImportRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
        
       
    }
    
    
}




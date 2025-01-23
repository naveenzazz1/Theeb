//
//  ViewProfileService.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 13/03/2022.
//

import Foundation

class ViewProfileService{
    
    func updateProfile(firstName:String? = nil,
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
                       password:String? = nil,
                       alfursanID:String? = nil,
                            success: APISuccess,
                            failure: APIFailure) {
        
        NetworkManager.manager.request(soapAction: SOAPACTIONS.driverProfile, xmlString: updateRequestXmlString(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, nationality: nationality, licenseId: licenseId, licenseIssuedBy: licenseIssuedBy, licenseExpiryDate: licenseExpiryDate, licenseDoc: licenseDoc, licenseDocFileExt: licenseDocFileExt, address1: address1, address2: address2, homeTel: homeTel, workTel: workTel, mobile: mobile, email: email, idType: idType, idNo: idNo, idDoc: idDoc, idDocFileExt: idDocFileExt, membershipNo: membershipNo, operation: operation, iDSerialNo: iDSerialNo, workIdDoc: workIdDoc, workIdDocFileExt: workIdDocFileExt, driverImage: driverImage, driverImageFileExt: driverImageFileExt, gender: gender, fomIAMService:fomIAMService , arabicName: arabicName, passLicExpDate: passLicExpDate, password: password, alfursanID: alfursanID), url: BaseURL.production,success: success, failure: failure)
        
    }

   func updateRequestXmlString(firstName:String? = nil,
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
                                      password:String? = nil,
                                      alfursanID:String?) -> String?  {
    return  "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:DriverImportRQ xmlns:m=\"CarProDriver\"><m:LastName>\(lastName ?? "")</m:LastName><m:FirstName>\(firstName ?? "")</m:FirstName><m:DateOfBirth>\(dateOfBirth ?? "")</m:DateOfBirth><m:Nationality>\(nationality ?? "")</m:Nationality><m:LicenseId>\(licenseId ?? "")</m:LicenseId><m:LicenseIssuedBy>\(licenseIssuedBy ?? "")</m:LicenseIssuedBy><m:LicenseExpiryDate>\(licenseExpiryDate ?? "")</m:LicenseExpiryDate><m:LicenseDoc>\(licenseDoc ?? "")</m:LicenseDoc><m:LicenseDocFileExt>\(licenseDocFileExt ?? "")</m:LicenseDocFileExt><m:Address1>\(address1 ?? "")</m:Address1><m:Gender>\(gender ?? "")</m:Gender><m:AlfursanID>\(alfursanID ?? "")</m:AlfursanID><m:Address2>\(address2 ?? "")</m:Address2><m:HomeTel>\(homeTel ?? "")</m:HomeTel><m:WorkTel>\(workTel ?? "")</m:WorkTel><m:IdType>\(idType ?? "")</m:IdType><m:IdNo>\(idNo ?? "")</m:IdNo><m:IdDoc>\(idDoc ?? "")</m:IdDoc><m:IdDocFileExt>\(idDocFileExt ?? "")</m:IdDocFileExt><m:MembershipNo>\(membershipNo ?? "")</m:MembershipNo><m:Operation>\(operation ?? "U")</m:Operation><m:IDSerialNo>\(iDSerialNo ?? "")</m:IDSerialNo><m:WorkIdDoc>\(workIdDoc ?? "")</m:WorkIdDoc><m:WorkIdDocFileExt>\(workIdDocFileExt ?? "")</m:WorkIdDocFileExt><m:DriverImage>\(driverImage ?? "")</m:DriverImage><m:DriverImageFileExt>\(driverImageFileExt ?? "")</m:DriverImageFileExt><FromIAMService>\(fomIAMService ?? "")</FromIAMService><ArabicName>\(arabicName ?? "")</ArabicName><PassLicExpDate>\(passLicExpDate ?? "")</PassLicExpDate><Password>\(password ?? "")</Password></m:DriverImportRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
       

}


}

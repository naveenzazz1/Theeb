//
//  MyAccountItem.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 12/06/1443 AH.
//

import Foundation
import UIKit
import XMLMapper


struct  MyAccountItem {
    var name: String?
    var shouldShow: Bool
    var action: (()-> Void)?
    var itemFont =  UIFont.montserratSemiBold(fontSize: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
    var itemColor =  UIColor.menuItemColor
    var itemImage : UIImage?
}

struct  MySettingItem {
    var name: String?
    var sgmntElemnts: (String?,String?,String?)?
    var action: ((_ sgmnt:UIControl?)-> Void)?
    var itemFont =  UIFont.montserratSemiBold(fontSize: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
    var itemColor =  UIColor.menuItemColor
    var itemImage : UIImage?
}

class MemberMappable:  XMLMappable {
  
    var nodeName: String!
    var memberDriverModel : MemberDriverModel?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        memberDriverModel <- map["SOAP-ENV:Body.DriverProfileRS"]
    }
    
    
}

class MemberDriverModel:XMLMappable,Codable{
    var nodeName: String!
    
    var name: String!
    var firstName : String!
    var lastName : String!
    var nationality : String!
    var nationalityAR : String!
    var mobileNo : String!
    var iD : String!
    var iDVersion : String!
    var licenseExpiry : String!
    var licenseID : String!
    var password: String!
    var memberShip:MemberShip!
    var loyality:Loyality!
    var dateOfBirth : String!
    var licenseIssuedBy : String!
    var address1 : String!
    var address2 : String!
    var homeTel:String!
    var workTel:String!
    var email : String!
    var iDType : String!
    var success : String!
    var licenseDoc:String!
    var licenseDocExt:String!
    var idDoc:String!
    var idDocExt:String!
    var workIdDoc:String!
    var workIdDocExt:String!
    var driverImage:String!
    var driverImageExt:String?
    var title:String?
    var gender:String?
    var billingName:String?
    var stopList:String?
    var applicantCode:String?
    var applicantStatus:String?
    var arabicName:String?
    var fromIAMService:String?
    var alfursanID:String?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        success <- map["Success"]
        lastName <- map["LastName"]
        firstName <- map["FirstName"]
        email <- map["Email"]
        mobileNo <- map["MobileNo"]
        licenseID <- map["LicenseID"]
        iDType <- map["IdType"]
        iD <- map["ID"]
        password <- map["password"];
        driverImage <- map["DriverImage"]
        dateOfBirth <- map["DateOfBirth"]
        licenseExpiry <- map["LicenseExpiry"]
        nationality <- map["NationalityEN"]
        iDVersion <- map["IDVersion"]
        
        workIdDoc <- map["WorkIdDoc"]
        workIdDocExt <- map["WorkIdDocExt"]
        homeTel <- map["HomeTel"]
        workTel <- map["WorkTel"]
        licenseDoc <- map["LicenseDoc"]
        licenseDocExt <- map["LicenseDocExt"]
        licenseIssuedBy <- map["LicenseIssuedBy"]
        address1 <- map["Address1"]
        address2 <- map["Address2"]
        idDoc <- map["IdDoc"]
        idDocExt <- map["IdDocExt"]
        nationalityAR <- map["NationalityAR"]
        name <- map["Name"]
        memberShip <- map["Membership"]
        loyality <- map["Loyality"]
        driverImageExt <- map["DriverImageExt"]
        title <- map["Title"]
        gender <- map["Gender"]
        billingName <- map["BillingName"]
        stopList <- map["StopList"]
        applicantCode <- map["ApplicantCode"]
        applicantCode <- map["ApplicantCode"]
        arabicName <- map["ArabicName"]
        fromIAMService <- map["FromIAMService"]
        alfursanID <- map["AlfursanID"]
    }
    
    
}

class MemberShip:XMLMappable,Codable{
    var nodeName: String!
    var membershipNo: String!
    var status: String!
    var cardType: String!
    var issueDate: String!
    var expiryDate: String!
    var cardTypeEng:String?
    var freeKm:String?
    var extraHours:String?
    
    required init(map: XMLMap) {
    }
    
    func mapping(map: XMLMap) {
        membershipNo <- map["MembershipNo"]
        status <- map["Status"]
        cardType <- map["CardType"]
        expiryDate <- map["ExpiryDate"]
        issueDate <- map["IssueDate"]
        cardTypeEng <- map["CardTypeEng"]
        freeKm <- map["FreeKM"]
        extraHours <- map["ExtraHours"]
    }
}

class Loyality:XMLMappable,Codable{
    var nodeName: String!
    var totalPoints: String!
    var usedPoints: String!
    var lastUsed: String!
    var balancePoints: String!
    
    required init(map: XMLMap) {
    }
    
    func mapping(map: XMLMap) {
        totalPoints <- map["TotalPoints"]
        usedPoints <- map["UsedPoints"]
        lastUsed <- map["LastUsed"]
        balancePoints <- map["BalancePoints"]
    }
}


class DeleteAccountModel: BaseModel, XMLMappable {

    var nodeName: String!
    var success : String?
    var varianceReason : String?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        success <- map["SOAP-ENV:Body.DriverStatusRS.Success"]
        varianceReason <- map["SOAP-ENV:Body.DriverStatusRS.VarianceReason"]
        
    }
    
    
}

// NEW RESPONSE

struct DeleteAccountResponseModel: Codable {
    var DriverStatusRS: DriverStatusRS?
}

struct DriverStatusRS: Codable {
    var Success: String?
    var VarianceReason: String?
}
/*
 <Name>Mudassar Ali</Name>

   <FirstName>Mudassar</FirstName>

   <LastName>Ali</LastName>

   <Nationality>Pakistan</Nationality>

   <NationalityAR></NationalityAR>

   <ID>2329321174</ID>

   <IDVersion>0</IDVersion>

   <MobileNo>0553178581</MobileNo>

   <LicenseID>2329321174</LicenseID>

   <LicenseExpiryDate>29/08/2021</LicenseExpiryDate>

   <Password>It2722011</Password>

   <Membership>
     <MembershipNo>100911232</MembershipNo>
     <Status>Valid</Status>
     <CardType>فضية</CardType>
     <IssueDate>16/03/2022</IssueDate>
     <ExpiryDate>16/03/2024</ExpiryDate>
   </Membership>

   <Loyality>
     <TotalPoints>0</TotalPoints>
     <UsedPoints>0</UsedPoints>
     <LastUsed>15/03/2022 , 50 , 2227</LastUsed>
     <BalancePoints>0</BalancePoints>
   </Loyality>

   <DateOfBirth>11/01/1986</DateOfBirth>

   <LicenseIssuedBy>Ksa</LicenseIssuedBy>

   <Address1>xxxx</Address1>

   <Address2>xxxx</Address2>

   <HomeTel></HomeTel>

   <WorkTel></WorkTel>

   <Email>mudassar@theeb.sa</Email>

   <IdType>I</IdType>

   <Success>Y</Success>

   <LicenseDoc></LicenseDoc>

   <LicenseDocExt></LicenseDocExt>

   <IdDoc></IdDoc>

   <IdDocExt></IdDocExt>

   <WorkIdDoc></WorkIdDoc>

   <WorkIdDocExt></WorkIdDocExt>

   <DriverImage>
 */

//
//  DriverUpdateModel.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 14/03/2022.
//

import Foundation
import XMLMapper


class DriverUpdateModel:XMLMappable {
    var nodeName: String!
    var success, driverCode: String!
    
    required init(map: XMLMap) {
    }
    
    func mapping(map: XMLMap) {
        success <- map["SOAP-ENV:Body.DriverImportRS.Success"]
        driverCode <- map["SOAP-ENV:Body.DriverImportRS.DriverCode"]
    }
}


class TheebDriverSetModel : XMLMappable {
    var nodeName: String!
    var lastName : String!
    var firstName : String!
    var dateOfBirth : String!
    var nationality: String!
    var licenseId : String!
    var licenseIssuedBy : String!
    var licenseExpiryDate : String!
    var licenseDoc : String!
    var address1 : String!
    var address2 : String!
    var homeTel : String!
    var workTel : String!
    var mobile : String!
    var email : String!
    var idType : String!
    var idNo : String!
    var idDoc : String!
    var membershipNo : String!
    var operation : String!
    var password: String!
    var iDSerialNO : String?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        lastName <- map["LastName"]
        firstName <- map["FirstName"]
        dateOfBirth <- map["DateOfBirth"]
        nationality <- map["Nationality"]
        licenseId <- map["LicenseId"]
        licenseIssuedBy <- map["LicenseIssuedBy"]
        licenseExpiryDate <- map["LicenseExpiryDate"]
        licenseDoc <- map["LicenseDoc"]
        address1 <- map["Address1"]
        address2 <- map["Address2"]
        homeTel <- map["HomeTel"]
        workTel <- map["WorkTel"]
        mobile <- map["Mobile"]
        email <- map["Email"]
        idNo <- map["IdNo"]
        idType <- map["IdType"]
        idDoc <- map["IdDoc"]
        membershipNo <- map["MembershipNo"]
        operation <- map["Operation"]
        password <- map["Password"]
        iDSerialNO <- map["IDSerialNo"]
        
    }
    
}

//
//  YaqeenModel.swift
//  Theeb Rent A Car App
//
//  Created by ahmed elshobary on 15/04/2024.
//

import Foundation

struct YaqeenResponseModel: Codable {
    var driverImportRS: YaqeenDriverImportRS?
    
    enum CodingKeys: String, CodingKey {
        case driverImportRS = "DriverImportRS"
    }
}

struct YaqeenDriverImportRS: Codable {
    var success: String?
    var arabicName: String?
    var driverCode: String?
    var lastName: String?
    var firstName: String?
    var dateOfBirth: String?
    var nationality: String?
    var licenseId: String?
    var licenseIssuedBy: String?
    var licIssueDate: String?
    var licenseExpiryDate: String?
    var licenseDoc: [String]?
    var address1: String?
    var address2: String?
    var homeTel: String?
    var workTel: String?
    var mobile: String?
    var email: String?
    var idType: String?
    var idNo: String?
    var idIssueDate: String?
    var idExpiryDate: String?
    var idDoc: [String]?
    var membershipNo: String?
    var idSerialNo: String?
    var password: String?
    var status: String?
    var licenseDocExt: String?
    var idDocExt: String?
    var workIdDocExt: String?
    var driverImageExt: String?
    var otpVerified: String?
    var gender: String?
    var title: String?
    var billingName: String?
    var stopList: String?
    var applicantCode: String?
    var applicantStatus: String?
    var varianceReason: String?
    var operation: String?
    var contactCity: String?
    var postalCode: String?
    var province: String?
    var country: String?
    var workIdDoc: String?
    var driverImage: String?
    var isYakeenCalled: Bool?
    var yakeenResponseStatus: Bool?
    var yakeenResponseDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case arabicName = "ArabicName"
        case driverCode = "DriverCode"
        case lastName = "LastName"
        case firstName = "FirstName"
        case dateOfBirth = "DateOfBirth"
        case nationality = "Nationality"
        case licenseId = "LicenseId"
        case licenseIssuedBy = "LicenseIssuedBy"
        case licIssueDate = "LicIssueDate"
        case licenseExpiryDate = "LicenseExpiryDate"
        case licenseDoc = "LicenseDoc"
        case address1 = "Address1"
        case address2 = "Address2"
        case homeTel = "HomeTel"
        case workTel = "WorkTel"
        case mobile = "Mobile"
        case email = "Email"
        case idType = "IdType"
        case idNo = "IdNo"
        case idIssueDate = "IDIssueDate"
        case idExpiryDate = "IDExpiryDate"
        case idDoc = "IdDoc"
        case membershipNo = "MembershipNo"
        case idSerialNo = "IDSerialNo"
        case password = "Password"
        case status = "Status"
        case licenseDocExt = "LicenseDocExt"
        case idDocExt = "IdDocExt"
        case workIdDocExt = "WorkIdDocExt"
        case driverImageExt = "DriverImageExt"
        case otpVerified = "OTPVerified"
        case gender = "Gender"
        case title = "Title"
        case billingName = "BillingName"
        case stopList = "StopList"
        case applicantCode = "ApplicantCode"
        case applicantStatus = "ApplicantStatus"
        case varianceReason = "VarianceReason"
        case operation = "Operation"
        case contactCity = "ContactCity"
        case postalCode = "PostalCode"
        case province = "Province"
        case country = "Country"
        case workIdDoc = "WorkIdDoc"
        case driverImage = "DriverImage"
        case isYakeenCalled = "IsYakeenCalled"
        case yakeenResponseStatus = "YakeenResponseStatus"
        case yakeenResponseDescription = "YakeenResponseDescription"
    }
}

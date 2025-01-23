//
//  AgreementRentalModal.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 11/08/2023.
//

import Foundation

struct AgreementRentalModal : Codable {
    let transactionRS : TransactionRSAgreement?

    enum CodingKeys: String, CodingKey {

        case transactionRS = "TransactionRS"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionRS = try values.decodeIfPresent(TransactionRSAgreement.self, forKey: .transactionRS)
    }

}

struct TransactionRSAgreement : Codable {
    let success : String?
    let agreements : Agreements?

    enum CodingKeys: String, CodingKey {

        case success = "Success"
        case agreements = "Agreements"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(String.self, forKey: .success)
        agreements = try values.decodeIfPresent(Agreements.self, forKey: .agreements)
    }

}

struct Agreements : Codable {
    let h1 : String?
    let h2 : String?
    let agreement : [Agreement]?

    enum CodingKeys: String, CodingKey {

        case h1 = "H1"
        case h2 = "H2"
        case agreement = "Agreement"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        h1 = try values.decodeIfPresent(String.self, forKey: .h1)
        h2 = try values.decodeIfPresent(String.self, forKey: .h2)
        agreement = try values.decodeIfPresent([Agreement].self, forKey: .agreement)
    }

}

struct Agreement : Codable {
    let checkOutBranch : String?
    let checkInBranch : String?
    let checkOutDate : String?
    let checkInDate : String?
    let reservationNo : String?
    let statusCode : String?
    let agreementNo : String?
    let chrageGroup : String?
    let licenseNo : String?
    let tOTALAMOUNT : String?
    let tOTALPAID : String?
    let tOTALBALANCE : String?
    let checkOutBranchContact : String?
    let checkInBranchContact : String?
    let driverId : String?
    let driverName : String?
    let driverLicenseNo : String?
    let driverLicenseExpiryDate : String?
    let driverNationality : String?
    let driverMembershipNo : String?
    let driverMembershipType : String?
    let driverContactNo : String?
    let debitorCode : String?
    let debitorName : String?
    let agreementUser : String?
    let agreementDays : String?
    let agreementPackage : String?
    let agreementPackagePrice : String?
    let agreementCheckOutTime : String?
    let agreementChargeGroup : String?
    let agreementOutKm : String?
    let agreementModelName : String?
    let agreementTotalRental : String?
    let agreementDiscount : String?
    let agreementFreeKm : String?
    let agreementFreeHr : String?
    let agreementExtraKmCharge : String?
    let agreementExtraHourCharge : String?
    let agreementDropOff : String?
    let agreementExtras : [AgreementExtras]?
    let agreementInsurance : [AgreementInsurance]?

    enum CodingKeys: String, CodingKey {

        case checkOutBranch = "CheckOutBranch"
        case checkInBranch = "CheckInBranch"
        case checkOutDate = "CheckOutDate"
        case checkInDate = "CheckInDate"
        case reservationNo = "ReservationNo"
        case statusCode = "StatusCode"
        case agreementNo = "AgreementNo"
        case chrageGroup = "ChrageGroup"
        case licenseNo = "LicenseNo"
        case tOTALAMOUNT = "TOTALAMOUNT"
        case tOTALPAID = "TOTALPAID"
        case tOTALBALANCE = "TOTALBALANCE"
        case checkOutBranchContact = "CheckOutBranchContact"
        case checkInBranchContact = "CheckInBranchContact"
        case driverId = "DriverId"
        case driverName = "DriverName"
        case driverLicenseNo = "DriverLicenseNo"
        case driverLicenseExpiryDate = "DriverLicenseExpiryDate"
        case driverNationality = "DriverNationality"
        case driverMembershipNo = "DriverMembershipNo"
        case driverMembershipType = "DriverMembershipType"
        case driverContactNo = "DriverContactNo"
        case debitorCode = "DebitorCode"
        case debitorName = "DebitorName"
        case agreementUser = "AgreementUser"
        case agreementDays = "AgreementDays"
        case agreementPackage = "AgreementPackage"
        case agreementPackagePrice = "AgreementPackagePrice"
        case agreementCheckOutTime = "AgreementCheckOutTime"
        case agreementChargeGroup = "AgreementChargeGroup"
        case agreementOutKm = "AgreementOutKm"
        case agreementModelName = "AgreementModelName"
        case agreementTotalRental = "AgreementTotalRental"
        case agreementDiscount = "AgreementDiscount"
        case agreementFreeKm = "AgreementFreeKm"
        case agreementFreeHr = "AgreementFreeHr"
        case agreementExtraKmCharge = "AgreementExtraKmCharge"
        case agreementExtraHourCharge = "AgreementExtraHourCharge"
        case agreementDropOff = "AgreementDropOff"
        case agreementExtras = "AgreementExtras"
        case agreementInsurance = "AgreementInsurance"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        checkOutBranch = try values.decodeIfPresent(String.self, forKey: .checkOutBranch)
        checkInBranch = try values.decodeIfPresent(String.self, forKey: .checkInBranch)
        checkOutDate = try values.decodeIfPresent(String.self, forKey: .checkOutDate)
        checkInDate = try values.decodeIfPresent(String.self, forKey: .checkInDate)
        reservationNo = try values.decodeIfPresent(String.self, forKey: .reservationNo)
        statusCode = try values.decodeIfPresent(String.self, forKey: .statusCode)
        agreementNo = try values.decodeIfPresent(String.self, forKey: .agreementNo)
        chrageGroup = try values.decodeIfPresent(String.self, forKey: .chrageGroup)
        licenseNo = try values.decodeIfPresent(String.self, forKey: .licenseNo)
        tOTALAMOUNT = try values.decodeIfPresent(String.self, forKey: .tOTALAMOUNT)
        tOTALPAID = try values.decodeIfPresent(String.self, forKey: .tOTALPAID)
        tOTALBALANCE = try values.decodeIfPresent(String.self, forKey: .tOTALBALANCE)
        checkOutBranchContact = try values.decodeIfPresent(String.self, forKey: .checkOutBranchContact)
        checkInBranchContact = try values.decodeIfPresent(String.self, forKey: .checkInBranchContact)
        driverId = try values.decodeIfPresent(String.self, forKey: .driverId)
        driverName = try values.decodeIfPresent(String.self, forKey: .driverName)
        driverLicenseNo = try values.decodeIfPresent(String.self, forKey: .driverLicenseNo)
        driverLicenseExpiryDate = try values.decodeIfPresent(String.self, forKey: .driverLicenseExpiryDate)
        driverNationality = try values.decodeIfPresent(String.self, forKey: .driverNationality)
        driverMembershipNo = try values.decodeIfPresent(String.self, forKey: .driverMembershipNo)
        driverMembershipType = try values.decodeIfPresent(String.self, forKey: .driverMembershipType)
        driverContactNo = try values.decodeIfPresent(String.self, forKey: .driverContactNo)
        debitorCode = try values.decodeIfPresent(String.self, forKey: .debitorCode)
        debitorName = try values.decodeIfPresent(String.self, forKey: .debitorName)
        agreementUser = try values.decodeIfPresent(String.self, forKey: .agreementUser)
        agreementDays = try values.decodeIfPresent(String.self, forKey: .agreementDays)
        agreementPackage = try values.decodeIfPresent(String.self, forKey: .agreementPackage)
        agreementPackagePrice = try values.decodeIfPresent(String.self, forKey: .agreementPackagePrice)
        agreementCheckOutTime = try values.decodeIfPresent(String.self, forKey: .agreementCheckOutTime)
        agreementChargeGroup = try values.decodeIfPresent(String.self, forKey: .agreementChargeGroup)
        agreementOutKm = try values.decodeIfPresent(String.self, forKey: .agreementOutKm)
        agreementModelName = try values.decodeIfPresent(String.self, forKey: .agreementModelName)
        agreementTotalRental = try values.decodeIfPresent(String.self, forKey: .agreementTotalRental)
        agreementDiscount = try values.decodeIfPresent(String.self, forKey: .agreementDiscount)
        agreementFreeKm = try values.decodeIfPresent(String.self, forKey: .agreementFreeKm)
        agreementFreeHr = try values.decodeIfPresent(String.self, forKey: .agreementFreeHr)
        agreementExtraKmCharge = try values.decodeIfPresent(String.self, forKey: .agreementExtraKmCharge)
        agreementExtraHourCharge = try values.decodeIfPresent(String.self, forKey: .agreementExtraHourCharge)
        agreementDropOff = try values.decodeIfPresent(String.self, forKey: .agreementDropOff)
        agreementExtras = try values.decodeIfPresent([AgreementExtras].self, forKey: .agreementExtras)
        agreementInsurance = try values.decodeIfPresent([AgreementInsurance].self, forKey: .agreementInsurance)
    }

}

struct AgreementExtras:Codable{
    let extraName : String?
    let amount : String?

    enum CodingKeys: String, CodingKey {

        case extraName = "ExtraName"
        case amount = "Amount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        extraName = try values.decodeIfPresent(String.self, forKey: .extraName)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
    }

}

struct AgreementInsurance:Codable{
    let insuranceName : String?
    let amount : String?

    enum CodingKeys: String, CodingKey {

        case insuranceName = "InsuranceName"
        case amount = "Amount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        insuranceName = try values.decodeIfPresent(String.self, forKey: .insuranceName)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
    }

}

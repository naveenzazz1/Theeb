//
//  InvoicesRentalHistoryModel.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 11/08/2023.
//

import Foundation

struct InvoicesRentalHistoryModelJson : Codable {
    let transactionRS : TransactionRSJson?

    enum CodingKeys: String, CodingKey {

        case transactionRS = "TransactionRS"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionRS = try values.decodeIfPresent(TransactionRSJson.self, forKey: .transactionRS)
    }

}

struct TransactionRSJson : Codable {
    let success : String?
    let invoices : Invoices?

    enum CodingKeys: String, CodingKey {

        case success = "Success"
        case invoices = "Invoices"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(String.self, forKey: .success)
        invoices = try values.decodeIfPresent(Invoices.self, forKey: .invoices)
    }

}

struct Invoices : Codable {
    let h1 : String?
    let h2 : String?
    let invoice : [InvoiceJson]?

    enum CodingKeys: String, CodingKey {

        case h1 = "H1"
        case h2 = "H2"
        case invoice = "Invoice"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        h1 = try values.decodeIfPresent(String.self, forKey: .h1)
        h2 = try values.decodeIfPresent(String.self, forKey: .h2)
        invoice = try values.decodeIfPresent([InvoiceJson].self, forKey: .invoice)
    }

}

struct InvoiceJson : Codable {
    let invoiceNo : String?
    let invoiceType : String?
    let agreementNo : String?
    let invoiceDate : String?
    let invoiceRental : String?
    let invoiceVat : String?
    let invoiceTotal : String?
    let invoiceTime : String?
    let invoiceBranchName : String?
    let invoiceAgrOutDate : String?
    let invoiceAgrOutTime : String?
    let invoiceAgrInDate : String?
    let invoiceAgrInTime : String?
    let invoiceAgrOutBranch : String?
    let invoiceAgrInBranch : String?
    let invoiceAgrOutKm : String?
    let invoiceAgrInKm : String?
    let invoiceAgrChargeGroup : String?
    let invoiceAgrCarModel : String?
    let invoiceAgrVehicleNo : String?
    let driverBillingName : String?
    let driverDOB : String?
    let driverMembershipNo : String?
    let driverPassportNo : String?
    let driverNationality : String?
    let driverLicenseNo : String?
    let driverLicenseExpiryDate : String?
    let driverAddress : String?
    let driverCity : String?
    let driverContactNo : String?
    let agreementTariff : String?
    let agreementRateNo : String?
    let agreementCurrency : String?
    let soldDays : String?
    let agreementFreeKm : String?
    let agreementChargableKm : String?
    let agreementDiscountPercent : String?
    let invoiceDiscountAmount : String?
    let invoiceOtherAmount : String?
    let invoiceDropOff : String?
    let invoiceAmountPaid : String?
    let invoiceBalance : String?
    let invoiceReservation : String?

    enum CodingKeys: String, CodingKey {

        case invoiceNo = "InvoiceNo"
        case invoiceType = "InvoiceType"
        case agreementNo = "AgreementNo"
        case invoiceDate = "InvoiceDate"
        case invoiceRental = "InvoiceRental"
        case invoiceVat = "InvoiceVat"
        case invoiceTotal = "InvoiceTotal"
        case invoiceTime = "InvoiceTime"
        case invoiceBranchName = "InvoiceBranchName"
        case invoiceAgrOutDate = "InvoiceAgrOutDate"
        case invoiceAgrOutTime = "InvoiceAgrOutTime"
        case invoiceAgrInDate = "InvoiceAgrInDate"
        case invoiceAgrInTime = "InvoiceAgrInTime"
        case invoiceAgrOutBranch = "InvoiceAgrOutBranch"
        case invoiceAgrInBranch = "InvoiceAgrInBranch"
        case invoiceAgrOutKm = "InvoiceAgrOutKm"
        case invoiceAgrInKm = "InvoiceAgrInKm"
        case invoiceAgrChargeGroup = "InvoiceAgrChargeGroup"
        case invoiceAgrCarModel = "InvoiceAgrCarModel"
        case invoiceAgrVehicleNo = "InvoiceAgrVehicleNo"
        case driverBillingName = "DriverBillingName"
        case driverDOB = "DriverDOB"
        case driverMembershipNo = "DriverMembershipNo"
        case driverPassportNo = "DriverPassportNo"
        case driverNationality = "DriverNationality"
        case driverLicenseNo = "DriverLicenseNo"
        case driverLicenseExpiryDate = "DriverLicenseExpiryDate"
        case driverAddress = "DriverAddress"
        case driverCity = "DriverCity"
        case driverContactNo = "DriverContactNo"
        case agreementTariff = "AgreementTariff"
        case agreementRateNo = "AgreementRateNo"
        case agreementCurrency = "AgreementCurrency"
        case soldDays = "SoldDays"
        case agreementFreeKm = "AgreementFreeKm"
        case agreementChargableKm = "AgreementChargableKm"
        case agreementDiscountPercent = "AgreementDiscountPercent"
        case invoiceDiscountAmount = "InvoiceDiscountAmount"
        case invoiceOtherAmount = "InvoiceOtherAmount"
        case invoiceDropOff = "InvoiceDropOff"
        case invoiceAmountPaid = "InvoiceAmountPaid"
        case invoiceBalance = "InvoiceBalance"
        case invoiceReservation = "InvoiceReservation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        invoiceNo = try values.decodeIfPresent(String.self, forKey: .invoiceNo)
        invoiceType = try values.decodeIfPresent(String.self, forKey: .invoiceType)
        agreementNo = try values.decodeIfPresent(String.self, forKey: .agreementNo)
        invoiceDate = try values.decodeIfPresent(String.self, forKey: .invoiceDate)
        invoiceRental = try values.decodeIfPresent(String.self, forKey: .invoiceRental)
        invoiceVat = try values.decodeIfPresent(String.self, forKey: .invoiceVat)
        invoiceTotal = try values.decodeIfPresent(String.self, forKey: .invoiceTotal)
        invoiceTime = try values.decodeIfPresent(String.self, forKey: .invoiceTime)
        invoiceBranchName = try values.decodeIfPresent(String.self, forKey: .invoiceBranchName)
        invoiceAgrOutDate = try values.decodeIfPresent(String.self, forKey: .invoiceAgrOutDate)
        invoiceAgrOutTime = try values.decodeIfPresent(String.self, forKey: .invoiceAgrOutTime)
        invoiceAgrInDate = try values.decodeIfPresent(String.self, forKey: .invoiceAgrInDate)
        invoiceAgrInTime = try values.decodeIfPresent(String.self, forKey: .invoiceAgrInTime)
        invoiceAgrOutBranch = try values.decodeIfPresent(String.self, forKey: .invoiceAgrOutBranch)
        invoiceAgrInBranch = try values.decodeIfPresent(String.self, forKey: .invoiceAgrInBranch)
        invoiceAgrOutKm = try values.decodeIfPresent(String.self, forKey: .invoiceAgrOutKm)
        invoiceAgrInKm = try values.decodeIfPresent(String.self, forKey: .invoiceAgrInKm)
        invoiceAgrChargeGroup = try values.decodeIfPresent(String.self, forKey: .invoiceAgrChargeGroup)
        invoiceAgrCarModel = try values.decodeIfPresent(String.self, forKey: .invoiceAgrCarModel)
        invoiceAgrVehicleNo = try values.decodeIfPresent(String.self, forKey: .invoiceAgrVehicleNo)
        driverBillingName = try values.decodeIfPresent(String.self, forKey: .driverBillingName)
        driverDOB = try values.decodeIfPresent(String.self, forKey: .driverDOB)
        driverMembershipNo = try values.decodeIfPresent(String.self, forKey: .driverMembershipNo)
        driverPassportNo = try values.decodeIfPresent(String.self, forKey: .driverPassportNo)
        driverNationality = try values.decodeIfPresent(String.self, forKey: .driverNationality)
        driverLicenseNo = try values.decodeIfPresent(String.self, forKey: .driverLicenseNo)
        driverLicenseExpiryDate = try values.decodeIfPresent(String.self, forKey: .driverLicenseExpiryDate)
        driverAddress = try values.decodeIfPresent(String.self, forKey: .driverAddress)
        driverCity = try values.decodeIfPresent(String.self, forKey: .driverCity)
        driverContactNo = try values.decodeIfPresent(String.self, forKey: .driverContactNo)
        agreementTariff = try values.decodeIfPresent(String.self, forKey: .agreementTariff)
        agreementRateNo = try values.decodeIfPresent(String.self, forKey: .agreementRateNo)
        agreementCurrency = try values.decodeIfPresent(String.self, forKey: .agreementCurrency)
        soldDays = try values.decodeIfPresent(String.self, forKey: .soldDays)
        agreementFreeKm = try values.decodeIfPresent(String.self, forKey: .agreementFreeKm)
        agreementChargableKm = try values.decodeIfPresent(String.self, forKey: .agreementChargableKm)
        agreementDiscountPercent = try values.decodeIfPresent(String.self, forKey: .agreementDiscountPercent)
        invoiceDiscountAmount = try values.decodeIfPresent(String.self, forKey: .invoiceDiscountAmount)
        invoiceOtherAmount = try values.decodeIfPresent(String.self, forKey: .invoiceOtherAmount)
        invoiceDropOff = try values.decodeIfPresent(String.self, forKey: .invoiceDropOff)
        invoiceAmountPaid = try values.decodeIfPresent(String.self, forKey: .invoiceAmountPaid)
        invoiceBalance = try values.decodeIfPresent(String.self, forKey: .invoiceBalance)
        invoiceReservation = try values.decodeIfPresent(String.self, forKey: .invoiceReservation)
    }

}

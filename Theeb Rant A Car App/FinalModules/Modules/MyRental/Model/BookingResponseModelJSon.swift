//
//  BookingResponseModel.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 10/08/2023.
//

import Foundation

struct BookingResponseModelJson: Codable {
    let bookingDataRS : BookingDataRSJson?

    enum CodingKeys: String, CodingKey {

        case bookingDataRS = "BookingDataRS"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bookingDataRS = try values.decodeIfPresent(BookingDataRSJson.self, forKey: .bookingDataRS)
    }

}

struct BookingDataRSJson : Codable {
    let success : String?
    let varianceReason : String?
    let driverCode : String?
    let driverFirstName : String?
    let driverLastName : String?
    let onGoing : OnGoingJson?
    let cancelled : CancelledJson?
    let completed: CompletedJson?

    enum CodingKeys: String, CodingKey {

        case success = "Success"
        case varianceReason = "VarianceReason"
        case driverCode = "DriverCode"
        case driverFirstName = "DriverFirstName"
        case driverLastName = "DriverLastName"
        case onGoing = "OnGoing"
        case cancelled = "Cancelled"
        case completed = "Completed"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(String.self, forKey: .success)
        varianceReason = try values.decodeIfPresent(String.self, forKey: .varianceReason)
        driverCode = try values.decodeIfPresent(String.self, forKey: .driverCode)
        driverFirstName = try values.decodeIfPresent(String.self, forKey: .driverFirstName)
        driverLastName = try values.decodeIfPresent(String.self, forKey: .driverLastName)
        onGoing = try values.decodeIfPresent(OnGoingJson.self, forKey: .onGoing)
        cancelled = try values.decodeIfPresent(CancelledJson.self, forKey: .cancelled)
        completed = try values.decodeIfPresent(CompletedJson.self, forKey: .completed)

    }

}


struct Reservation : Codable {
    let carGroup: String?
    let carGroupImage : String?
    let carGroupDescription : String?
    let checkOutDate : String?
    let checkOutTime : String?
    let checkInDate : String?
    let checkInTime : String?
    let rateNo : String?
    let rateName : String?
    let checkOutBranch : String?
    let checkInBranch : String?
    let reservationStatus : String?
    let tariff : String?
    let licenseNo : String?
    let reservationNo : String?
    let internetReservationNo : String?
    let totalPaid : String?
    let totalBeforeTax : String?
    let salesTax : String?
    let totalDiscount : String?
    let totalWithTax : String?
    let dropOffCharge : String?
    let rentalCharge : String?
    let insuranceCharge : String?
    let extrasCharge : String?
    let vehTypeDescAR : String?

    enum CodingKeys: String, CodingKey {

        case carGroup = "CarGroup"
        case carGroupImage = "CarGroupImage"
        case carGroupDescription = "CarGroupDescription"
        case checkOutDate = "CheckOutDate"
        case checkOutTime = "CheckOutTime"
        case checkInDate = "CheckInDate"
        case checkInTime = "CheckInTime"
        case rateNo = "RateNo"
        case rateName = "RateName"
        case checkOutBranch = "CheckOutBranch"
        case checkInBranch = "CheckInBranch"
        case reservationStatus = "ReservationStatus"
        case tariff = "Tariff"
        case licenseNo = "LicenseNo"
        case reservationNo = "ReservationNo"
        case internetReservationNo = "InternetReservationNo"
        case totalPaid = "TotalPaid"
        case totalBeforeTax = "TotalBeforeTax"
        case salesTax = "SalesTax"
        case totalDiscount = "TotalDiscount"
        case totalWithTax = "TotalWithTax"
        case dropOffCharge = "DropOffCharge"
        case rentalCharge = "RentalCharge"
        case insuranceCharge = "InsuranceCharge"
        case extrasCharge = "ExtrasCharge"
        case vehTypeDescAR = "VehTypeDescAR"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        carGroupImage = try values.decodeIfPresent(String.self, forKey: .carGroupImage)
        carGroup = try values.decodeIfPresent(String.self, forKey: .carGroup)
        carGroupDescription = try values.decodeIfPresent(String.self, forKey: .carGroupDescription)
        checkOutDate = try values.decodeIfPresent(String.self, forKey: .checkOutDate)
        checkOutTime = try values.decodeIfPresent(String.self, forKey: .checkOutTime)
        checkInDate = try values.decodeIfPresent(String.self, forKey: .checkInDate)
        checkInTime = try values.decodeIfPresent(String.self, forKey: .checkInTime)
        rateNo = try values.decodeIfPresent(String.self, forKey: .rateNo)
        rateName = try values.decodeIfPresent(String.self, forKey: .rateName)
        checkOutBranch = try values.decodeIfPresent(String.self, forKey: .checkOutBranch)
        checkInBranch = try values.decodeIfPresent(String.self, forKey: .checkInBranch)
        reservationStatus = try values.decodeIfPresent(String.self, forKey: .reservationStatus)
        tariff = try values.decodeIfPresent(String.self, forKey: .tariff)
        licenseNo = try values.decodeIfPresent(String.self, forKey: .licenseNo)
        reservationNo = try values.decodeIfPresent(String.self, forKey: .reservationNo)
        internetReservationNo = try values.decodeIfPresent(String.self, forKey: .internetReservationNo)
        totalPaid = try values.decodeIfPresent(String.self, forKey: .totalPaid)
        totalBeforeTax = try values.decodeIfPresent(String.self, forKey: .totalBeforeTax)
        salesTax = try values.decodeIfPresent(String.self, forKey: .salesTax)
        totalDiscount = try values.decodeIfPresent(String.self, forKey: .totalDiscount)?.trimmingCharacters(in: .whitespaces)
        totalWithTax = try values.decodeIfPresent(String.self, forKey: .totalWithTax)?.trimmingCharacters(in: .whitespaces)
        dropOffCharge = try values.decodeIfPresent(String.self, forKey: .dropOffCharge)?.trimmingCharacters(in: .whitespaces)
        rentalCharge = try values.decodeIfPresent(String.self, forKey: .rentalCharge)?.trimmingCharacters(in: .whitespaces)
        insuranceCharge = try values.decodeIfPresent(String.self, forKey: .insuranceCharge)?.trimmingCharacters(in: .whitespaces)
        extrasCharge = try values.decodeIfPresent(String.self, forKey: .extrasCharge)?.trimmingCharacters(in: .whitespaces)
        vehTypeDescAR = try values.decodeIfPresent(String.self, forKey: .vehTypeDescAR)
    }

}

struct CancelledJson : Codable {
    let reservation : [Reservation]?

    enum CodingKeys: String, CodingKey {

        case reservation = "Reservation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reservation = try values.decodeIfPresent([Reservation].self, forKey: .reservation)
    }

}


struct OnGoingJson : Codable {
    let reservation : [Reservation]?

    enum CodingKeys: String, CodingKey {

        case reservation = "Reservation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reservation = try values.decodeIfPresent([Reservation].self, forKey: .reservation)
    }

}

struct CompletedJson : Codable {
    let reservation : [Reservation]?

    enum CodingKeys: String, CodingKey {

        case reservation = "Reservation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reservation = try values.decodeIfPresent([Reservation].self, forKey: .reservation)
    }

}

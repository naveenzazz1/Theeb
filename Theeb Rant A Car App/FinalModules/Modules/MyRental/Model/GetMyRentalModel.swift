//
//  GetMyRentalService.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 04/07/1443 AH.
//

import Foundation
import XMLMapper

class BookingResponseModel: XMLMappable {
    
    var nodeName: String!
    var response : BookingResponseObject?
    
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        response <- map["SOAP-ENV:Body.ReservationDetails"]
        
    }
}


class BookingResponseObject: XMLMappable {
    
    
    var nodeName: String!
    
    var success : String?
    var varianceReason : String?
    var driverCode : String?
    var driverFirstName : String?
    var driverLastName : String?
    var onGoing : [Reservation]?
    var cancelled : [Reservation]?
    var completed : [Reservation]?
    

    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        success <- map["Success"]
        varianceReason <- map["VarianceReason"]
        driverCode <- map["DriverCode"]
        driverFirstName <- map["DriverFirstName"]
        driverLastName <- map["DriverLastName"]
        onGoing <- map["OnGoing.Reservation"]
        cancelled <- map["Cancelled.Reservation"]
        completed <- map["Completed.Reservation"]
        
        
    }
}

//class Reservation: XMLMappable {
//    
//    
//   var nodeName: String!
//    
//    var carGroupImagePath : String?
//    var carGroupDescription : String?
//    var checkOutDate : String?
//    var checkOutTime : String?
//    var checkInDate : String?
//    var checkInTime : String?
//    var rateNo : String?
//    var rateName : String?
//    var checkOutBranch : String?
//    var checkInBranch : String?
//    var reservationStatus : String?
//    var tariff : String?
//    var licenseNo : String?
//    var reservationNo : String?
//    var internetReservationNo : String?
//    var totalPaid : String?
//    var totalBeforeTax : String?
//    var salesTax : String?
//    var totalDiscount : String?
//    var totalWithTax : String?
//    var refundRequestExist : String?
//    var dropOffCharge : String?
//    var insuranceCharge : String?
//    var extrasCharge : String?
//    var rentalCharge : String?
//    var vehtypeArName : String?
//    required init(map: XMLMap) {
//        
//    }
//    
//    func mapping(map: XMLMap) {
//        refundRequestExist <- map["RefundRequestExist"]
//        carGroupImagePath <- map["CarGroupImagePath"]
//        carGroupImagePath <- map["CarGroupImagePath"]
//        carGroupDescription <- map["CarGroupDescription"]
//        checkOutDate <- map["CheckOutDate"]
//        checkOutTime <- map["CheckOutTime"]
//        checkInDate <- map["CheckInDate"]
//        checkInTime <- map["CheckInTime"]
//        rateNo <- map["RateNo"]
//        rateName <- map["RateName"]
//        checkOutBranch <- map["CheckOutBranch"]
//        checkInBranch <- map["CheckInBranch"]
//        reservationStatus <- map["ReservationStatus"]
//        tariff <- map["Tariff"]
//        licenseNo <- map["LicenseNo"]
//        reservationNo <- map["ReservationNo"]
//        internetReservationNo <- map["InternetReservationNo"]
//        totalPaid <- map["TotalPaid"]
//        totalBeforeTax <- map["TotalBeforeTax"]
//        salesTax <- map["SalesTax"]
//        totalDiscount <- map["TotalDiscount"]
//        totalWithTax <- map["TotalWithTax"]
//        dropOffCharge <- map["DropOffCharge"]
//        insuranceCharge <- map["InsuranceCharge"]
//        extrasCharge <- map["ExtrasCharge"]
//        rentalCharge <- map["RentalCharge"]
//        vehtypeArName <- map["VehTypeDescAR"]
//        
//    }
//}






class RentalHistoryMappable : XMLMappable {
    
    var nodeName: String!
    var rentalModelobj : RentalsHistoryModel!
    var invoiceRentalModel : InvoicesRentalHistoryModel!
    var paymentRentalModel : PaymentsRentalHistoryModel!
    var reservationRentalModel : [ReservationRentalHistoryModel]!
    var success : String?
    var varianceReason : String?
    
    
    required init(map: XMLMap) {
        
    }
    
    
    
    func mapping(map: XMLMap) {
        
        rentalModelobj <- map["SOAP-ENV:Body.TransactionRS.Agreements"]
        invoiceRentalModel <- map["SOAP-ENV:Body.TransactionRS.Invoices"]
        paymentRentalModel <- map["SOAP-ENV:Body.TransactionRS.Payments"]
        reservationRentalModel <- map["SOAP-ENV:Body.TransactionRS.Reservations.Reservation"]
        success <- map["SOAP-ENV:Body.TransactionRS.Success"]
        varianceReason <- map["SOAP-ENV:Body.TransactionRS.VarianceReason"]
        
        
        
    }
    
    
    
}

class RentalsHistoryModel : XMLMappable {
   
    var nodeName: String!
    var h1 : String!
    var h2 : String!
    var rentalModelArray : [RentalHistoryModel]!
    
    
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        
        h1 <- map["H1"]
        h2 <- map["H2"]
        rentalModelArray <- map["Agreement"]
        
    }
}


class InvoicesRentalHistoryModel : XMLMappable {
    var nodeName: String!
    var h1 : String!
    var h2 : String!
    var invoiceRentalModelArray : [InvoiceRentalHistoryModel]!
    
    
    
    required init(map: XMLMap) {
        
    }
    func mapping(map: XMLMap) {
        
        h1 <- map["H1"]
        h2 <- map["H2"]
        invoiceRentalModelArray <- map["Invoice"]
        
        
    }
}



class PaymentsRentalHistoryModel : XMLMappable
{
    var nodeName: String!
    var h1 : String!
    var h2 : String!
    var payememtRentalModelArray : [PaymentRentalHistoryModel]!
    
    
    
    required init(map: XMLMap) {
        
    }
    
    
    
    func mapping(map: XMLMap) {
        
        h1 <- map["H1"]
        h2 <- map["H2"]
        payememtRentalModelArray <- map["Payment"]
        
        
        
        
    }
}


class PaymentRentalHistoryModel: XMLMappable {
 
    var nodeName: String!

    var receiptNo: String!
    var paymentMethod: String!
    var invoiceNo: String!
    var receiptDate: String!
    var receiptAmount: String!
    var agreementNo: String!
    var branchCode: String!
    var branchName: String!
    var customerName: String!
    var customerAddress: String!
    var paymentMode: String!
    var paymentUser: String!
    
    required init(map: XMLMap) {
        
    }
    
    
    
    func mapping(map: XMLMap) {
        receiptDate <- map["ReceiptDate"]
        receiptNo <- map["ReceiptNo"]
        paymentMode <- map["PaymentMethod"]
        invoiceNo <- map["InvoiceNo"]
        receiptAmount <- map["ReceiptAmount"]
        agreementNo <- map["AgreementNo"]
        branchCode <- map["BranchCode"]
        branchName <- map["BranchName"]
        customerName <- map["CustomerName"]
        customerAddress <- map["CustomerAddress"]
        paymentMode <- map["PaymentMode"]
        
        paymentUser <- map["PaymentUser"]
        
    }
    
}


class InvoiceRentalHistoryModel: XMLMappable {
    
    var nodeName: String!
    
    var agreementChargableKm: String!
    var agreementCurrency: String!
    var agreementDiscountPercent: String!
    var agreementFreeKm: String!
    var agreementNo: String!
    var agreementRateNo: String!
    var agreementTariff: String!
    var driverAddress: String!
    var driverBillingName: String!
    var driverCity: String!
    var driverContactNo: String!
    var driverDOB: String!
    var driverLicenseExpiryDate: String!
    var driverLicenseNo: String!
    var driverMembershipNo: String!
    var driverNationality: String!
    var driverPassportNo: String!
    var invoiceAgrCarModel: String!
    var invoiceAgrChargeGroup: String!
    var invoiceAgrInBranch: String!
    var invoiceAgrInDate: String!
    var invoiceAgrInKm: String!
    var invoiceAgrInTime: String!
    var invoiceAgrOutBranch: String!
    var invoiceAgrOutDate: String!
    var invoiceAgrOutKm: String!
    var invoiceAgrOutTime: String!
    var invoiceAgrVehicleNo: String!
    var invoiceAmountPaid: String!
    var invoiceBalance: String!
    var invoiceBranchName: String!
    var invoiceDate: String!
    var invoiceDiscountAmount: String!
    var invoiceDropOff: String!
    var invoiceNo: String!
    var invoiceOther: String!
    var invoiceOtherAmount: String!
    var invoiceRental: String!
    var invoiceTime: String!
    var invoiceTotal: String!
    var invoiceVat : String!
    var invoiceType: String!
    var soldDays: String!
    var invoiceInsurances : InvoiceInsurance?
    var invoiceReservation : String!
    var invoiceExtrasAmount : String!
    required init(map: XMLMap) {
        
        
    }
    
    
    
    func mapping(map: XMLMap) {
        invoiceVat <- map["InvoiceVat"]
        agreementChargableKm <- map["AgreementChargableKm"]
        agreementCurrency <- map["AgreementCurrency"]
        agreementDiscountPercent <- map["AgreementDiscountPercent"]
        agreementFreeKm <- map["AgreementFreeKm"]
        agreementNo <- map["AgreementNo"]
        agreementRateNo <- map["AgreementRateNo"]
        agreementTariff <- map["AgreementTariff"]
        driverAddress <- map["DriverAddress"]
        driverBillingName <- map["DriverBillingName"]
        driverCity <- map["DriverCity"]
        driverContactNo <- map["DriverContactNo"]
        driverDOB <- map["DriverDOB"]
        driverLicenseExpiryDate <- map["DriverLicenseExpiryDate"]
        driverLicenseNo <- map["DriverLicenseNo"]
        driverMembershipNo <- map["DriverMembershipNo"]
        driverNationality <- map["DriverNationality"]
        driverPassportNo <- map["DriverPassportNo"]
        invoiceAgrCarModel <- map["InvoiceAgrCarModel"]
        invoiceAgrChargeGroup <- map["InvoiceAgrChargeGroup"]
        invoiceAgrInBranch <- map["InvoiceAgrInBranch"]
        invoiceAgrInDate <- map["InvoiceAgrInDate"]
        invoiceAgrInKm <- map["InvoiceAgrInKm"]
        invoiceAgrInTime <- map["InvoiceAgrInTime"]
        invoiceAgrOutBranch <- map["InvoiceAgrOutBranch"]
        invoiceAgrOutDate <- map["InvoiceAgrOutDate"]
        invoiceAgrOutKm <- map["InvoiceAgrOutKm"]
        invoiceAgrOutTime <- map["InvoiceAgrOutTime"]
        invoiceAgrVehicleNo <- map["InvoiceAgrVehicleNo"]
        invoiceAmountPaid <- map["InvoiceAmountPaid"]
        invoiceBalance <- map["InvoiceBalance"]
        invoiceBranchName <- map["InvoiceBranchName"]
        invoiceDate <- map["InvoiceDate"]
        invoiceDiscountAmount <- map["InvoiceDiscountAmount"]
        invoiceDropOff <- map["InvoiceDropOff"]
        invoiceNo <- map["InvoiceNo"]
        invoiceOther <- map["InvoiceOther"]
        invoiceOtherAmount <- map["InvoiceOtherAmount"]
        invoiceRental <- map["InvoiceRental"]
        invoiceTime <- map["InvoiceTime"]
        invoiceTotal <- map["InvoiceTotal"]
        invoiceType <- map["InvoiceType"]
        soldDays <- map["SoldDays"]
        invoiceReservation <- map["InvoiceReservation"]
        invoiceInsurances <- map["InvoiceInsurances"]
        invoiceExtrasAmount <- map["InvoiceExtras.Amount"]
    }

}


class InvoiceInsurance: XMLMappable {
    
    var nodeName: String!
    var insuranceName: String!
    var days: String!
    var units: String!
    var amount: String!
    
    
    
    
    required init(map: XMLMap) {
        
    }
    
    
    
    func mapping(map: XMLMap) {
        
        insuranceName <- map["InsuranceName"]
        days <- map["Days"]
        units <- map["Units"]
        amount <- map["Amount"]
        
        
        
    }
    
}


class RentalHistoryModel: XMLMappable {

    var nodeName: String!
    
    var agreementChargeGroup : String!
    var agreementCheckOutTime : String!
    var agreementDays : String!
    var agreementDiscount : String!
    var agreementExtraHourCharge : String!
    var agreementExtraKmCharge : String!
    var agreementExtras : String!
    var agreementFreeHr : String!
    var agreementFreeKm : String!
    var agreementInsurance : String!
    var agreementModelName : String!
    var agreementNo : String!
    var agreementOutKm : String!
    var agreementPackage : String!
    var agreementPackagePrice : String!
    var agreementTotalRental : String!
    var agreementUser : String!
    var checkInBranch : String!
    var checkInBranchContact : String!
    var checkInDate : String!
    var checkOutBranch : String!
    var checkOutBranchContact : String!
    var checkOutDate : String!
    var chrageGroup : String!
    var debitorCode : String!
    var debitorName : String!
    var driverContactNo : String!
    var driverId : String!
    var driverLicenseExpiryDate : String!
    var driverLicenseNo : String!
    var driverMembershipNo : String!
    var driverMembershipType : String!
    var driverName : String!
    var driverNationality : String!
    var licenseNo : String!
    var reservationNo : String!
    var statusCode : String!
    var tOTALAMOUNT : String!
    var tOTALBALANCE : String!
    var tOTALPAID : String!
    var agreementDropOff : String!
    
    func mapping(map: XMLMap) {
        agreementDropOff <- map["AgreementDropOff"]
        
        driverContactNo <- map["DriverContactNo"]
        agreementNo <- map["AgreementNo"]
        agreementChargeGroup <- map["AgreementChargeGroup"]
        agreementCheckOutTime <- map["AgreementCheckOutTime"]
        agreementDays <- map["AgreementDays"]
        agreementDiscount <- map["AgreementDiscount"]
        agreementExtraHourCharge <- map["AgreementExtraHourCharge"]
        agreementExtraKmCharge <- map["AgreementExtraKmCharge"]
        agreementExtras <- map["AgreementExtras"]
        agreementFreeHr <- map["AgreementFreeHr"]
        agreementFreeKm <- map["AgreementFreeKm"]
        agreementOutKm <- map["AgreementOutKm"]
        agreementInsurance <- map["AgreementInsurance"]
        agreementModelName <- map["AgreementModelName"]
        agreementPackage <- map["AgreementPackage"]
        agreementPackagePrice <- map["AgreementPackagePrice"]
        agreementTotalRental <- map["AgreementTotalRental"]
        agreementUser <- map["AgreementUser"]
        checkInBranch <- map["CheckInBranch"]
        checkInBranchContact <- map["CheckInBranchContact"]
        checkInDate <- map["CheckInDate"]
        checkOutBranch <- map["CheckOutBranch"]
        checkOutBranchContact <- map["CheckOutBranchContact"]
        checkOutDate <- map["CheckOutDate"]
        debitorCode <- map["DebitorCode"]
        debitorName <- map["DebitorName"]
        chrageGroup <- map["ChrageGroup"]
        driverId <- map["DriverId"]
        driverLicenseExpiryDate <- map["DriverLicenseExpiryDate"]
        driverLicenseNo <- map["DriverLicenseNo"]
        driverMembershipNo <- map["DriverMembershipNo"]
        driverMembershipType <- map["DriverMembershipType"]
        driverName <- map["DriverName"]
        driverNationality <- map["DriverNationality"]
        reservationNo <- map["ReservationNo"]
        licenseNo <- map["LicenseNo"]
        statusCode <- map["StatusCode"]
        tOTALAMOUNT <- map["TOTALAMOUNT"]
        tOTALBALANCE <- map["TOTALBALANCE"]
        tOTALPAID <- map["TOTALPAID"]
        
        tOTALPAID <- map["TOTALPAID"]
        tOTALPAID <- map["TOTALPAID"]
        tOTALPAID <- map["TOTALPAID"]
        tOTALPAID <- map["TOTALPAID"]
    }
    
    required init(map: XMLMap) {
        
    }
    
}


class ReservationRentalHistoryModel: XMLMappable {
    
    var nodeName: String!
    var reservationNo: String!
    var checkOutBranch: String!
    var checkInBranch: String!
    var checkOutDateTime: String!
    var checkInDateTime: String!
    var status: String!
    var reservationStatus : String!
    var totalWithTax: String!
    var totalPaid: String!
    
    
    required init(map: XMLMap) {
        
    }
    
    
    
    func mapping(map: XMLMap) {
        
        reservationNo <- map["ReservationNo"]
        checkOutBranch <- map["CheckOutBranch"]
        checkInBranch <- map["CheckInBranch"]
        checkOutDateTime <- map["CheckOutDateTime"]
        checkInDateTime <- map["CheckInDateTime"]
        status <- map["Status"]
        totalWithTax <- map["TotalWithTax"]
        totalPaid <- map["TotalPaid"]
        reservationStatus <- map["ReservationStatus"]
        
        
    }
    
}

class RentalItem:XMLMappable,Codable {
    
    required init?(map: XMLMap) {
    }
        
    func mapping(map: XMLMap) {
    }
    
    init(){}
    
    var nodeName: String!
    var pickupBranch : String?
    var returnBBranch : String?
    var pickTime : String?
    var returnTime : String?
    var pickupDate : String?
    var returnDate : String?
    var status : String?
    var totalAmount : String?
    var carRentalAmount : String?
    var number: String?
    var carImage : String?
    var freeChargeHours : String?
    var freeKms : String?
    var insuranceAmount : String?
    var vatAmount: String?
    var invoiceNumber: String?
    var totalBeforeTax: String?
    var discountAmount: String?
    var carModel : String?
    var totalDays : String?
    var totalBalance : String?
    var isContract : Bool? = false
    var isInvoice : Bool? = false
    var isBooking: Bool? = false
    var totalPaid : String?
    var totalInvoice : String?
    var totalPaidInvoice : String?
    var rateName:String?
    var reservationNumber:String?
    var internetReservationNo : String?
    var resnumforCancel:String?
    var rentalSum:String?
    var extraxSum : String?
    var extraFeesVal : String?
    var deliveryFees:String?
    var memberShipVal:String?
}



enum RentalCase{
//    case booking (val:XMLMappable?)
//    case contracts (val:XMLMappable?)
//    case unpaid (val:XMLMappable?)
//    case all (val:XMLMappable?)
    
    case booking (val:Codable?)
    case contracts (val:Codable?)
    case unpaid (val:Codable?)
    case all (val:Codable?)
    
    var titleRental:String{
        switch self{
        case .all(let val):
            if let val = val as? RentalItem{
                if val.isInvoice ?? false {return "Invoice"}
                if val.isBooking ?? false {return "Booking"}
                if val.isContract ?? false {return "Contracts"}
            }
            return "Car Details"
        case .booking:
            return "Booking"
        case .contracts:
            return "Contracts"
        case .unpaid:
            return "Invoice"      
        }
    }
}


class RentProPrintRSMappable: XMLMappable  {
    var nodeName: String!
    var obj : RentProPrintRS!
    
    required init(map: XMLMap) {
    }
    func mapping(map: XMLMap) {
        obj <- map["SOAP-ENV:Body.RentProPrintRS"]
        
    }
}
class RentProPrintRS: XMLMappable  {
    var nodeName: String!
    var success : String!
    var varianceReason : String!
    var documentPrint : String!
    required init(map: XMLMap) {
    }
    func mapping(map: XMLMap) {
        success <- map["Success"]
        varianceReason <- map["VarianceReason"]
        documentPrint <- map["DocumentPrint"]
    }
}


// DocumentPrint

class DocumentPrintResponseModel: Codable {
    var RentProPrintRS: RentProPrintRSModel?
}

struct RentProPrintRSModel: Codable {
    var Success : String?
    var VarianceReason : String?
    var DocumentPrint : String?
}

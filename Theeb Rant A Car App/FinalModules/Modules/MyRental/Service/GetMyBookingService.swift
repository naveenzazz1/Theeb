//
//  GetMyBookingService.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 04/07/1443 AH.
//

import Foundation

class GetMyBookingsService {
    
    func getMyRentalHistory(idnumber : String?,
                            success: APISuccess,
                            failure: APIFailure) {
        
        NetworkManager.manager.request(isCustomLoader:false, soapAction: SOAPACTIONS.bookingDetail, xmlString: self.myRentalXmlString(idNo:idnumber), url: BaseURL.production,success: success, failure: failure)
        
    }
    
    func getInvoicesPaymentsAgremments(driverCode : String?,
                                       transactionFor : String?,
                                       startDate : String?,
                                       endDate : String?,
                                       success: APISuccess,
                                       failure: APIFailure) {
        
        
        NetworkManager.manager.request(isCustomLoader:false,soapAction: SOAPACTIONS.rentalHistory, xmlString: self.rentalHistoryXMLString(driverCode: driverCode, transactionFor: transactionFor, startDate: startDate, endDate: endDate), url: BaseURL.production,success: success, failure: failure)
    }
    
    func printInvoicePdf(reservationNo : String?,
                         mode : String?,
                         recieptAgreementNo : String?,
                         recieptInvoiceNumber : String?,
                         success: APISuccess,
                         failure: APIFailure) {
        
        NetworkManager.manager.request(soapAction: SOAPACTIONS.printDocument, xmlString: self.getPdfRentPro(reservationNo: reservationNo, mode: mode, recieptAgreementNo: recieptAgreementNo, recieptInvoiceNumber: recieptInvoiceNumber), url: BaseURL.production, success: success, failure: failure)
        
        
    }
    
    
    func myRentalXmlString(idNo : String?) -> String? {
        
        
        return  "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:Reservations xmlns:m=\"ReservationsBookingRequest\"><m:PassportID>\(idNo ?? "" )</m:PassportID></m:Reservations></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
    }
    
    func rentalHistoryXMLString(driverCode : String?,
                       transactionFor : String?,
                       startDate : String?,
                       endDate : String?) -> String? {
        
        
        return  "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:TransactionRQ xmlns:m=\"TransactionRequest\"><m:StartDate>\(startDate!)</m:StartDate><m:EndDate>\(endDate ?? "")</m:EndDate><m:TransactionFor>\(transactionFor ?? "")</m:TransactionFor><m:DriverCode>\(driverCode ?? "")</m:DriverCode></m:TransactionRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
    }
    
    func cancelMyRental(reservationCode : String,success:APISuccess,failure: APIFailure) {
        
        NetworkManager.manager.request(soapAction: SOAPACTIONS.reservation, xmlString: cancelBooking(reservationCode: reservationCode), url: BaseURL.production,success: success, failure: failure)
        
    }
    
    private func cancelBooking(reservationCode : String?) -> String?{
    
        return  "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:ReservationDetails xmlns:m=\"CarProReservation\"><m:Reservation><m:DriverCode></m:DriverCode><m:LicenseNo></m:LicenseNo><m:LastName></m:LastName><m:FirstName></m:FirstName><m:CDP></m:CDP><m:OutBranch></m:OutBranch><m:InBranch></m:InBranch><m:OutDate></m:OutDate><m:OutTime></m:OutTime><m:InDate></m:InDate><m:InTime></m:InTime><m:RateNo></m:RateNo><m:RentalSum></m:RentalSum><m:DepositAmount></m:DepositAmount><m:ReservationNo>\(reservationCode ?? "")</m:ReservationNo><m:ReservationStatus>C</m:ReservationStatus><m:CarGroup></m:CarGroup><m:Currency></m:Currency><m:PaymentType></m:PaymentType><m:CreditCardNo></m:CreditCardNo><m:CarMake></m:CarMake><m:CarModel></m:CarModel><m:Remarks>iOS-APP</m:Remarks><m:Booked><m:Insurance><m:Code></m:Code><m:Name></m:Name><m:Quantity></m:Quantity></m:Insurance><m:Extra><m:Code></m:Code><m:Name></m:Name><m:Quantity></m:Quantity></m:Extra></m:Booked><m:included><m:Insurance><m:Code></m:Code><m:Name></m:Name><m:Quantity></m:Quantity></m:Insurance><m:Extra><m:Code></m:Code><m:Name></m:Name><m:Quantity></m:Quantity></m:Extra></m:included></m:Reservation></m:ReservationDetails></SOAP-ENV:Body></SOAP-ENV:Envelope>"
    }
    
    
     func getPdfRentPro(reservationNo : String?,
                        mode : String?,
                        recieptAgreementNo : String?,
                        recieptInvoiceNumber : String?) -> String?
    {
        
        return "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:RentProPrintRQ xmlns:m=\"RentProPrintRQ\"><m:PrintFor>\(mode ?? "")</m:PrintFor><m:DocumentNumber>\(reservationNo ?? "")</m:DocumentNumber><m:ReceiptAgrNo>\(recieptAgreementNo ?? "")</m:ReceiptAgrNo><m:ReceiptInvNo>\(recieptInvoiceNumber ?? "")</m:ReceiptInvNo></m:RentProPrintRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
    }
    
    
}

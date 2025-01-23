//
//  PaymentService.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 15/08/1443 AH.
//

import Foundation

class PaymentService  {
    
    
    func createPayment(paymentOption: String?,
                        merchantReference: String?,
                        amount:String?,
                        cardNumber:String?,
                        expiry:String?,authorizationCode:String?,
                        reservationNO : String?,
                        driverCode:String?,
                        currency:String?,
                        invoice: String?,
                        agreementNo : String? = nil,
                        success: APISuccess,
                        failure: APIFailure) {
        
       
        NetworkManager.manager.request(soapAction: SOAPACTIONS.payment, xmlString: self.paymentCreate(paymentOption: paymentOption, merchantReference: merchantReference, amount: amount, cardNumber: cardNumber, expiry: expiry, authorizationCode: authorizationCode, reservationNO: reservationNO, driverCode: driverCode, currency: currency, invoice: invoice), url: BaseURL.production, success: success, failure: failure)
        
        
    }
    
    
    
    
     func paymentCreate(paymentOption: String?,
                             merchantReference: String?,
                             amount:String?,
                             cardNumber:String?,
                             expiry:String?,authorizationCode:String?,
                             reservationNO : String?,
                             driverCode:String?,
                             currency:String?,
                             invoice: String?,agreementNo : String? = nil) -> String? {
        let xmlString = "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:PayMentRQ xmlns:m=\"ReservationMobilePayment\"><m:PAYMENTOPTION>\(paymentOption!)</m:PAYMENTOPTION><m:MERCHANTREFERENCE>\(merchantReference!)</m:MERCHANTREFERENCE><m:AMOUNT>\(amount!)</m:AMOUNT><m:CARDNUMBER>\(cardNumber!)</m:CARDNUMBER><m:EXPIRYDATE>\(expiry!)</m:EXPIRYDATE><m:AUTHORIZATIONCODE>\(authorizationCode!)</m:AUTHORIZATIONCODE><m:RESERVATIONNO>\(reservationNO ?? "")</m:RESERVATIONNO><m:DRIVERCODE>\(driverCode!)</m:DRIVERCODE><m:CURRENCY>\(currency!)</m:CURRENCY><m:INVOICE>\(invoice ?? "")</m:INVOICE><m:AGREEMENT>\(agreementNo ?? "")</m:AGREEMENT></m:PayMentRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
        return xmlString
    }
    
}

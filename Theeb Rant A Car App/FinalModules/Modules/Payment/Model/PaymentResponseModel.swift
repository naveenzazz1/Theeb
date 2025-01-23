//
//  PaymentResponseModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 15/08/1443 AH.
//

import Foundation
import XMLMapper


class PaymentObject  : NSObject {
    var paymentOption : String?
    var customer_email : String?
    var language : String?
    var merchantReferenec : String?
    var amount : String?
    var fortId : String?
    var carHolderName : String?
    var status : String?
    var customerIp : String?
    var eci : String?
    var currency : String?
    var sdkToken : String?
    var responseMessage : String?
    var cardNumber : String?
    var expiryDate : String?
    var command :String?
    var authorizationCode : String?
    
    
}


class PaymentRequestMappable : XMLMappable {
    
    var nodeName: String!
    var response : PaymentObjectXml?
    
    required init(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        response <- map["SOAP-ENV:Body.PAYMENTRS"]
        
    }
    
}

class PaymentObjectXml : XMLMappable {
  
    var nodeName: String!
    var success : String?
    var varianceReason :String?
    
    required init(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        success <- map["SUCCESS"]
        varianceReason <- map["VarianceReason"]
        
    }
}



import UIKit

class BasePaymentInformation: BaseModel, Codable {

    var paymentMethodId: Int?
    var amount: Price?
    var transactionNo: String?
    var cardType: Int?
    var cardNo: String?
    var merchantReferenceId: String?
    var paymentGatewayId: Int?
    
    init(paymentMethodId: Int?,
         amount: Price?,
         transactionNo: String?,
         cardType: Int?,
         cardNo: String?,
         merchantReferenceId: String?,
         paymentGatewayId: Int?) {
        
        self.paymentMethodId = paymentMethodId
        self.amount = amount
        self.transactionNo = transactionNo
        self.cardType = cardType
        self.cardNo = cardNo
        self.merchantReferenceId = merchantReferenceId
        self.paymentGatewayId = paymentGatewayId
    }
}


import UIKit

class Price: BaseModel, Codable {

    var value: Double?
    var currencyId: Int?
    var isoCode: String?
    
    init(value: Double?, currencyId: Int?, isoCode: String?) {
        
        self.value = value
        self.currencyId = currencyId
        self.isoCode = isoCode
    }
}


import Foundation

class PaymentInfo:BaseModel, Codable {
    
    var paidAmount: Double?
    var remainingAmount: Double?
    var refundAmount: Double?
    var minimumPayment: Double?
    var maximumPayment: Double?
    var defaultPayment: Double?
    var currencyIso: String?
    var currencyId: Int?
    var currencyDecimalPlaces: Int?
    
    var jsonObject: [String : Any?]? {
        return [
            "value" : remainingAmount,
            "currencyId": currencyId,
            "isoCode":  currencyIso,
        ]
    }
}



class PaymentCard: BaseModel, Codable {

    var id: Int?
    var cardTypeId: Int?
    var cardType: String?
    var cardNumber: String?
    var cardHolderName: String?
    var expiryDate: String?
    var paymentGatewayId: Int?
    var isDefault: Bool?
    var token: String?
}


// CREATE PAYMENT MODEL

class CreatePaymentModel: Codable {
    var PAYMENTRS: PAYMENTRS?
}

struct PAYMENTRS: Codable {
    var SUCCESS : String?
    var VarianceReason :String?
}

//
//  MemberTransferPointsService.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 21/03/2022.
//

import Foundation

class MemberTransferPointsService{
    
    
    func transferPoints(alfursanId : String?,
                        operation : String?,
                        passportID : String?,
                        driverCode : String? = nil,
                        royaltyPointBal : String?,
                        royaltyPointToConvert : String?
                        ,alfursanMiles : String?,
                        conversionRate : String?,
                        success: APISuccess,
                        failure: APIFailure) {
        
        NetworkManager.manager.request(soapAction: SOAPACTIONS.alfursanRequest, xmlString: alfursanRequest(alfursanId: alfursanId, operation: operation, passportID: passportID, royaltyPointBal: royaltyPointBal, royaltyPointToConvert: royaltyPointToConvert, alfursanMiles: alfursanMiles, conversionRate: conversionRate), url: BaseURL.production,success: success, failure: failure)
    }
    
    // Operation H For History or R For Convert
    
     func alfursanRequest(alfursanId : String?,operation : String?,
                          passportID : String?,
                          driverCode : String? = nil,
                          royaltyPointBal : String?,
                          royaltyPointToConvert : String?
                          ,alfursanMiles : String?,
                          conversionRate : String?) -> String? {
        
        
        return "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:AlfursanReqWS xmlns:m=\"AlfursanReqWS\"><m:AlfursanID>\(alfursanId ?? "")</m:AlfursanID><m:Operation>\(operation ?? "")</m:Operation><m:PassportID>\(passportID ?? "")</m:PassportID><m:RoyaltyPointBal>\(royaltyPointBal ?? "")</m:RoyaltyPointBal><m:RoyaltyPointToConvert>\(royaltyPointToConvert ?? "")</m:RoyaltyPointToConvert><m:AlfursanMiles>\(alfursanMiles ?? "")</m:AlfursanMiles><m:ConversionRate>\(conversionRate ?? "")</m:ConversionRate></m:AlfursanReqWS></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
     }
    
    func subscribeMemberShip(idNo:String
                             ,success: APISuccess,
                             failure: APIFailure){
        print(updateRequest(idNo: idNo))
        NetworkManager.manager.request(soapAction:  SOAPACTIONS.driverMemberShipAction, xmlString: updateRequest(idNo: idNo), url: BaseURL.production, success: success, failure: failure)
    }
    
    func updateRequest(idNo:String)->String{
       
        "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:app=\"ApplicantCreateRQ\"><soapenv:Header/><soapenv:Body><app:ApplicantImportRQ><app:IdNo>2329321174</app:IdNo><app:Mode>C</app:Mode></app:ApplicantImportRQ></soapenv:Body></soapenv:Envelope>"

        
        
       // return "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><ApplicantImportRQ><app:IdNo>2329321174</app:IdNo><app:Mode>C</app:Mode></ApplicantImportRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
    }
}


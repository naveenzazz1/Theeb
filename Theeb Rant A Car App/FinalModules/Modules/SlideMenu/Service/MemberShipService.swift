//
//  MemberShipService.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 20/03/2022.
//

import Foundation

class MemberShipService{
    func getuserMemberShip(driverID: String,
                                 success: APISuccess,
                                 failure: APIFailure) {
        
        
        NetworkManager.manager.request(isCustomLoader:false,soapAction: SOAPACTIONS.driverUpdate, xmlString: self.driverModelString(driverID: driverID), url: BaseURL.production,success: success, failure: failure)
        
        
        
    }
    
    func driverModelString(driverID:String)->String{
        return "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:DriverProfileRQ xmlns:m=\"DriverProfileRequest\"><m:IDNo>\(driverID)</m:IDNo></m:DriverProfileRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
    }

}

 

//
//  LocationsService.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 19/06/1443 AH.
//

import Foundation

class LocationsSercivce {
    
    
    
    func getBranchesLocations(success: APISuccess,
                              failure: APIFailure)  {
        
        
        NetworkManager.manager.request(soapAction: SOAPACTIONS.location, xmlString: self.location(), url: BaseURL.production, success: success, failure: failure)
        
    }
    
    
     func location() -> String? {
        
        return  "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><m:Dummy xmlns:m=\"DummyRequest\"/></SOAP-ENV:Body></SOAP-ENV:Envelope>"
    
        
    }
}



//
//  GetExtrasService.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 24/07/1443 AH.
//

import UIKit


class ExtrasService {
    
    
    func getExtras(success:APISuccess,
                failure: APIFailure) {
        
        NetworkManager.manager.request(soapAction: SOAPACTIONS.extras, xmlString: self.getExtras() ?? "", url: BaseURL.production, success: success, failure: failure)
        
        
        
    }
    
    
     func getExtras() -> String? {
        
        return "<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\"> <v:Header/> <v:Body> <qualified xmlns=\"DummyRequest\"/></v:Body></v:Envelope>"
    }
    
    
}

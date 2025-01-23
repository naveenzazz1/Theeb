//
//  ForgetPasswordModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 05/06/1443 AH.
//

import Foundation
import XMLMapper

class ForgetPasswordModel: BaseModel, XMLMappable {

    var nodeName: String!
    var success : String?
    var varianceReason : String?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        success <- map["SOAP-ENV:Body.PasswordRS.Success"]
        varianceReason <- map["SOAP-ENV:Body.PasswordRS.VarianceReason"]
        
    }
    
    
}


struct ForgetPasswordResponseModel: Codable {
    var PasswordRS: PasswordRSModel?
}
class PasswordRSModel: Codable {
    var Success: String?
    var VarianceReason: String?
}

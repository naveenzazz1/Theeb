//
//  ForgetPasswordService.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 05/06/1443 AH.
//

import Foundation
import XMLMapper
import Alamofire
class ForgetPasswordService  {
    

    func resetPasswordForSpecificOperation(operation : String?,
                                           email : String? = nil
                                           ,password: String? = nil,
                                           newPassword : String? = nil,
                                           success: APISuccess,
                                           failure: APIFailure) {
        
        NetworkManager.manager.request(soapAction:SOAPACTIONS.forgotCancel , xmlString: self.resetPassword(operation: operation, email: email, password: password ?? "", newPassword: newPassword ?? ""), url: BaseURL.production, success: success, failure: failure)
        
       
        
    }
    
    func resetPassword(operation : String?,
                       email : String?
                       ,password: String? = nil,
                       newPassword : String? = nil) -> String
    {
        var xmlString : String?
        
        if(operation ?? "" == "S")
        
        {
            
            // Send Otp
            xmlString = "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:PasswordRQ xmlns:m=\"DriverPasswordReset\"><m:Mode>S</m:Mode><m:Email>\(email ?? "")</m:Email><m:Password></m:Password><m:NewPassword></m:NewPassword></m:PasswordRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        }
        else if (operation ?? "" == "V")
        {
            
            // change
            xmlString = "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:PasswordRQ xmlns:m=\"DriverPasswordReset\"><m:Mode>V</m:Mode><m:Email>\(email ?? "")</m:Email><m:Password>\(password ?? "")</m:Password><m:NewPassword>\(newPassword ?? "")</m:NewPassword></m:PasswordRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
            
        }
        else{
            
            // Forget
            
            xmlString = "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><SOAP-ENV:Body><m:PasswordRQ xmlns:m=\"DriverPasswordReset\"><m:Mode>R</m:Mode><m:Email>\(email ?? "")</m:Email><m:Password>\(password ?? "")</m:Password><m:NewPassword>\(newPassword ?? "")</m:NewPassword></m:PasswordRQ></SOAP-ENV:Body></SOAP-ENV:Envelope>"
            
        }
        
        return xmlString ?? ""
    }
    
}


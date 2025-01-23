//
//  TheebElkheirService.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 28/12/1443 AH.
//

import Foundation

class EshasnService {
    
    func getehsanToken(clientId:String?,
                       clientSecret: String?,
                       grantType: String?,
                       token : String? = nil,
                       success: APISuccess,
                       failure: APIFailure) {
        
        let parameters: [String : Any] = ["client_id": clientId ?? "",
                                          "client_secret": clientSecret ?? "",
                                          "grant_type" : "client_credentials" ]
        
        var configration = APIConfiguration()
        configration.handleResponseModelManually = true

        let endPoint =   EndPoint(path: "", method: .post, parameters: parameters, encoding: .url, configurations: configration, fullURL:EhsanAPIS.GetToken )
  
 
        NetworkManager.manager.requestForJson(endPoint: endPoint, success: success, failure: failure)

        
    }
    
    
    func getIntiavtiveType(success: APISuccess,
                            failure: APIFailure) {
        var configration = APIConfiguration()
        configration.handleResponseModelManually = true
     
        
        let endPoint = EndPoint(path: EhsanAPIS.GetIntiatives,
                                method: .get,
                                parameters: nil,
                                configurations: configration,
                                fullURL: "")
        
        
        
        NetworkManager.manager.requestForJson(endPoint: endPoint, success: success, failure: failure)

    
}
    
    func donate(amount: Int?,
                InitiativetypeId: Int?,
                mobile : String? = CachingManager.loginObject()?.mobileNo,
                agentId : String? = "7",
                showFlag : Bool? = true,
                success: APISuccess,
                failure: APIFailure) {
        
        var configration = APIConfiguration()
        configration.handleResponseModelManually = true
        
        let parameters: [String : Any] = ["Amount": amount ?? 0,
                                          "InitiativetypeId": InitiativetypeId ?? 0,
                                          "Mobile" : mobile ?? CachingManager.loginObject()?.mobileNo ?? "" ,
                                          "AgentId" : agentId ?? "" ,
                                          "ShowFlag" : showFlag ?? true ]
        
        let endPoint = EndPoint(path: "",
                                method: .post,
                                parameters: parameters,
                                configurations: configration,
                                fullURL: EhsanAPIS.Donate)
        
        NetworkManager.manager.requestForJson(endPoint: endPoint, success: success, failure: failure)
        
    }


}

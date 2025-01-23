//
//  DonationVeiwModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 21/03/1444 AH.
//

import UIKit

class DonationViewModel {
    
    lazy var service = EshasnService()
    
    func getEhsanServicesToken() {
        
        
        service.getehsanToken(clientId: EhsanCredentials.ClientId, clientSecret:EhsanCredentials.SectetId , grantType: EhsanCredentials.GrantType, token: nil) { response in
            
            if  let response = AuthentcationModel(from: response) {
                CachingManager.store(value: response.accessToken, forKey: CachingKeys.EhsanToken)
                
            }
            
        } failure: { response, error in
            
        }
        
        
        
    }
    
}


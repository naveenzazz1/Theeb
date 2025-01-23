//
//  OffersService.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 12/10/1443 AH.
//

import Foundation

class GetOffersService  {
    
    // MARK: - API Calling
    
    func getOffersList(success: APISuccess, failure: APIFailure) {
    
        NetworkManager.manager.requestoofers(url: BaseURL.offers, success: success, failure: failure)

       
    }
}

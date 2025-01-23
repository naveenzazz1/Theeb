//
//  OffersViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 12/10/1443 AH.
//

import Foundation

class GetOffersViewModel {
    
    // MARK: - Variabels
    

    lazy var service = GetOffersService()
    lazy var offers = [OfferElement?]()
    var reloadCollectionView: (() -> ())?
      var applyAnimation : (() -> ())?
    // MARK: -API Calling
    
    func getOfferstData() {
        service.getOffersList(success: { (response) in
          
          guard let offersResponse = response as? [Any?] else {return}
            self.offers = offersResponse.map{(OfferElement(from: $0))}
            self.reloadCollectionView?()
            self.applyAnimation?()
        }, failure:nil)
    }
}

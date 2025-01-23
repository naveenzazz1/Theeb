//
//  OffersCollectionViewCell.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 26/09/1443 AH.
//

import UIKit
import AlamofireImage
class OffersCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    func showOffer (offer : OfferElement?) {
        offerImageView.image = nil
        
        if let imageUrlString = offer?.offerImage {
            if let imageUrl = URL(string: NetworkConfigration.imageURL + imageUrlString + ".jpg") {
                offerImageView.af.setImage(withURL: imageUrl)
            }
        }

        
    }
    
}

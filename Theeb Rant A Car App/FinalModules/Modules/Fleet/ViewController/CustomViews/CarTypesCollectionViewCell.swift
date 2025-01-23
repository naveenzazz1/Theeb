//
//  CarTypesCollectionViewCell.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 18/07/1443 AH.
//

import UIKit

class CarTypesCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var imgViewCar: UIImageView?
    @IBOutlet weak var backGroundView: UIView!
      
   
    
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var cartTypeName: UILabel!
  
    override func prepareForReuse() {
        super.prepareForReuse()
        imgViewCar?.image = nil
    }
    
    func showType(_ type:VehicleTypeModel? , _ fromFleet: Bool? = nil ) {
        
//        if type?.isSelected  ?? false {
//            contentView.borderWidth = 1.0
//            contentView.borderColor = .theebPrimaryColor
//           
//        }else {
//            contentView.borderWidth = 0
//            if fromFleet == false {
//                backGroundView.backgroundColor = .white
//            }
//        
//            cartTypeName.textColor = .theebPrimaryColor
//          
//        }
        
        if !(Language.isRTL) {
            cartTypeName.text  = type?.description_2 ?? ""
        } else {
            cartTypeName.text  = type?.desc ?? ""
          
        }
      
      
//        if serviceImage != nil {
//            serviceImage.image = UIImage(named: type?.desc ?? "Compact")
//        }
        if serviceImage != nil {
            serviceImage.image = nil
            if let imageUrlString = type?.code,
               let imageUrl = URL(string: NetworkConfigration.imageURL + imageUrlString + ".png") {
                serviceImage.af.setImage(withURL: imageUrl)
            }
        }
        
    }
    
    func showService(_ service : OurServiceModel? ) {
    
       
        cartTypeName.text  = service?.title ?? ""
        serviceImage.image = UIImage(named: service?.imageName ?? "")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 8.0
       
    }
    
    
}

//
//  VechileTableViewCell.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 11/07/1443 AH.
//

import UIKit
import AlamofireImage
class VechileTableViewCell: UITableViewCell {

    @IBOutlet weak var modelYearLabel: UILabel!
    @IBOutlet weak var insuranceLabel: UILabel! {
        didSet {
            insuranceLabel.text = "fleet_insurance".localized
        }
    }

    @IBOutlet weak var petrolType: UILabel!
    @IBOutlet weak var seatsNumber: UILabel!
    @IBOutlet weak var carCategoryLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var pricePerDayLabel: UILabel!
    @IBOutlet weak var vatNotIncludedLbel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var mFreeLabel: UILabel!  {
        didSet{
            
            mFreeLabel.text =  "fleet_22km_free".localized
            

        }
    }
    var insurancePrice : String?
    var price:String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showCar(_ car: CarGroup?) {
        
        carImageView.image = nil
        if let imageUrlString = car?.group,
            let imageUrl = URL(string: NetworkConfigration.imageURL + imageUrlString + ".jpg") {
            carImageView.af.setImage(withURL: imageUrl)
        }
        modelYearLabel.text = car?.modelVersion ?? ""
        carTypeLabel.text = car?.vehTypeDesc ?? ""
        carCategoryLabel.text = (UIApplication.isRTL()) ? car?.vthDescription ?? "" : car?.vthDesc ?? ""
        petrolType.text = car?.modelFuelDesc ?? ""
        vatNotIncludedLbel.text =   "fleet_vat_not_included" .localized
        seatsNumber.text = String(format: "%@ \("fleet_seats".localized)", car?.modelNoOfPassenger ?? "")

    }

    

}

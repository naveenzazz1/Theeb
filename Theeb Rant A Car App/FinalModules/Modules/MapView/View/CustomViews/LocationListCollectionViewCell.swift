//
//  LocationListCollectionViewCell.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 23/06/1443 AH.
//

import UIKit

import UIKit

class LocationListCollectionViewCell: UICollectionViewCell {
    
   
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var branchNameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    let isArabic = UIApplication.isRTL()

    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }
    
    func showLocation(location: Branch?) {
          
//        "km_hint" = "كم";
//        "min_hint" = "دقيقة";
        branchNameLabel.text = isArabic ? location?.branchName:location?.branchNameTranslated ?? ""
        let dist = String(format: "%.2f", ((Double(location?.distance ?? "0") ?? 0)/1000))
        let time = String(format: "%.1f", (Double(location?.time ?? "0") ?? 0))
        distanceLabel.text = "\(dist) \("km_hint".localized)"
        timeLabel.text =  "\(time) \("min_hint".localized)"
    }
    
}

extension String {
   func first(char:Int) -> String {
        return String(self.prefix(char))
    }

    func last(char:Int) -> String
    {
        return String(self.suffix(char))
    }

    func excludingFirst(char:Int) -> String {
        return String(self.suffix(self.count - char))
    }

    func excludingLast(char:Int) -> String
    {
         return String(self.prefix(self.count - char))
    }
 }

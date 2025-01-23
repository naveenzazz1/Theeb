//
//  ExtrasTableViewCell.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 24/07/1443 AH.
//

import UIKit

class ExrtrasTableViewCell : UITableViewCell {
    
    @IBOutlet weak var infoBtn: UIButton! {
        didSet {
            infoBtn.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var extaName: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var extraPriceLabel: UILabel!
    
    var selectExtraButtonAction :(() -> ())?
    let isArabic = UIApplication.isRTL()

    func showExtra(_ extra:(ExtType?,Bool)?) {
        
        extaName.text  = (isArabic ? ((extra?.0?.desc == "") ? extra?.0?.nameTranslated : extra?.0?.desc): ((extra?.0?.nameTranslated) == "") ? extra?.0?.desc : extra?.0?.nameTranslated) ?? extra?.0?.desc 
        extraPriceLabel.text  = "\("+ ")\(String(describing: extra?.0?.amount ?? "" ))" + "sar".localized
        print(extra?.1,"zzzz cell")
        selectButton.isSelected = extra?.1 ?? false

    }
    
    
    
    @IBAction func selectExtraButtonAction(_ sender: Any) {
        
        selectExtraButtonAction?()
        
    }
}

//
//  BrandTableViewCell.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 18/07/1443 AH.
//

import UIKit

class BrandTableViewCell: UITableViewCell {

    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var brandNameLbel: UILabel!
   
    var slectBtnAction: (() -> ())?
    var selectedd: Bool? = false
    
    func showBrand(_ brand :Brand? ) {
        
        brandNameLbel.text  = brand?.makeName ?? ""
        checkButton.isSelected = brand?.isSelected ?? false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
        // Configure the view for the selected state
    }
    
    @IBAction func checkBtnAction(_ sender: Any) {
        
        slectBtnAction?()
    }
    
}

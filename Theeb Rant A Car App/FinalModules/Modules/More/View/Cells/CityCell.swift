//
//  CityCell.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 04/04/2022.
//

import UIKit

class CityCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCity: CustomTextField!
    
    static var identifier:String {
       String(describing: CityCell.self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lblCity.isUserInteractionEnabled = false
    }
    
    func heightLighCell(_ isHeighCell: Bool){
        lblCity.textColor = isHeighCell ? .white: #colorLiteral(red: 0.3843137026, green: 0.3843137026, blue: 0.3843137026, alpha: 1)
        lblCity.backgroundColor = isHeighCell ? UIColor.theebPrimaryColor:UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lblCity.layer.borderColor = #colorLiteral(red: 0.3843137026, green: 0.3843137026, blue: 0.3843137026, alpha: 1).cgColor
        lblCity.layer.borderWidth = 1.4
    }
}

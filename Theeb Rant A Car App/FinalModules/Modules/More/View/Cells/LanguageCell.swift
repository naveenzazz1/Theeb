//
//  LanguageCell.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 11/06/2023.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var btnCheckLang: UIButton!
    @IBOutlet weak var lblLanguage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    static var identifier:String {
       String(describing: LanguageCell.self)
    }

   
    
}

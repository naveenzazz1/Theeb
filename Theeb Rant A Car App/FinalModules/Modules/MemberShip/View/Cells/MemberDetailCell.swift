//
//  MemberDetailCell.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 12/05/2022.
//

import UIKit

class MemberDetailCell: UITableViewCell {
    
    @IBOutlet weak var imgViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var imgViewLeading: NSLayoutConstraint!
    @IBOutlet weak var imgViewTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var isPadding = false{
        didSet{
            imgViewLeading.constant = isPadding ? 16:0
        }
    }
    
    static var identifier:String {
       String(describing: MemberDetailCell.self)
    }

    
}

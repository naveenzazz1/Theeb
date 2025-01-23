//
//  MembershipTypeView.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 12/02/2023.
//

import UIKit

class MembershipTypeView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgMember: UIImageView!
    @IBOutlet weak var lblDiscountEng: UILabel!
    @IBOutlet weak var lblDiscountArabic: UILabel!
    @IBOutlet weak var lblMEmberIDEng: UILabel!
    @IBOutlet weak var lblMemberIDEng: UILabel!
    @IBOutlet weak var lblNameArabic: UILabel!
    @IBOutlet weak var lblNAmeEng: UILabel!
    
    let gradient = CAGradientLayer()
    var member:MemberElement?{
        didSet{
            guard let member = member else {
                return
            }
            imgMember.image = UIImage(named: member.imageBannerName)
            gradient.frame = containerView.bounds
            gradient.colors = [member.memberGradientColor.1.cgColor, member.memberGradientColor.0.cgColor,member.memberGradientColor.1.cgColor]
            containerView.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialSetup()
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()

    }
    
    func initialSetup() {
    addSubview(loadXibView(with: bounds))
    }

}

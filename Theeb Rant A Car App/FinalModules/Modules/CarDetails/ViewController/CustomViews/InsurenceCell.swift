//
//  InsurenceCell.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 07/01/2024.
//

import UIKit

class InsurenceCell: UITableViewCell {

    @IBOutlet weak var recomendHeight: NSLayoutConstraint!
    @IBOutlet weak var lblRecomended: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblInsurenceType: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblRecomended.flash()
    }
    
    static var identifier:String {
       String(describing: InsurenceCell.self)
    }
    
    func setupCell(insurence: InsType, isRecomend: Bool, isSelect:Bool){
        lblRecomended.isHidden = !isRecomend
        recomendHeight.constant = isRecomend ? 21:0
        lblPrice.text = "\("+ ")\(String(describing: insurence.amount ?? ""))" +  "sar".localized
        lblInsurenceType.text =  UIApplication.isRTL() ? insurence.desc:insurence.nameTranslated
        btnSelect.setImage(UIImage(named: isSelect ? "CheckForExtras":"UnchekForExtras"), for: .normal)
        if insurence.code?.lowercased() == "cdw" {
            lblInsurenceType.text =  UIApplication.isRTL() ? "التأمين الجزئي": "Partial Insurance"
        } else if insurence.code?.lowercased() == "scdw" {
            lblInsurenceType.text =  UIApplication.isRTL() ? "تأمين ذيب الاضافي": "THEEB Insurance"
        }
    }
    
    override func prepareForReuse() {
        btnSelect.setImage(UIImage(named: "UnchekForExtras"), for: .normal)
    }

}

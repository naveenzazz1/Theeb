//
//  BeAmember.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 10/04/2022.
//

import UIKit
class BeAmember:UIView{
    
    //outlets
    @IBOutlet weak var lblBecomeHint: UILabel!
    @IBOutlet weak var btnLearn: UIButton!
    @IBOutlet weak var lblBeAmember: UILabel!
    
    //vars
    var complition:(()->Void)?
    
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
        lblBeAmember.text = "profile_membershipBeAMember".localized
        lblBecomeHint.text = "profile_membershipBenifits".localized
        btnLearn.setTitle("memberDetails_learnMore".localized, for: .normal)
        btnLearn.layer.cornerRadius = 4
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    
    @IBAction func btnLearnMorePressed(_ sender: UIButton) {
        complition?()
    }
    
}

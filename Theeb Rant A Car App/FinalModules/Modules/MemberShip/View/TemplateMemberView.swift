//
//  TemplateMemberView.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 15/03/2022.
//

import UIKit

protocol TemplateMemberViewDelegate:AnyObject{
    func btnLeranPressed(memberElmnt:MemberElement?)
}

class TemplateMemberView: UIView {
    
    //vars
    var memberElment:MemberElement?
    weak var memberDelegate:TemplateMemberViewDelegate?
    let gradient = CAGradientLayer()
    
    @IBOutlet weak var lblArabicMemberShip: UILabel!
    @IBOutlet weak var lblengMemberShip: UILabel!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerGradientView: UIView!
    @IBOutlet weak var imgViewBanner: UIImageView!
    @IBOutlet weak var imgViewBenifits: UIImageView!
    @IBOutlet weak var imgViewNumber: UIImageView!
    @IBOutlet weak var stackViewMaak: UIStackView!
    @IBOutlet weak var btnLearn: ButtonRounded!{
        didSet{
            btnLearn.setTitle("memberDetails_learnMore".localized, for: .normal)
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
        hideORshowStack(hide: true)
    }
    
    func hideORshowStack(hide:Bool,memberID:String = "",val:CGFloat = 0){
        clipsToBounds = true
        layer.cornerRadius = 16
        mainStackView.isHidden = hide
        [stackViewMaak,imgViewNumber].forEach{
            $0?.isHidden = !hide
        }
        stackViewHeight.constant = val
        lblengMemberShip.text = memberID
        lblengMemberShip.textAlignment = .left
        lblArabicMemberShip.text = memberID.enToArDigits
        lblArabicMemberShip.textAlignment = .right

    }
    

    func initImageViews(imgBackGround:UIImage?){
        guard let imgBackGround = imgBackGround else {return}
        backgroundColor = UIColor(patternImage:imgBackGround.resized(toWidth: bounds.height)!)
    }
    
    func configTemplateView(member:MemberImages){
        imgViewBanner.image = UIImage(named: member.banner ?? "")
        imgViewBenifits.image = UIImage(named: member.benefits ?? "")
        gradient.frame = containerGradientView.bounds
        gradient.colors = [member.backGroundColors.1.cgColor, member.backGroundColors.0.cgColor,member.backGroundColors.1.cgColor]
        containerGradientView.layer.insertSublayer(gradient, at: 0)
        backgroundColor = member.backGroundColors.0
    }

    @IBAction func btnLearnPressed(_ sender: UIButton) {
        memberDelegate?.btnLeranPressed(memberElmnt: memberElment)
    }
}

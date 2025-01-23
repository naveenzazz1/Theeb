//
//  MemberShipVc.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 15/03/2022.
//

import UIKit


class MemberShipVc: BaseViewController {
    
    //vars
    var viewModel = MemberViewModel()
    var memberTitle:String?
    
    //outlets
    @IBOutlet weak var fursanVie: UIView!
    @IBOutlet weak var lblStaticTrnsfer: UILabel!
    @IBOutlet weak var lblStaticElforsan: UILabel!
    @IBOutlet weak var btnUpgrade: ButtonRounded!
    @IBOutlet weak var btnTransfer: UIButton!
    @IBOutlet weak var lblStaticTransfeerPoints: UILabel!
    @IBOutlet weak var silverImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setSilverImg()
        viewModel.pushViewController = {[weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupViews(){
      //  containerView.configTemplateView(member: MemberImages.memberArr[2])
        btnUpgrade.addTarget(self, action: #selector(btnUpgradePressed(_:)), for: .touchUpInside)
        btnTransfer.addTarget(self, action: #selector(btnTransferPressed(_:)), for: .touchUpInside)
        lblStaticTrnsfer.text = "memberShipVc_Transfer_Theep".localized
        lblStaticElforsan.text = "memberShipVc_Alfursan".localized
        btnUpgrade.setTitle("memberShipVc_Alfursan_upgrade".localized, for: .normal)
        lblStaticTransfeerPoints.text = "memberShipVc_Transfeer_Point_Btn".localized
        let leftBarBtn = UIBarButtonItem(image: UIImage(named: "Back Arrow"), style: .plain, target: self, action: #selector(backBtnPressed))
        fursanVie.layer.cornerRadius = 16
        navigationItem.leftBarButtonItem = leftBarBtn
        title = "rental_memberShipTitle".localized
        btnTransfer.setImage(UIImage(named: "ArrowLine"), for: .normal)
        lblStaticTransfeerPoints.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnTransferPressed(_:))))
    }
    
    @objc func backBtnPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    func setSilverImg(){
        if memberTitle == nil{
        // memberTitle = CachingManager.memberDriverModel?.membership.cardType
            memberTitle = CachingManager.memberDriverModel?.membership?.cardType
        }
        switch memberTitle{
        case "فضية" :
            //silverImg.image = UIImage(named: "silverQrMember")
            addTemplateView(elemnt: MemberImages.memberArr[1])
        case "ذهبية" :
            //silverImg.image = UIImage(named: "goldenQrMember")
            addTemplateView(elemnt: MemberImages.memberArr[2])

        case "برونزية":
            //silverImg.image = UIImage(named: "bronzQrMember")
            addTemplateView(elemnt: MemberImages.memberArr[0])

        case "عطاء" :
            //silverImg.image = UIImage(named: "greenQrMember")
            addTemplateView(elemnt: MemberImages.memberArr[3])

        case "ماسية":
           // silverImg.image = UIImage(named: "diamondQrMember")
            addTemplateView(elemnt: MemberImages.memberArr[4])

            btnUpgrade.isHidden = true
        default:
            silverImg.image = UIImage(named: "silverQrMember")
        }
    }
    
    func addTemplateView(elemnt:MemberImages){
        let templateMemberView = TemplateMemberView()
        templateMemberView.memberDelegate = self
        templateMemberView.memberElment = elemnt.memberElemnt
        silverImg.addSubview(templateMemberView)
        templateMemberView.fillSuperview()
     //  if let memberID = CachingManager.memberDriverModel?.memberShip.membershipNo{
        if let memberID = CachingManager.memberDriverModel?.membership?.membershipNo {
           templateMemberView.hideORshowStack(hide: false,memberID:memberID,val:silverImg.frame.height/12)
     }
        templateMemberView.configTemplateView(member: elemnt)
    }
    
    class func initializeFromStoryboard() -> MemberShipVc {
        
        let storyboard = UIStoryboard(name: "MemberShip", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: MemberShipVc.self)) as! MemberShipVc
    }
    
    @objc func btnTransferPressed(_ btn:UIButton) {
        viewModel.pushAlforsanVc()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.MyMembership, screenClass: String(describing: MemberShipVc.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.MyMembership, screenClass: String(describing: MemberShipVc.self))
    }
    
    
    @objc func btnUpgradePressed(_ btn:UIButton){
        viewModel.pushAllMembers()
    }
    

}

extension MemberShipVc:TemplateMemberViewDelegate{
    func btnLeranPressed(memberElmnt: MemberElement?) {
        let memberDetails = MemberDetailsVC.initializeFromStoryboard()
        memberDetails.hideClose = true
        memberDetails.memberElement = memberElmnt ?? .silver
        self.navigationController?.pushViewController(memberDetails, animated: true)
    }
    
}

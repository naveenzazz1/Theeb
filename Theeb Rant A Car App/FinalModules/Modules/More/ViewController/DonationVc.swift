//
//  DonationVc.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 25/07/2022.
//

import UIKit

class DonationVc: BaseViewController {
    
    //vars
    var donateAmount = AmounttoDonate.donate10

    //outlets
    @IBOutlet weak var heightConstraintAmountView: NSLayoutConstraint!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var btn100Sr: UIButton!
    @IBOutlet weak var btn50Sr: UIButton!
    @IBOutlet weak var btn10Sr: UIButton!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var btnDonate: UIButton!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var txtFieldAmount: UITextField!
    @IBOutlet var btnAmountArr: [UIButton]!
    @IBOutlet weak var lblStaticDonationamount: UILabel!
    @IBOutlet weak var txtFieldDomain: DropDown!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblStaticDonationDomain: UILabel!
    @IBOutlet weak var lblStaticDonate: UILabel!
    @IBOutlet weak var btnReadMore: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    
    enum AmounttoDonate:Int{
        case donate10 = 10
        case donate50 = 50
        case donate100 = 100
        case donateOther
    }
    
    lazy var service = EshasnService()
    lazy var viewModel = DonationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setLocalize()
        viewModel.getEhsanServicesToken()
    }

    func setupViews() {
        setAmountBtn(btn10Sr)
        handleDomainTxtfield()
        viewAmount.isHidden = true
        txtFieldAmount.keyboardType = .asciiCapableNumberPad
        [btnDonate,btnReadMore].forEach{
            $0?.layer.cornerRadius = 8
        }
        [containerView,viewAmount].forEach{
            setBoderForView($0)
        }
        btnDonate.addTarget(self, action: #selector(btnDonatePressed(_:)), for: .touchUpInside)
        btnReadMore.addTarget(self, action: #selector(btnReadMorePressed(_:)), for: .touchUpInside)
    }
    
    func handleDomainTxtfield(){
        //txtNationality.placeholder = "profile_Nationality".localized
        txtFieldDomain.arrow.isHidden = true
        txtFieldDomain.isImage = false
       // txtNationality.setRightPaddingPoints(20, view: nil)
       // txtNationality.text = "Saudi Arabia"
//        if let locations =  fillNAtionalityArr() {
        txtFieldDomain.optionArray = ["first donate","secound donate","third donate"]
//        }
        txtFieldDomain.selectedRowColor = .clear
        txtFieldDomain.didSelect {  [weak self] (text, index, id) in
          print(text)
        }
    }
    
    func setLocalize() {
        title = "more_Ehsan_title".localized
        btnReadMore.setTitle("more_Ehsan_readMore".localized, for: .normal)
        btnDonate.setTitle("more_Ehsan_Donate".localized, for: .normal)
        btnOther.setTitle("more_Ehsan_Other".localized, for: .normal)
        btn10Sr.setTitle("more_Ehsan_10Sr".localized, for: .normal)
        btn50Sr.setTitle("more_Ehsan_50Sr".localized, for: .normal)
        btn100Sr.setTitle("more_Ehsan_100Sr".localized, for: .normal)
        lblStaticDonate.text = "more_Ehsan_Donate".localized
        lblDescription.text = "more_Ehsan_Description".localized
        lblStaticDonationamount.text = "more_Ehsan_DonationAmount".localized
        lblStaticDonationDomain.text = "more_Ehsan_DonationDomain".localized
        lblCurrency.text = "sar".localized
    }
    
    func setAmountBtn(_ btn:UIButton){
        btnAmountArr.forEach{
            setBoderForView($0)
            $0.backgroundColor = .white
            $0.tintColor = .lightGray
        }
        btn.backgroundColor = .theebPrimaryColor
        btn.tintColor = .white
        btn.layer.borderColor = UIColor.clear.cgColor
    }
    
    func setBoderForView(_ childView:UIView){
        childView.layer.cornerRadius = 8
        childView.layer.borderColor = UIColor.weemGrayBorder.cgColor
        childView.layer.borderWidth = 1.0
    }
    
    class func initializeFromStoryboard() -> DonationVc {
        
        let storyboard = UIStoryboard(name: "MoreContent", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: DonationVc.self)) as! DonationVc
    }

    func animateView(isHidden:Bool){
        heightConstraintAmountView.constant = isHidden ? 0:view.frame.height/12
        self.viewAmount.isHidden = isHidden
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    func getAmount()->Int{
        switch donateAmount {
        case .donate10:
            return AmounttoDonate.donate10.rawValue
        case .donate50:
            return AmounttoDonate.donate50.rawValue
        case .donate100:
            return AmounttoDonate.donate100.rawValue
        case .donateOther:
            if let val = txtFieldAmount.text,let amount = Int(val){
                return amount
            }
            return 0
        }
    }
    
    @objc func btnDonatePressed(_ btn:UIButton){
        print(getAmount())
    }
    
    @objc func btnReadMorePressed(_ btn:UIButton){
        let privacyVc = PrivacyPolicyVC.initializeFromStoryboard()
        privacyVc.isFromMore = false
        navigationController?.pushViewController(privacyVc, animated: true)
    }
    
    @IBAction func btnAmountPressed(_ sender: UIButton) {
        setAmountBtn(sender)
        animateView(isHidden: true)
        switch sender{
        case btn10Sr:
            donateAmount = .donate10
        case btn50Sr:
            donateAmount = .donate50
        case btn100Sr:
            donateAmount = .donate100
        case btnOther:
            donateAmount = .donateOther
            animateView(isHidden: false)
        default:
            break
        }
    }
    
}

//
//  ImagePopUpView.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 23/08/2022.
//

import UIKit
import Firebase


class TextViewPopUp: UIView {
    
    var delegate:ImagePopUpViewDelegate?

    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
          lblTitle.text = "checkOutVC_TermsAndCond".localized
        }
    }
    
    lazy var htmlString = "" {
        didSet{
            txtView.attributedText = htmlString.html2Attributed
        }
    }
    
    @IBOutlet var txtView: UITextView!
    @IBOutlet weak var btnClose: UIButton!
  
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
        btnClose.addTarget(self, action: #selector(btnClosePessed), for: .touchUpInside)
        getTermsFromRemoteCongig()
    }
    
    func getTermsFromRemoteCongig(){
        var result = false
        let remoteConfig = RemoteConfig.remoteConfig()
        if let paymentRequiredDic = remoteConfig["terms_and_Conditions_dictionary"].jsonValue as? [String : AnyObject] {
            switch Language.currentLanguage{
            case .english:
                htmlString = paymentRequiredDic["termsAndCondidtions_English"] as? String ?? ""
            case .arabic:
                htmlString = paymentRequiredDic["termsAndCondidtions_Arabic"] as? String ?? ""
            case .french:
                htmlString = paymentRequiredDic["termsAndCondidtions_French"] as? String ?? ""
            default:
                htmlString = paymentRequiredDic["termsAndCondidtions_English"] as? String ?? ""
            }
        }
    }

    @objc func btnClosePessed(){
        delegate?.btnCloseDelegatePressed()
    }
}

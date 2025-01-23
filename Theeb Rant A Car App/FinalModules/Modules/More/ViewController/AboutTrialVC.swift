//
//  AboutTrialVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 05/04/2022.
//

import UIKit

class AboutTrialVC: BaseViewController {
    
    let textView:UITextView = {
        let txtView = UITextView()
        txtView.font = UIFont.BahijTheSansArabicSemiBold(fontSize: 15)
        txtView.textColor = UIColor.darkGray
        txtView.textAlignment = .center
        txtView.isUserInteractionEnabled = false
        return txtView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        textView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 32, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
    }
    
    class func initializeFromStoryboard() -> AboutTrialVC {
        
        let storyboard = UIStoryboard(name: "MoreContent", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: AboutTrialVC.self)) as! AboutTrialVC
    }
}

//
//  aboutVCViewController.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 10/08/1443 AH.
//

import UIKit

class AboutDetailVc: BaseViewController {
  
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDismiss: UIButton! {
        didSet {
            btnDismiss.isHidden = true
        }
    }
    @IBOutlet weak var lblContent: UILabel!
    
    
    var fromHome : Bool? = false
    var contentString : String?
    var titleStrig: String?
    
    // MARK: -View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title =   titleStrig ?? "more_aboutheeb_title".localized
        lblContent.text = contentString ?? ""
       // lblTitle.text =
        if fromHome ?? false {
            btnDismiss.isHidden = false

        }
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.AboutTheeb, screenClass: String(describing: AboutDetailVc.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.AboutTheeb, screenClass: String(describing: AboutDetailVc.self))
    }
    
    
    // MARK: -Intialization
    
    class func initializeFromStoryboard() -> AboutDetailVc {
        
        let storyboard = UIStoryboard(name: "MoreContent", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: AboutDetailVc.self)) as! AboutDetailVc
    }
    
    
    
    // MARK: -Actions
    
   
    
    @IBAction func btnDismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

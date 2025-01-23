//
//  SucessScreenForBookingVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 16/08/1443 AH.
//

import UIKit

class SucessScreenForBookingVC: BaseViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var backToDetailsBtn: UIButton! {
     
        didSet {
            backToDetailsBtn.setTitle( "suecess_goto_details".localized, for: .normal)
        }
    }
    @IBOutlet weak var yourBookingNumberLabel: UILabel! {
        didSet {
            yourBookingNumberLabel.text = String(format: "\("success_booking_number_is".localized) : %@", "\(bookingNumber ?? "")")
        }
    }
    @IBOutlet weak var yourReservationAcceptingHoursLabel: UILabel!
    @IBOutlet weak var paymentSucessLabel: UILabel! {
        didSet {
            paymentSucessLabel?.text  = titleString ?? ""
        }
    }
    
    @IBOutlet weak var topLogoImage: UIImageView!
    var titleString: String?
    var bookingNumber  = String()
    var isFromPayment: Bool = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationController?.navigationBar.isHidden = true
        backToDetailsBtn.setTitle("successScreen_backToDetails".localized, for: .normal)
      yourReservationAcceptingHoursLabel.text = "successScreen_confrimAfterOneHour".localized
       paymentSucessLabel.text = titleString ?? ""
        
        self.topLogoImage.transform = CGAffineTransform(scaleX: 0, y: 0)
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.topLogoImage.image = UIImage(named: "SuccessPaymentIcon")
                    self.topLogoImage.transform = .identity
                }, completion: nil)
    
        
    }
    
    
    
    // MARK: - intilaization
    
    class func initializeFromStoryboard() -> SucessScreenForBookingVC  {
        
        let storyboard = UIStoryboard(name: StoryBoards.Checkout, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: SucessScreenForBookingVC.self)) as! SucessScreenForBookingVC
    }
    
    func navigateToBarItem(tabBarItem: TabBarItems) {
        
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: false, completion: nil)
    
        var nav =   UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController as? UINavigationController
        
        if nav == nil {
            
            let landindPageVC = LandingPageVC.initializeWithNavigationController()
            
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = landindPageVC
            nav = landindPageVC
        }
            
        nav?.popToRootViewController(animated: true)
        
        let tabBarVC = (nav?.viewControllers.first as? LandingPageVC)
        
        if tabBarVC?.viewControllers == nil {
            tabBarVC?.setupTabBar()
        }
        
        let homeTabItemIndex = tabBarItem.rawValue
        if homeTabItemIndex < (tabBarVC?.viewControllers?.count ?? 0) {
            tabBarVC?.selectedViewController = tabBarVC?.viewControllers?[homeTabItemIndex]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.ReservationSuccess, screenClass: String(describing: SucessScreenForBookingVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.ReservationSuccess, screenClass: String(describing: SucessScreenForBookingVC.self))
    }

    // MARK: - Actions
    
    @IBAction func backToDetailsBtnAction(_ sender: Any) {
        if isFromPayment {
            self.dismiss(animated: true)
        } else {
            let landVc = LandingPageVC.initializeWithNavigationController()
            if let tabVC = landVc.visibleViewController as? LandingPageVC{
                tabVC.resetHomeVcTextField()
            }
            //   UserDefaults.standard.set(nil, forKey: CachingKeys.Locations)
            //UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = landVc
            navigateToBarItem(tabBarItem: .MyRental)
        }
        
      
}
    
}

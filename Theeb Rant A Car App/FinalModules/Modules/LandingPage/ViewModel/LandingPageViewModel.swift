//
//  LandingPageViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 08/06/1443 AH.
//
import UIKit

class LandingPageViewModel {

    
    // MARK - Constants
    let islogged = (CachingManager.loginObject() != nil)

    let itemFontSize: CGFloat = 11.0
    var firstVC : UIViewController? =  HomeVC.initializeWithNavigationController()
    
    // MARK - Variables
    
    lazy var exploreVC = firstVC
    lazy var myRentalVC =  islogged ?  MyRentalVC.initializeWithNavigationController() : GuestLoginVC.initializeWithNavigationController()
    lazy var profileVC = islogged ? SlideMenuVC.initializeWithNavigationController() : GuestLoginVC.initializeWithNavigationController()
    
   lazy var moreVC = MoreVC.initializeNavigationController()
    lazy var homeVC = SendotpVC.initializeFromStoryboard()

    
    
    // MARK - Setup

    func setupViewControllersItems() {

        profileVC.tabBarItem = tabBarItem(withItemName: "landing_page_my_account_item".localized, imageName: "My_Account_Item")
        myRentalVC.tabBarItem = tabBarItem(withItemName: "landing_page_my_booking_item".localized, imageName: "My_Bookings_Item")
        firstVC?.tabBarItem = tabBarItem(withItemName: "landing_page_book_weem_item".localized, imageName: "WEEM_Item")
        moreVC.tabBarItem = tabBarItem(withItemName: "landing_page_more_item".localized, imageName: "More_Item")
    }
    
    func tabBarViewControllers() -> [UIViewController] {
        
        setupViewControllersItems()
        
        return [
            firstVC!,
            myRentalVC,
            profileVC,
            moreVC
        ]
    }
    
   

    func initialSelectedViewController() -> UIViewController? {
        
        return exploreVC
    }
    
    func tabBarItem(withItemName itemName: String, imageName: String) -> UITabBarItem {
        
        let tabBarItem = UITabBarItem()
        tabBarItem.title = itemName
        tabBarItem.image = UIImage(named: imageName)
        tabBarItem.setTitleTextAttributes(normalItemAttributes(), for: .normal)

        return tabBarItem
    }
    
    func normalItemAttributes() -> [NSAttributedString.Key : Any] {
        
        return [
         //   NSAttributedString.Key.font : UIFont.montserratRegular(fontSize: itemFontSize)!,
            NSAttributedString.Key.foregroundColor : UIColor.darkText
        ]
    }
    
    func selectedItemAttributes() -> [NSAttributedString.Key : Any] {
        
        return [
          //  NSAttributedString.Key.font : UIFont.montserratSemiBold(fontSize: itemFontSize)!,
            NSAttributedString.Key.foregroundColor : UIColor.darkBlueColor
        ]
    }
    
    func updateItemsAttributes(forViewControllers viewControllers: [UIViewController]?, selectedViewController: UIViewController?) {
        
        guard let viewControllers = viewControllers else { return }
        
        for viewController in viewControllers {

            let isSelectedVC = (viewController == selectedViewController)
            let attributes = isSelectedVC ? selectedItemAttributes() : normalItemAttributes()
            
            viewController.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        }
    }
}


extension UIViewController {
    
    func initializeWithNavigationController() -> UINavigationController {
       
       return TransparentNavigationController(rootViewController: self)
    
}
    func addFadeBackground(_ status:Bool,color:UIColor?){
        var fadeView:UIView
        if status{
            fadeView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            fadeView.backgroundColor = color
            fadeView.alpha = 0.0
            fadeView.tag = 98
            view.addSubview(fadeView)
            fadeView.fadeTo(alphaValue: 0.8, withDuration: 0.3)

        }else {
            for subview in view.subviews {
                if subview.tag == 98 {
                    UIView.animate(withDuration: 0.3, animations: {
                        subview.alpha = 0.0
                    }) { (finish) in
                         subview.removeFromSuperview()
                    }
                }
            }
        }
    }

    func removeChildVC(mainVc:UIViewController) {
           mainVc.willMove(toParent: nil)
           mainVc.view.removeFromSuperview()
           mainVc.removeFromParent()
       }
    
    func addChildViewController(_ childViewController: UIViewController?, onView: UIView) {
        //NavigationManger.shared.superViewController = self
        guard let childViewController = childViewController , let childView = childViewController.view else { return }
        self.addChild(childViewController)
        
        childView.alpha = 0
        onView.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
      childView.fillSuperview()
        childViewController.didMove(toParent: self)
       
        childViewController.view.frame = onView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        UIView.animate(
            withDuration: 0.3, delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.2,
            options: .curveLinear,
            animations: {
                childView.alpha = 1
        }, completion: nil)
    }
    
}

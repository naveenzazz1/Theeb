//
//  MoreViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 10/08/1443 AH.
//


import UIKit


class MoreViewModel {
    
    
    // MARK: - Variables
    
    var isUserLoggedIn: Bool {
        return CachingManager.loginObject()?.driverCode != nil
    }
    
    var navigateToViewController: ((_ vc: UIViewController) -> ())?
    var pushViewController: ((_ vc: UIViewController) -> ())?
    var dismiss: (() -> ())?
    var hideInfoView: (() -> ())?
    var itemsArray = [MyAccountItem]()
    
    
    // MARK: - Menu
    
    func numberOfItems() -> Int {
        
        return itemsArray.count
    }
  
    
    func selectItemAtIndex(_ index: Int) {
        let selectedItem = item(atIndex: index)
        selectedItem.action?()
    }
    
    func item(atIndex index: Int)-> MyAccountItem {
        
        return itemsArray[index]
    }
    
    func itemColor(atIndex index: Int) -> UIColor? {
        
        return item(atIndex: index).itemColor
    }
    
    func itemFont(atIndex index: Int) -> UIFont? {
        
        return item(atIndex: index).itemFont
    }
    
    func itemImage(atIndex index: Int) -> UIImage? {
        
        return item(atIndex: index).itemImage
    }
    
    func itemName(atIndex index: Int) -> String? {
        
        return item(atIndex: index).name
    }
    
    
    func setupUserItems()  {
        
        let userItems = [
            MyAccountItem(
                name: "more_carfleet_title" .localized,
                shouldShow: isUserLoggedIn ,
                action :{ [weak self] in
                    self?.navigateToViewController?(CarTypesVC.initializeFromStoryboard())
                }
                ,itemFont: UIFont.montserratSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold), itemColor: UIColor.weemBlack,
                itemImage:#imageLiteral(resourceName: "carFleet")
            ),
            
            MyAccountItem(
                name: "more_theebbranches_title".localized,
                shouldShow: isUserLoggedIn ,
                action :{ [weak self] in
                    self?.navigateToViewController?(BranchesVC.initializeFromStoryboard())
                 //   UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  LandingPageVC.initializeWithNavigationController()
                },itemFont: UIFont.montserratSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold), itemColor: UIColor.weemBlack,
                itemImage: #imageLiteral(resourceName: "MorebranchesIcon")
            ),
            
            MyAccountItem(
                name:  "more_ourservices_title".localized,
                shouldShow: isUserLoggedIn ,
                action : { [weak self] in
                    self?.navigateToViewController?(OurServicesVC.initializeFromStoryboard())
                },itemFont: UIFont.montserratSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold), itemColor: UIColor.weemBlack,
                itemImage:#imageLiteral(resourceName: "OurServicesIcon")
            ),
            
            
            MyAccountItem (
                name: "more_ourmembership_title".localized,
                shouldShow:
                    isUserLoggedIn ,
                action :{ [weak self] in
                    let userStoryBoard = UIStoryboard(name: "MemberShip", bundle: nil)
                    guard let navVc = userStoryBoard.instantiateViewController(withIdentifier: "AllMembersVC") as? AllMembersVC else {return}
                    self?.navigateToViewController?(navVc)
                },itemFont: UIFont.montserratSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold), itemColor: UIColor.weemBlack,
                itemImage: UIImage(named: "Ourmembership")
            ) ,
//            MyAccountItem (
//                name: "more_Ehsan_title".localized,
//                shouldShow:
//                    isUserLoggedIn ,
//                action :{ [weak self] in
//                    let navVc = DonationVc.initializeFromStoryboard()
//                    self?.navigateToViewController?(navVc)
//                },itemFont: UIFont.montserratSemiBold(fontSize: 15), itemColor: UIColor.weemBlack,
//                itemImage: UIImage(named: "ehsan")
//            ) ,
            MyAccountItem (
                name:  "more_helpandsupport_title".localized,
                shouldShow: isUserLoggedIn ,
                action :{ [weak self] in
                   
                    self?.navigateToViewController?(HelpSupportVC.initializeFromStoryboard())
                },itemFont:UIFont.montserratSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold), itemColor: UIColor.weemBlack,
                itemImage:#imageLiteral(resourceName: "help & support")
            ),
            
            MyAccountItem (
                name:  "more_aboutheeb_title".localized,
                shouldShow: isUserLoggedIn ,
                action :{ [weak self] in
                    let aboutVC = AboutDetailVc.initializeFromStoryboard()
                    aboutVC.contentString = "about_content_for_about_theeb".localized
                    aboutVC.titleStrig = "more_aboutheeb_title".localized.localized
                    self?.navigateToViewController?(aboutVC)
         
                },itemFont: UIFont.montserratSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold), itemColor: UIColor.weemBlack,
                itemImage:#imageLiteral(resourceName: "about")
            ),
            
            MyAccountItem (
                name:  "more_privacyPolicy".localized,
                shouldShow: isUserLoggedIn ,
                action :{ [weak self] in
//                    let privacyVC = PrivacyPolicyVC.initializeFromStoryboard()
//                    privacyVC.isFromMore = true
//                    self?.navigateToViewController?(privacyVC)
                    
                    let aboutVC = AboutDetailVc.initializeFromStoryboard()
                    aboutVC.contentString = "new_privacy_policy_text".localized
                    aboutVC.titleStrig = "new_privacy_policy".localized.localized
                    self?.navigateToViewController?(aboutVC)
                    
         
                },itemFont: UIFont.montserratSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold), itemColor: UIColor.weemBlack,
                itemImage: UIImage(systemName: "lock.doc")?.withTintColor(.theebPrimaryColor, renderingMode: .alwaysOriginal)
            ),
            
            MyAccountItem (
                name: "more_setting_title".localized,
                shouldShow: isUserLoggedIn ,
                action :{ [weak self] in
                 
                    self?.navigateToViewController?(SettingVC.initializeFromStoryboard())
                }, itemFont: UIFont.montserratSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold), itemColor: UIColor.weemBlack,
                itemImage:
                #imageLiteral(resourceName: "SettingIcon")
            ),
            
        ]
        
        self.itemsArray = userItems//.filter{($0.shouldShow)}
    }
}

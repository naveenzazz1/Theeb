//
//  HelpandSupportViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 21/08/1443 AH.
//

import Foundation

class HelpandSupportViewModel : NSObject {
    
    
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
    
    
    func setupUserItems() {
        let userItems = [
            MyAccountItem(
                name: "help_support_whatsup".localized,
                shouldShow: true, // Always show
                action :{ [weak self] in
                    self?.openWhatsapp()
                },
                itemFont: UIFont.montserratSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold),
                itemColor: UIColor.weemBlack,
                itemImage: UIImage(named: "whatsapp-line")
            ),
            
            MyAccountItem(
                name: "help_support_call_us".localized,
                shouldShow: true, // Always show
                action :{ [weak self] in
                    self?.callNumber(phoneNumber: "+966920000572")
                },
                itemFont: UIFont.montserratSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold),
                itemColor: UIColor.weemBlack,
                itemImage: UIImage(named: "phone-line")
            )
        ]
        
        self.itemsArray = userItems.filter { $0.shouldShow }
    }

    
    
    
    
    func openWhatsapp() {
        
        let urlWhats = "whatsapp://send?phone=920000572&text=مرحبا بك في خدمة الدعم من الذيب"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
     func callNumber(phoneNumber:String) {

      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
    
    
}

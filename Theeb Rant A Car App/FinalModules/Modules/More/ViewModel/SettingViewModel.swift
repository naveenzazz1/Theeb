//
//  SettingViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 01/04/2022.
//

import Foundation
class SettingViewModel {
    
    //vars
    var itemsArray = [MySettingItem]()
    
    
    // MARK: - Menu
 
    
    func numberOfItems() -> Int {
        
        return itemsArray.count
    }
    
    func item(atIndex index: Int)-> MySettingItem {
        
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
    
    func segmntItmes(index:Int)->(String?,String?,String?)?{
      
        return item(atIndex: index).sgmntElemnts
    }
    
    func itemName(atIndex index: Int) -> String? {
        
        return item(atIndex: index).name
    }
    
    func getSegmntAction(index: Int)->((_ sgmnt:UIControl?)-> Void)?{
         return item(atIndex: index).action
    }
    
    func switchCurrentLang(lang : AppLanguage){
        Language.setCurrentLanguage(lang: lang)
        (UIApplication.shared.delegate as! AppDelegate).initWindow()
    }
    
    
    func fillSettingArr(){
        let userItems = [
            MySettingItem(
                name: "setting_language" .localized,
                sgmntElemnts: ("English","عربي","French"),
                action :{ [weak self] sgmnt in
                    isLanguageChanged = true
                    if let sgmnt = sgmnt as? UISegmentedControl{
                        if sgmnt.selectedSegmentIndex == 0 {
                            self?.switchCurrentLang(lang: .english)
                        }else if sgmnt.selectedSegmentIndex == 1{
                            self?.switchCurrentLang(lang: .arabic)
                        }else{
                            self?.switchCurrentLang(lang: .french)
                        }
                    }
                }
                ,itemFont: UIFont.montserratSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold), itemColor: UIColor.weemBlack,
                itemImage:UIImage(named: "language")
            )
            
            ,MySettingItem(
                name: "setting_faceId".localized,
                sgmntElemnts: ("On".localized,"Off".localized,nil),
                action :{ sgmnt in
                    if let sgmnt = sgmnt as? UISegmentedControl {
                        
                        if CachingManager.isFaceIdEnabled == true {
                             sgmnt.selectedSegmentIndex = 1
                            CachingManager.isFaceIdEnabled = false
                        } else {
                            let bioMetricVC = EnableBiometricVC.initializeFromStoryboard()
                            
                            UIApplication.topViewController()?.present(bioMetricVC, animated: true, completion: nil)
                            sgmnt.selectedSegmentIndex = 0
                        
                        }
                    }

                },itemFont: UIFont.montserratSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold), itemColor: UIColor.weemBlack,
                itemImage:UIImage(named: "faceID")
            ),
//
//            MySettingItem(
//                name:  "setting_hourSystem".localized,
//                sgmntElemnts: ("24 hour","12 hour"),
//                action : { [weak self] sgmnt in
//
//                },itemFont: UIFont.montserratSemiBold(fontSize: 15), itemColor: UIColor.weemBlack,
//                itemImage:UIImage(named: "time")
//            ),
//
//            MySettingItem(
//                name: "setting_mode".localized,
//                sgmntElemnts: ("Light","Dark"),
//                action :{sgmnt in
//
//                },itemFont: UIFont.montserratSemiBold(fontSize: 15), itemColor: UIColor.weemBlack,
//                itemImage:UIImage(named: "mode")
//            )
//            */
        ]
        self.itemsArray = userItems
    }
    
    
}

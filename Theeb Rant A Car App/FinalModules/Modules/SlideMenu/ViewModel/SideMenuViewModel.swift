//
//  SideMenuViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 12/06/1443 AH.
//

import UIKit
import XMLMapper



class SideMenuViewModel: BaseViewModel {
    
    
    // MARK: - Variables
    
    var isUserLoggedIn: Bool {
        return CachingManager.loginObject()?.driverCode != nil
    }
    
    var navigateToViewController: ((_ vc: UIViewController) -> ())?
    var pushViewController: ((_ vc: UIViewController) -> ())?
    var dismiss: (() -> ())?
    var hideInfoView: (() -> ())?
    var alertUSerBeforeDelete: (() -> ())?
    var alertUSerBeforeLogout: (() -> ())?
    var itemsArray = [MyAccountItem]()
    var memberService = MemberShipService()
    var userProfile: Publisher<DriverProfileResponse> = .init()
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
   
    private func alertUser(msg:String){

        CustomAlertController.initialization().showAlertWithOkButton(message: msg) { (index, title) in
             print(index,title)
        }
     }
    
    func setupUserItems()  {


        let userItems = [
            MyAccountItem(
                name: "profile_item_bills" .localized,
                shouldShow: isUserLoggedIn ,
                action :{ [weak self] in
                    self?.navigateToViewController?(BillsVC.initializeFromStoryboard())
                }
                , itemImage:UIImage(named: "bill")
            ),
            
        
            MyAccountItem(
                name: "profile_item_deleteAcount" .localized,
                shouldShow: isUserLoggedIn ,
                action :{ [weak self] in
                    self?.alertUSerBeforeDelete?()
                }
                , itemImage:UIImage(systemName: "trash")                    
            ),
            
            MyAccountItem (
                name: "profile_item_log_out" .localized,
                shouldShow: isUserLoggedIn ,
                action :{ [weak self] in
                    self?.alertUSerBeforeLogout?()
                    //CachingManager.removeUserToken()
                    //self?.logOutAction()
                    // PushNotificationManager.manager.registerUserDeviceToken()
                }, itemFont: UIFont.logoutItemFont, itemColor: UIColor.logoutItemColor, itemImage:UIImage(named: "sign out")
            )
        ]
        
        self.itemsArray = userItems.filter{($0.shouldShow)}
    }
    
//    func deleteUser(){
//        let deleteServices = DeleteServices()
//        deleteServices.deleteUSerAccount(driverCode: CachingManager.loginObject()?.driverCode){ response in
//            guard let response = response as? String else {return}
//            let userModel = XMLMapper<DeleteAccountModel>().map(XMLString: response )
//            if userModel?.success == "Y" {
//                self.logOutAction()
//                print("success")
//            }else{
//                if let deleteReason = userModel?.varianceReason{
//                    self.alertUser(msg: deleteReason)
//                }else{
//                    self.alertUser(msg: "Driver Is Already InActive")
//                }
//            }
//
//        } failure: { response, error in
//            print(error?.localizedDescription ?? "error occured")
//        }
//    }
    
    func logOutAction(){
        dismiss?()
        resetDefaults()
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = LandingPageVC.initializeFromStoryboard()
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        let keysArrToNotRemoved = [CachingKeys.isFirstLogin,CachingKeys.email,CachingKeys.password, CachingKeys.faceIDenabled]
        dictionary.keys.forEach { key in
            if !keysArrToNotRemoved.contains(key) {
                defaults.removeObject(forKey: key)
            }
            
        }
    }
}
extension SideMenuViewModel {
    func getUserProfile(licenseNo: String,mobile: String,passportNo: String,email: String) {
        let paramsDic: [String: Any] = [
              "LicenseIdNo": licenseNo,
               "MobileNumber": mobile,
               "PassportIdNumber": passportNo,
               "InternetAddress": email
        ]
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.profile.rawValue, type: .post,DriverProfileResponse.self)?.response(error: { error in
           // send error
            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
                 print(index,title)
            }
        }, receiveValue: { [weak self] model in
            guard let model = model else { return }
            self?.userProfile.send(model)

        }).store(self)
        
    }
    
    func deleteUser(){
        CustomLoader.customLoaderObj.startAnimating()
        let paramsDic: [String: Any] = [
            "DriverCode": CachingManager.loginObject()?.driverCode ?? "",
            "DriverStatus": "A",
            "LicenseIdNo": CachingManager.loginObject()?.licenseNo ?? "",
            "MobileNumber": CachingManager.loginObject()?.mobileNo ?? "",
            "PassportIdNumber": CachingManager.loginObject()?.iDNo ?? "",
            "InternetAddress": CachingManager.loginObject()?.email ?? ""
        ]
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.deleteUser.rawValue, type: .post,DeleteAccountResponseModel.self)?.response(error: { [weak self] error in
           // send error
            CustomLoader.customLoaderObj.stopAnimating()
//            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                 print(index,title)
//            }
        }, receiveValue: { [weak self] model in
            guard let model = model else { return }
            CustomLoader.customLoaderObj.stopAnimating()
            if model.DriverStatusRS?.Success == "Y" {
                self?.logOutAction()
            } else {
                CustomAlertController.initialization().showAlertWithOkButton(message: model.DriverStatusRS?.VarianceReason ?? "") { (index, title) in
                     print(index,title)
                }
            }

        }).store(self)
        
    }
}

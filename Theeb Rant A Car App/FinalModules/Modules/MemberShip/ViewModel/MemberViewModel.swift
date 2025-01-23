//
//  MemberViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 21/03/2022.
//

import Foundation
import XMLMapper

class MemberViewModel {
    
    //vars
    var service = MemberTransferPointsService()
    //  var navigateToViewController: ((_ vc: UIViewController) -> ())?
    var pushViewController: ((_ vc: UIViewController) -> ())?
    var animateTransferView: ((_ value:CGFloat) -> ())?
    var animateValue:CGFloat?
    let profileServices = ViewProfileService()
   // var isFoursanAvailable = true

    
    func transferPoints(alfursanId : String?,
                        operation : String?,
                        passportID : String?,
                        driverCode : String? = nil,
                        royaltyPointBal : String?,
                        royaltyPointToConvert : String?
                        ,alfursanMiles : String?,
                        conversionRate : String?) {
        
        service.transferPoints(alfursanId: alfursanId,
                               operation: operation,
                               passportID: passportID,
                               driverCode: driverCode, royaltyPointBal: royaltyPointBal,
                               royaltyPointToConvert: royaltyPointToConvert, alfursanMiles: alfursanMiles,
                               conversionRate: conversionRate) { (response) in
            guard let response = response as? String else {return}
            let userModel = XMLMapper<AlfursanRequestMappable>().map(XMLString: response )
            let isSuccess = userModel?.alfursanReqWS?.success == "Y"
//            if isSuccess && !self.isFoursanAvailable{
//                self.updateProfile(alfursanId: alfursanId)
//            }
                DispatchQueue.main.async{
                    self.alertUser(title: isSuccess ? "alert_success".localized:"login_error".localized,msg:isSuccess ? userModel?.alfursanReqWS?.successMsg ?? "Successful transfer":"Error occured")
                    self.animateTransferView?(self.animateValue ?? 120)
                }
        } failure: { (response, error) in
            print(error?.localizedDescription)
            
        }
        
        
    }
    
    func updateProfileAndTransfeerPoints(alfursanId : String?,
                       operation : String?,
                       passportID : String?,
                       driverCode : String? = nil,
                       royaltyPointBal : String?,
                       royaltyPointToConvert : String?
                       ,alfursanMiles : String?,
                       conversionRate : String?){
        CustomLoader.customLoaderObj.startAnimating()
        profileServices.updateProfile(licenseId: CachingManager.loginObject()?.licenseNo,idType: CachingManager.loginObject()?.iDType ?? "I",idNo: CachingManager.loginObject()?.iDNo,alfursanID:alfursanId){ (response) in
            guard let response = response as? String else {return}
            let userModel = XMLMapper<DriverUpdateModel>().map(XMLString: response )
            CustomLoader.customLoaderObj.stopAnimating()
            if userModel?.success == "Y" {
                self.transferPoints(alfursanId: alfursanId, operation: operation, passportID: passportID, driverCode: driverCode, royaltyPointBal: royaltyPointBal, royaltyPointToConvert: royaltyPointToConvert, alfursanMiles: nil, conversionRate: nil)
            }else{
                DispatchQueue.main.async{
                    self.alertUser(msg: "profile_updateFailed".localized)
                }
            }
        } failure: { (response, error) in
            print(error?.localizedDescription)
        }
    }
    
    private func alertUser(title:String = "login_error".localized,msg:String){
        CustomAlertController.initialization().showAlertWithOkButton(title:title,message: msg) { (index, title) in
            print(index,title)
       }
    }
    
    func pushAlforsanVc(){
        let userStoryBoard = UIStoryboard(name: "MemberShip", bundle: nil)
        guard let navVc = userStoryBoard.instantiateViewController(withIdentifier: "AlforsanVC") as? AlforsanVC else {return}
        pushViewController?(navVc)
    }
    
    func pushAllMembers(){
        let userStoryBoard = UIStoryboard(name: "MemberShip", bundle: nil)
        guard let navVc = userStoryBoard.instantiateViewController(withIdentifier: "AllMembersVC") as? AllMembersVC else {return}
        pushViewController?(navVc)
    }
}

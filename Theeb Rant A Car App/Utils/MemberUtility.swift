//
//  MemberUtility.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 02/06/2022.
//

import UIKit

class MemberUtility{
    
    static let instance = MemberUtility()
    
    var freeHours:String{
        //let freeHours = CachingManager.memberDriverModel?.memberShip.extraHours ?? "0"
        let freeHours = CachingManager.memberDriverModel?.membership?.extraHours ?? "0"
        let isEmptyHours = (freeHours == "0")
        return String(format: "checkOut_extraHours".localized, "\(String(describing: isEmptyHours ? "more_Zero".localized:freeHours))")
        // ?? CachingManager.loginObject()?.bufferHours ?? ""
    }
    
    var freeKiloMeters:String{
       // "\(CachingManager.memberDriverModel?.memberShip.freeKm ?? "0") \("km_hint".localized)"
        "\(CachingManager.memberDriverModel?.membership?.freeKM ?? "0") \("km_hint".localized)"
    }
    
    func getSumKmString(str1:String,str2:String)->String{
      let int1 = Int(str1) ?? 0
      let int2 = Int(str2) ?? 0
      return "\(int1 + int2) \("km_hint".localized)"
    }
    
    func setMemberLabel(lbl:UILabel){
      //  switch CachingManager.memberDriverModel?.memberShip.cardType{
        switch CachingManager.memberDriverModel?.membership?.cardType {
        case "فضية" :
            lbl.text = "checkOut_silverMember".localized
        case "ذهبية" :
            lbl.text = "checkOut_goldenMember".localized
        case "برونزية":
            lbl.text = "checkOut_bronzMember".localized
        case "عطاء" :
            lbl.text = "checkOut_greenMember".localized
        case "ماسية":
            lbl.text = "checkOut_diamondMember".localized
        default:
            lbl.text = "rental_memberShipTitle".localized
        }
    }
}

//
//  MemberImages.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 16/03/2022.
//

import Foundation
import XMLMapper
import UIKit
struct MemberImages{
    let memberElemnt:MemberElement?
    let banner:String?
    let benefits: String?
    let backGround: String
    var backGroundColors:(UIColor,UIColor)
    static var memberArr:[MemberImages] {
        var arr = [MemberImages]()
        let isArabic = UIApplication.isRTL()
        var memberGreen = MemberImages(memberElemnt: .bronz, banner: "bronzBanner", benefits: isArabic ? "BronzBenefitsAR":"BronzBenefits", backGround: "bronzBack", backGroundColors: (#colorLiteral(red: 0.9482739568, green: 0.8596023917, blue: 0.7170879245, alpha: 1) , #colorLiteral(red: 0.6699721217, green: 0.5237028599, blue: 0.407605648, alpha: 1)))
        arr.append(memberGreen)
        
        memberGreen = MemberImages(memberElemnt: .silver, banner: "silverBanner", benefits: isArabic ? "silverBenefitsAR":"silverBenefits", backGround: "silverBack", backGroundColors: (#colorLiteral(red: 0.7176471353, green: 0.7176471353, blue: 0.7176471353, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
        arr.append(memberGreen)
        
        memberGreen = MemberImages(memberElemnt: .gold, banner: "goldenBanner", benefits: isArabic ? "goldenBenefitsAR":"goldenBenefits", backGround: "goldenBack", backGroundColors: (#colorLiteral(red: 0.9743828177, green: 0.8176764846, blue: 0.4023324847, alpha: 1), #colorLiteral(red: 0.8525035977, green: 0.6672613621, blue: 0.2929895818, alpha: 1)))
        arr.append(memberGreen)
        
        memberGreen = MemberImages(memberElemnt: .green, banner: "greenBanner", benefits: isArabic ? "greenBenefitsAR":"greenBenefits", backGround: "greenBack", backGroundColors: (#colorLiteral(red: 0.09239617735, green: 0.2785079181, blue: 0.198163867, alpha: 1), #colorLiteral(red: 0.01178644318, green: 0.171677798, blue: 0.08166416734, alpha: 1)))
        arr.append(memberGreen)
        
        memberGreen = MemberImages(memberElemnt: .diamond, banner: "diamondBanner", benefits: isArabic ? "diamondBenefitsAR":"diamondBenefits", backGround: "diamondBack", backGroundColors:(.darkGray,.black))
        arr.append(memberGreen)
        
        return arr
    }
    
    static func getMember(index:Int)->MemberImages{
        memberArr[index]
    }
    
    static func numberOfElemnts()->Int{
        memberArr.count
    }
}


class AlfursanRequestMappable : XMLMappable {
    var nodeName: String!
    
    var alfursanReqWS : AlfursanReqWSModel?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        alfursanReqWS <- map["SOAP-ENV:Body.AlfursanReqWS"]
    }
    
}

class AlfursanReqWSModel : XMLMappable {
    var nodeName: String!
    
    var varianceReason : String?
    var driverCode : String?
    var totalTheebPoints  : String?
    var theebPointsUsed  : String?
    var theebPointsConvert : String?
    //Success
    var requestCode : String?
    var successMsg : String?
    var success:String?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        varianceReason <- map["VarianceReason"]
        driverCode <- map["DriverCode"]
        totalTheebPoints <- map["TotalTheebPoints"]
        theebPointsUsed <- map["TheebPointsUsed"]
        theebPointsConvert <- map["TheebPointsConvert"]
        requestCode <- map["RequestCode"]
        successMsg <- map["SuccessMsg"]
        success <- map["Success"]
    }
    
    
}

class ApplicantImportRSModel : XMLMappable {
    var nodeName: String!
    
    var applecationRS : ApplicantImportRS?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        applecationRS <- map["ApplicantImportRS"]
    }

}

class ApplicantImportRS : XMLMappable {
    var nodeName: String!
    var successString : String?
    var varianceString : String?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        successString <- map["Success"]
        varianceString <- map["VarianceReason"]
    }
    
    
}

class alfursanRequestMappableHistory : XMLMappable {
    var nodeName: String!
    
    var alfursanReqWS : [AlfursanReqWSModelHistory]?
    var successString : String?
    var varianceString : String?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        alfursanReqWS <- map["SOAP-ENV:Body.AlfursanReqWS.Request"]
        successString <- map["SOAP-ENV:Body.AlfursanReqWS.Success"]
        varianceString <- map["SOAP-ENV:Body.AlfursanReqWS.VarianceReason"]
    }
    
    
}

class AlfursanReqWSModelHistory : XMLMappable {
   
    var nodeName: String!
    var AlfursanID : String?
    var AlfursanMiles : String?
    var ConversionRate  : String?
    var DriverCode  : String?
    var ReqDate : String?
    var ReqID : String?
    var ReqTime : String?
    var SrNo : String?
    var TheebPointBal : String?
    //Success
    var requestCode : String?
    var successMsg : String?
    var pointToConvert : String?
       var status : String?
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        
         AlfursanID <- map.attributes["AlfursanID"]
         AlfursanMiles <- map.attributes["AlfursanMiles"]
         ConversionRate <- map.attributes["ConversionRate"]
         DriverCode <- map.attributes["DriverCode"]
         ReqDate <- map.attributes["ReqDate"]
         ReqID <- map.attributes["ReqID"]
         ReqTime <- map.attributes["ReqTime"]
         SrNo <- map.attributes["SrNo"]
         TheebPointBal <- map.attributes["TheebPointBal"]
         pointToConvert <- map.attributes["PointsToConvert"]
          status <- map.attributes["Status"]
    }
    
    
}

enum MemberElement{
    case green,bronz,silver,gold,diamond

    var memberName:String{
        switch self{
        case .bronz:
            return "memberDetailsVC_bronz".localized
        case .diamond:
            return "memberDetailsVC_diamond".localized
        case .gold:
            return "memberDetailsVC_Gold".localized
        case .green:
            return "memberDetailsVC_ata".localized
        case .silver:
            return "memberDetailsVC_silver".localized
        }
    }
    
    var imageBannerName:String{
        switch self{
        case .bronz:
            return "bronzBanner"
        case .diamond:
            return "diamondBanner".localized
        case .gold:
            return "goldenBanner".localized
        case .green:
            return "greenBanner".localized
        case .silver:
            return "silverBanner".localized
        }
    }
    
    
    var memberGradientColor:(UIColor,UIColor){
        switch self{
            
        case .bronz:
            return (#colorLiteral(red: 0.2265580595, green: 0.231536001, blue: 0.2314487696, alpha: 1), #colorLiteral(red: 0.8049814105, green: 0.6776148677, blue: 0.5529415011, alpha: 1))
        case .diamond:
            return (.darkGray,.black)
        case .gold:
            return (#colorLiteral(red: 0.9743828177, green: 0.8176764846, blue: 0.4023324847, alpha: 1), #colorLiteral(red: 0.8525035977, green: 0.6672613621, blue: 0.2929895818, alpha: 1))
        case .green:
            return (#colorLiteral(red: 0.09239617735, green: 0.2785079181, blue: 0.198163867, alpha: 1), #colorLiteral(red: 0.01178644318, green: 0.171677798, blue: 0.08166416734, alpha: 1))
        case .silver:
            return (#colorLiteral(red: 0.7176471353, green: 0.7176471353, blue: 0.7176471353, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        }
    }
    
    var mainArr:[[(UIImage?,text:String,isPadding:Bool)]]{
        switch self{
        case .gold:
            return goldenArr
        case .silver:
            return silverArr
        case .bronz:
            return bronzArr
        case .diamond:
            return diamondArr
        case .green:
            return ataArr
        }
    }
    
    var dotImage:UIImage?{
        UIImage(named:"bullet")?.withTintColor(.weemDarkGray)
    }
    
    var greenMarkImg:UIImage?{
        UIImage(named: "checkOK")
    }
    
    /*

   
     "memberDetailsVC_GoldenReqContract" = "The balance of the customer's rent shall be 20,000 SAR according to the terms and conditions";
     "memberDetailsVC_diamondReqContract" = "The balance of the customer's rent shall be 60,000 SAR according to the terms and conditions";
     "memberDetailsVC_ataaReqContract" = "Persons with disabilities card or any identification papers for that.";
     */
    
    var bronzArr:[[(UIImage?,text:String,isPadding:Bool)]]{
        [[(dotImage,"10% \("memberDetailsVC_BenefitsRentDiscount".localized)",false) ,
          (dotImage,"225 \("memberDetailsVC_kmFree".localized)",false),
          (dotImage,"memberDetailsVC_extra2Hours".localized,false),
          (dotImage,"75 \("memberDetailsVC_gulfFees".localized)",false),
          (dotImage,"300 \("memberDetailsVC_arabicFees".localized)",false),
          (dotImage,"memberDetailsVC_payWithQateef".localized,false)],
         
        // [(UIImage(named: "sandTime"),"memberDetailsVC_bronzReqContract".localized,false),
         [(greenMarkImg,"memberDetailsVC_bronzReqAutomatic".localized,false)]]
    }
     
    var silverArr:[[(UIImage?,text:String,isPadding:Bool)]]{
        [[(dotImage,"12% \("memberDetailsVC_BenefitsRentDiscount".localized)",false) ,
          (dotImage,"20% \("memberDetailsVC_oneDirectionDiscount".localized)",false),
         (dotImage,"250 \("memberDetailsVC_kmFree".localized)",false),
          (dotImage,"memberDetailsVC_extra3Hours".localized,false),
         (dotImage,"50 \("memberDetailsVC_gulfFees".localized)",false),
          (dotImage,"300 \("memberDetailsVC_arabicFees".localized)",false),
          (dotImage,"memberDetailsVC_earn05Point".localized,false),
          (dotImage,"memberDetailsVC_payWithTheeb".localized,false),
          (dotImage,"memberDetailsVC_payWithQateef".localized,false),
          (dotImage,"memberDetailsVC_payWithAlfursan".localized,false)],
         
         [
            (greenMarkImg,"memberDetailsVC_SilvarReqContract".localized,false)]]
    }
    
    var ataArr:[[(UIImage?,text:String,isPadding:Bool)]]{
        [[(dotImage,"17% \("memberDetailsVC_BenefitsRentDiscount".localized)",false) ,
         (dotImage,"50% \("memberDetailsVC_oneDirectionDiscount".localized)",false),
         (dotImage,"325 \("memberDetailsVC_kmFree".localized)",false),
          (dotImage,"memberDetailsVC_extra5Hours".localized,false),
          (dotImage,"memberDetailsVC_gulfFeesFree".localized,false),
          (dotImage,"memberDetailsVC_arabicFeesFree".localized,false),
          (dotImage,"memberDetailsVC_earn1Point".localized,false),
          (dotImage,"memberDetailsVC_payWithTheeb".localized,false),
          (dotImage,"memberDetailsVC_payWithQateef".localized,false),
         (dotImage,"memberDetailsVC_payWithAlfursan".localized,false)],

         [(greenMarkImg,"memberDetailsVC_ataaReqContract".localized,false)
//         (greenMarkImg," Work ID or 5000 in the bank balance",false),
//          (greenMarkImg," Persons with disabilities card or any identification papers for that.",false)
         ]]
    }
    
    var goldenArr:[[(UIImage?,text:String,isPadding:Bool)]]{
       [[(dotImage,"15% \("memberDetailsVC_BenefitsRentDiscount".localized)",false) ,
         (dotImage,"50% \("memberDetailsVC_oneDirectionDiscount".localized)",false),
         (dotImage,"300 \("memberDetailsVC_kmFree".localized)",false),
         (dotImage,"memberDetailsVC_extra5Hours".localized,false),
         (dotImage,"35 \("memberDetailsVC_gulfFees".localized)",false),
         (dotImage,"memberDetailsVC_arabicFeesFree".localized,false),
         (dotImage,"memberDetailsVC_earn1Point".localized,false),
         (dotImage,"memberDetailsVC_payWithTheeb".localized,false),
         (dotImage,"memberDetailsVC_payWithQateef".localized,false),
         (dotImage,"memberDetailsVC_payWithAlfursan".localized,false)],
        
        [(greenMarkImg,"memberDetailsVC_GoldenReqContract".localized,false)
//         (greenMarkImg," Work ID or 5000 in the bank balance",false),
//         (greenMarkImg," Fulfill one of the following conditions:",false),
//         (dotImage," 20,000 credit, excluding damage, violation and VAT",true),
//         (dotImage," Occupations with leadership positions such as officer, doctor, engineer, etc",true),
//         (dotImage," Contracts with employees of the governmental and private sectors",true)
        ]]
    }
    
    var diamondArr:[[(UIImage?,text:String,isPadding:Bool)]]{
        [[(dotImage,"Free Delivrry",false),
          (dotImage,"20% \("memberDetailsVC_BenefitsRentDiscount".localized)",false) ,
          (dotImage,"50% \("memberDetailsVC_oneDirectionDiscount".localized)",false),
          (dotImage,"325 \("memberDetailsVC_kmFree".localized)",false),
          (dotImage,"memberDetailsVC_extra5Hours".localized,false),
          (dotImage,"memberDetailsVC_gulfFeesFree".localized,false),
          (dotImage,"memberDetailsVC_arabicFeesFree".localized,false),
          (dotImage,"memberDetailsVC_earn1Point".localized,false),
          (dotImage,"memberDetailsVC_payWithTheeb".localized,false),
          (dotImage,"memberDetailsVC_payWithQateef".localized,false),
          (dotImage,"memberDetailsVC_payWithAlfursan".localized,false)],
         
         [(greenMarkImg,"memberDetailsVC_diamondReqContract".localized,false)
//          (greenMarkImg," The balance of the customer’s rent shall be SR60,000 and more, taking into account (excluding) the following:",false),
//          (dotImage," Any customer whose damages exceed 20% of the total rental balance.",true),
//          (dotImage," Any customer with a debit balance.",true),
//          (dotImage," Any customer on the stop list",true),
//           (dotImage," The tax amount is not calculated from the total balance",true),
//           (dotImage," Any customer whose rental balance is from the account of companies and other persons or a delivery driver",true),
//           (dotImage," Taking into account the customer's evaluation during the last rental period",true)
         ]]
     }
}


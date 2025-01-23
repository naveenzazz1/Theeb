//
//  ReservationModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 08/08/1443 AH.
//

import UIKit
import XMLMapper


class ReservationMappable: XMLMappable {
 
    var nodeName: String!
    var reservationDetails: ReservationDetailsObject!
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        
        reservationDetails <- map["SOAP-ENV:Body.ReservationDetails"]
        
    }
    
    class ReservationDetailsObject: XMLMappable {
        var nodeName: String!
        
        var success: String!
        
        var varianceReason : String!
        
        required init(map: XMLMap) {
            
        }
        
        func mapping(map: XMLMap) {
            
            success <- map["Success"]
            varianceReason <- map["VarianceReason"]
            
        }
        
        
    }
    
}

class CancelBooking:Codable{
    
      let Success: String?
      let VarianceReason: String?
      let CancellationPercent: String?
      let CancellationFeeBasedOnPerc: String?
      let CancellationFeeFlatAmt: String?
      let CalResCanFeeRS: CalResCanFeeRS?
    
    struct CalResCanFeeRS:Codable{
        let Success: String?
        let VarianceReason: String?
      }
    
}

struct ExtrasInsurenceData : Codable {
    
    let Code : String?
    let Name : String?
    let Quantity : String?


    enum CodingKeys: String, CodingKey {
        case Code = "Code"
        case Name = "Name"
        case Quantity = "Quantity"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        Code = try values.decodeIfPresent(String.self, forKey: .Code)
        Name = try values.decodeIfPresent(String.self, forKey: .Name)
        Quantity = try values.decodeIfPresent(String.self, forKey: .Quantity)
    }

    init(code:String?,name:String?,quantity:String?){
        self.Code = code
        self.Name = name
        self.Quantity = quantity
    }
}

struct ReservationModelJson : Codable {
    let reservationDetails : ReservationDetails?

    enum CodingKeys: String, CodingKey {

        case reservationDetails = "ReservationDetails"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reservationDetails = try values.decodeIfPresent(ReservationDetails.self, forKey: .reservationDetails)
    }

}

struct ReservationDetails : Codable {
    let success : String?
    let varianceReason : String?
    let reservationNo : String?

    enum CodingKeys: String, CodingKey {

        case success = "Success"
        case varianceReason = "VarianceReason"
        case reservationNo = "ReservationNo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(String.self, forKey: .success)
        varianceReason = try values.decodeIfPresent(String.self, forKey: .varianceReason)
        reservationNo = try values.decodeIfPresent(String.self, forKey: .reservationNo)
    }

}

struct Booked:Codable{
    let Extra:[ExtrasInsurenceData]?
    let Insurance:[ExtrasInsurenceData]?
}

enum ApiReservationStatus:String{
    case newReservation = "N"
    case cancelReservation = "C"
}

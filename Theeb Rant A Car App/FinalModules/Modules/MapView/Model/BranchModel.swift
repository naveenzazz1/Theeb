//
//  BranchModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 19/06/1443 AH.
//


import UIKit
import ObjectMapper
import SwiftyXMLParser
import XMLMapper


class BranchXmlMappable: XMLMappable, Codable {
   
    var nodeName: String!
    
    var soapEnvelopeOuter : BranchesModel?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        soapEnvelopeOuter <- map["SOAP-ENV:Body.Branches"]
    }
    
    
}


class BranchesModel: XMLMappable ,Codable {
    var nodeName: String!
    
    var success : String?
    var varianceReason : String?
    var branch : [BranchModel]!
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        success <- map["Success"]
        branch <- map["Branch"]
        varianceReason <- map["VarianceReason"]
    }
    
    
}
class BranchModel: NSObject, XMLMappable , Codable {
    var nodeName: String!
    var distance : String?
    var time : String?
    var branchCode : String?
    var branchName : String?
    var distArea : String?
    var distAreaName : String?
    var opArea : String?
    var opAreaName : String?
    var country : String?
    var countryName : String?
    var branchLat : String?
    var branchLong : String?
    var city : String?
    var state : String?
    var telephone : String?
    var telephone1 : String?
    var fax : String?
    var telex : String?
    var email : String?
    var schedule : [Schedule]?
    var arabicBranchName : String?
    var street : String?
    var street1 : String?
    var street2 : String?
    var stateAr : String?
      var city1 : String?
      var cityAr : String?
    
   
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        
        
        arabicBranchName <- map["ArabicBranchName"]
        branchCode <- map["BranchCode"]
        branchName  <- map["BranchName"]
        distArea <- map["DistArea"]
        distAreaName <- map["DistAreaName"]
        opArea <- map["OpArea"]
        opAreaName <- map["OpAreaName"]
        country <- map["Country"]
        countryName <- map["CountryName"]
        branchLat <- map["BranchLat"]
        branchLong <- map["BranchLong"]
        city <- map["City"]
        state <- map["State"]
        telephone <- map["Telephone"]
        telephone1 <- map["Telephone1"]
        fax <- map["Fax"]
        telex <- map["Telex"]
        email <- map["Email"]
        schedule <- map["Schedule"]
        street <- map["Street"]
        street1 <- map["Street1"]
        street2 <- map["Street2"]
        stateAr <- map["StateAR"]
            city1 <- map["City1"]
            cityAr <- map["CityAR"]
    }
    
    
}

class Schedule: XMLMappable , Codable{
    var nodeName: String!
    
    var dayCode : String?
    var endTime : String?
    var startTime : String?
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        dayCode <- map.attributes["DayCode"]
        endTime <- map.attributes["EndTime"]
        startTime <- map.attributes["StartTime"]
    }
    
    
}


// branches Model

struct BranchesResponse: Codable {
    let branches: Branches?

    enum CodingKeys: String, CodingKey {
        case branches = "Branches"
    }
}

struct Branches: Codable {
    let success: String?
    let varianceReason: String?
    let branch: [Branch]?

    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case varianceReason = "VarianceReason"
        case branch = "Branch"
    }
}

struct Branch: Codable, Equatable {
    static func == (lhs: Branch, rhs: Branch) -> Bool {
            return lhs.branchCode == rhs.branchCode
        }
    var distance : String?
    var time : String?
    let branchCode: Int?
    let branchName: String?
    let branchAddress: String?
    let branchStreet: String?
    let branchPostal: String?
    let distArea: Int?
    let distAreaName: String?
    let opArea: Int?
    let opAreaName: String?
    let country: String?
    let countryName: String?
    let branchLat: String?
    let branchLong: String?
    let city: String?
    let state: String?
    let telephone: String?
    let telephone1: String?
    let fax: String?
    let telex: String?
    let email: String?
    let branchNameTranslated: String?
    let opAreaNameTranslated: String?
    let streetTranslated: String?
    let cityTranslated: String?
    let stateTranslated: String?
    let cityAreaTranslated: String?
    let schedule: [ScheduleModel]?

    enum CodingKeys: String, CodingKey {
        case branchCode = "BranchCode"
        case branchName = "BranchName"
        case branchAddress = "BranchAddress"
        case branchStreet = "BranchStreet"
        case branchPostal = "BranchPostal"
        case distArea = "DistArea"
        case distAreaName = "DistAreaName"
        case opArea = "OpArea"
        case opAreaName = "OpAreaName"
        case country = "Country"
        case countryName = "CountryName"
        case branchLat = "BranchLat"
        case branchLong = "BranchLong"
        case city = "City"
        case state = "State"
        case telephone = "Telephone"
        case telephone1 = "Telephone1"
        case fax = "Fax"
        case telex = "Telex"
        case email = "Email"
        case branchNameTranslated = "BranchNameTranslated"
        case opAreaNameTranslated = "OpAreaNameTranslated"
        case streetTranslated = "StreetTranslated"
        case cityTranslated = "CityTranslated"
        case stateTranslated = "StateTranslated"
        case cityAreaTranslated = "CityAreaTranslated"
        case schedule = "Schedule"
    }
}

struct ScheduleModel: Codable {
    let dayCode: Int?
    let endTime: String?
    let startTime: String?

    enum CodingKeys: String, CodingKey {
        case dayCode = "DayCode"
        case endTime = "EndTime"
        case startTime = "StartTime"
    }
}


//
//  ExtrasModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 24/07/1443 AH.
//

import UIKit
import XMLMapper

class ExtraListXmlModel: XMLMappable {
    
    var nodeName: String!
    
    var code: String!
    var name: String!
    var ratePerUnit: String!
    var englishName: String!
    var count: String!
    var isSelected : Bool?
    
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        
        code <- map["Code"]
        name <- map["Name"]
        ratePerUnit <- map["RatePerUnit"]
        englishName <- map["EnglishName"]
        
    }
    
    
}

class InsuranceListXmlModel: XMLMappable {
    var nodeName: String!
    
    var code: String!
    var name: String!
    
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        
        code <- map["Code"]
        name <- map["Name"]
        
    }
    
    
}


class ExtrasListMappable: XMLMappable {
    
    var nodeName: String!
    var insurance: [InsuranceListXmlModel]!
    var extras : [ExtraListXmlModel]!
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        
        extras <- map["Extra.Detail"]
        insurance <- map["Insurance.Detail"]
    }
    
    
}



class ExtrasXMLMappable: XMLMappable {
    var nodeName: String!
    
    var soapEnvelopeOuter : ExtrasListMappable!
    
    required init(map: XMLMap) {
        
    }
    
    func mapping(map: XMLMap) {
        soapEnvelopeOuter <- map["SOAP-ENV:Body.Root"]
    }
    
    
}

struct InsurenceModel : Codable {
    let insTypes : InsTypes?

    enum CodingKeys: String, CodingKey {

        case insTypes = "InsTypes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        insTypes = try values.decodeIfPresent(InsTypes.self, forKey: .insTypes)
    }

}

struct InsTypes : Codable {
    let success : String?
    let insType : [InsType]?

    enum CodingKeys: String, CodingKey {

        case success = "Success"
        case insType = "InsType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(String.self, forKey: .success)
        insType = try values.decodeIfPresent([InsType].self, forKey: .insType)
    }

}

struct InsType : Codable, Equatable {
    let code : String?
    let desc : String?
    let amount : String?
    let nameTranslated : String?

    enum CodingKeys: String, CodingKey {

        case code = "Code"
        case desc = "Desc"
        case amount = "Amount"
        case nameTranslated = "NameTranslated"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        desc = try values.decodeIfPresent(String.self, forKey: .desc)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        nameTranslated = try values.decodeIfPresent(String.self, forKey: .nameTranslated)
    }

    init(code : String?,
         desc : String?,
         amount : String?,
         nameTranslated : String?){
        self.code = code
        self.amount = amount
        self.desc = desc
        self.nameTranslated = nameTranslated
    }
}

struct ExtraJsonModel : Codable {
    let extTypes : ExtTypes?

    enum CodingKeys: String, CodingKey {

        case extTypes = "ExtTypes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        extTypes = try values.decodeIfPresent(ExtTypes.self, forKey: .extTypes)
    }

}

struct ExtTypes : Codable {
    let success : String?
    let extType : [ExtType]?

    enum CodingKeys: String, CodingKey {

        case success = "Success"
        case extType = "ExtType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(String.self, forKey: .success)
        extType = try values.decodeIfPresent([ExtType].self, forKey: .extType)
    }

}

struct ExtType : Codable,Equatable {
    let code : String?
    let desc : String?
    let amount : String?
    let nameTranslated : String?

    enum CodingKeys: String, CodingKey {

        case code = "Code"
        case desc = "Desc"
        case amount = "Amount"
        case nameTranslated = "NameTranslated"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        desc = try values.decodeIfPresent(String.self, forKey: .desc)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        nameTranslated = try values.decodeIfPresent(String.self, forKey: .nameTranslated)
    }

}

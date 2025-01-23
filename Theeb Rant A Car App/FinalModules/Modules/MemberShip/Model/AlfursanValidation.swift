//
//  AlfursanValidation.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 04/04/2024.
//

import Foundation

struct AlfursanValidation : Codable {
    let success : Bool?
    let error : String?
    let message : String?
    let path : String?
    let requestToken : String?
    let status : String?
    let timestamp : String?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case error = "error"
        case message = "message"
        case path = "path"
        case requestToken = "requestToken"
        case status = "status"
        case timestamp = "timestamp"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        requestToken = try values.decodeIfPresent(String.self, forKey: .requestToken)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
    }

}

struct ConvertLoyalityModel : Codable {
    let success : Bool?
    let error : String?
    let message : String?
    let path : String?
    let requestToken : String?
    let status : Int?
    let timestamp : String?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case error = "error"
        case message = "message"
        case path = "path"
        case requestToken = "requestToken"
        case status = "status"
        case timestamp = "timestamp"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        requestToken = try values.decodeIfPresent(String.self, forKey: .requestToken)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
    }

}

struct AlfursanHistoryModel : Codable {
    let success : Bool?
    let message : String?
    let loyaltyConversionTransactions : [LoyaltyConversionTransactions]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case loyaltyConversionTransactions = "loyaltyConversionTransactions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        loyaltyConversionTransactions = try values.decodeIfPresent([LoyaltyConversionTransactions].self, forKey: .loyaltyConversionTransactions)
    }

}

struct LoyaltyConversionTransactions : Codable {
    let requestId : String?
    let driverId : Int?
    let alfursanID : String?
    let requestDate : String?
    let requestTime : String?
    let pointsBalance : Int?
    let pointsToConvert : Int?
    let convertedPoints : Int?
    let convertionRatio : Int?
    let status : Int?
    let transactionMsg : String?
    let transactionNo : String?
    let errorMsg : String?

    enum CodingKeys: String, CodingKey {

        case requestId = "requestId"
        case driverId = "driverId"
        case alfursanID = "alfursanID"
        case requestDate = "requestDate"
        case requestTime = "requestTime"
        case pointsBalance = "pointsBalance"
        case pointsToConvert = "pointsToConvert"
        case convertedPoints = "convertedPoints"
        case convertionRatio = "convertionRatio"
        case status = "status"
        case transactionMsg = "transactionMsg"
        case transactionNo = "transactionNo"
        case errorMsg = "errorMsg"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requestId = try values.decodeIfPresent(String.self, forKey: .requestId)
        driverId = try values.decodeIfPresent(Int.self, forKey: .driverId)
        alfursanID = try values.decodeIfPresent(String.self, forKey: .alfursanID)
        requestDate = try values.decodeIfPresent(String.self, forKey: .requestDate)
        requestTime = try values.decodeIfPresent(String.self, forKey: .requestTime)
        pointsBalance = try values.decodeIfPresent(Int.self, forKey: .pointsBalance)
        pointsToConvert = try values.decodeIfPresent(Int.self, forKey: .pointsToConvert)
        convertedPoints = try values.decodeIfPresent(Int.self, forKey: .convertedPoints)
        convertionRatio = try values.decodeIfPresent(Int.self, forKey: .convertionRatio)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        transactionMsg = try values.decodeIfPresent(String.self, forKey: .transactionMsg)
        transactionNo = try values.decodeIfPresent(String.self, forKey: .transactionNo)
        errorMsg = try values.decodeIfPresent(String.self, forKey: .errorMsg)
    }

}

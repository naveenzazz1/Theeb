//
//  PushNotificationModel.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 07/11/2023.
//

import Foundation

struct PushNotificationTokenMoedl:Codable{
    let token : String?
    let tokenType : String?
    let refreshToken : Bool?
    let expirytime : String?

    enum CodingKeys: String, CodingKey {

        case token = "token"
        case tokenType = "tokenType"
        case refreshToken = "refreshToken"
        case expirytime = "expirytime"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        tokenType = try values.decodeIfPresent(String.self, forKey: .tokenType)
        refreshToken = try values.decodeIfPresent(Bool.self, forKey: .refreshToken)
        expirytime = try values.decodeIfPresent(String.self, forKey: .expirytime)
    }

}

struct FcmResponseMoedl:Codable{
    let message: String
    let status: String
}

struct NotificationModel : Codable {
    let status : String?
    let statusMessage : String?
    let messages : [Messages]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case statusMessage = "statusMessage"
        case messages = "messages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        statusMessage = try values.decodeIfPresent(String.self, forKey: .statusMessage)
        messages = try values.decodeIfPresent([Messages].self, forKey: .messages)
    }

}

struct Messages: Codable, Equatable{
    let title: String?
    let body: String?
    let date: String?
    
    enum CodingKeys: String, CodingKey {

        case title = "title"
        case body = "body"
        case date = "date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        date = try values.decodeIfPresent(String.self, forKey: .date)
    }
    
    init(title:String?, body:String?, date:String?){
        self.title = title
        self.body = body
        self.date = date
    }
}

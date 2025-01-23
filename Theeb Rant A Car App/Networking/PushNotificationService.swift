//
//  PushNotificationService.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 07/11/2023.
//

import Foundation
import Alamofire

class PushNotificationService:BaseViewModel{
    
    static let instance = PushNotificationService()

    func getPushNotificationAccesToken(completion: @escaping (Bool,String?) -> Void){
        
        let headers: HTTPHeaders = [
           "Content-Type": "application/json",
           "Accept": "application/json"
       ]
        
        let params: [String: Any] = [
//            "userID": "AqwasUat",
//            "password": "3w9s7R9QrNncBP",
//            "appID": "36464473",
//            "secretKey": "dabe3191feeb4ef9874ae7dd12b451d9"
           "userID": "TheepAPI",
           "password": "Bk224sUkkwTSjm",
           "appID": "37622992",
           "secretKey": "c2YxLCV7EYev328oa4PEbQv6mWEWUmLs"
        ]
        
       let url = NetworkConfigration.pushNotificationUrl + NetworkConfigration.PushNotificationEndPoint.accessToken.rawValue
        AF.request(url, method: .post,parameters: params,encoding:JSONEncoding.prettyPrinted , headers: headers).responseDecodable(of: PushNotificationTokenMoedl.self) { response in
            switch response.result {
            case .success(let value):
                completion(true,value.token)
            case .failure(_):
                completion(false,nil)
            }
        }
    }

    func updatecFcmToken(accessToken:String,fcmToken:String,completion: @escaping (String?) -> Void){
        let headers: HTTPHeaders = [
           "Content-Type": "application/json",
           "Accept": "application/json",
           "Authorization" : "Bearer \(accessToken)"
       ]
        
        let params: [String: Any] = [
            "idno": CachingManager.loginObject()?.iDNo ?? "2329321174",
            "mobileNumber": CachingManager.loginObject()?.mobileNo ?? "012334455633",
            "email": CachingManager.loginObject()?.email ?? "gfds@gdet.com",
            "applicationType": "ios",
            "fcmToken": fcmToken
        ]
        
        let url = NetworkConfigration.pushNotificationUrl + NetworkConfigration.PushNotificationEndPoint.FcmToken.rawValue
         AF.request(url, method: .post,parameters: params,encoding:JSONEncoding.prettyPrinted , headers: headers).responseDecodable(of: FcmResponseMoedl.self) { response in
             switch response.result {
             case .success(let value):
                 completion(value.status)
             case .failure(let err):
                 print(err)
                 completion(nil)
             }
         }
        
    }
    
    func getNotificationHistory(accessToken:String, completion: @escaping (NotificationModel?) -> Void) {
        
        let headers: HTTPHeaders = [
           "Content-Type": "application/json",
           "Accept": "application/json",
           "Authorization" : "Bearer \(accessToken)"
       ]
        
        
        let params: [String: Any] = [
            "idno": CachingManager.loginObject()?.iDNo ?? "2329321174",
            "mobileNumber": CachingManager.loginObject()?.mobileNo ?? "012334455633",
            "email": CachingManager.loginObject()?.email ?? "gfds@gdet.com",
            "applicationType": "ios"
        ]
        
        let url = NetworkConfigration.pushNotificationUrl + NetworkConfigration.PushNotificationEndPoint.notificationHistory.rawValue
        
        AF.request(url, method: .post,parameters: params,encoding:JSONEncoding.prettyPrinted , headers: headers).responseDecodable(of: NotificationModel.self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
    
}


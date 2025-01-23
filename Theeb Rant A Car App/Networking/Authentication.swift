//
//
//

import Foundation
import Alamofire

//class Authentication {
//    static let shared = Authentication()
////    var GUEST = UD.GUEST
//
//    func getAuth() -> String {
////        guard let accessToken =  UD.accessToken  else { return "" }
////        return "Bearer " + accessToken
//        return "Bearer "
////   return "Bearer " + "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvZGV2ZWxvcC5lbmdsZWFzZS5jb21cL2FwaVwvYXV0aFwvbG9naW4iLCJpYXQiOjE2NjE3MTg5MzYsImV4cCI6MTY2MTgwNTMzNiwibmJmIjoxNjYxNzE4OTM2LCJqdGkiOiJNQlFkUmtLWEFTZ1NWY2ZKIiwic3ViIjo0OTAsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.cP-_YCjzjaDo0klg3xwaQmycfVEHh-KnmQgB0jVDKlA"
//    }
//}

struct AccessTokenResponse: Decodable {
    let access_token: String?
    var token_type: String?
    var expires_in: Double?
}


class Authentication: BaseViewModel {
    
    static let shared = Authentication()
    
    private let tokenKey = "token"
    
     var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    func getAuth() -> String {
        guard let token = token else { return "" }
        return "Bearer \(token)"
    }
    
    func saveToken(token: String) {
        self.token = token
    }
    
    func clearToken() {
        self.token = nil
    }
    
    func refreshToken(completion: @escaping (Bool) -> Void) {
        // production
        
        let params: [String: Any] = [
                "username": "TheebApp",
                "password": "L]AKv8Mn8W#-S3y2x8Hy",
                "client_id": "CarProAPI",
                "client_secret": "2D010372-0190-487E-BF44-E5A0F57837B7"
        ]
//        
        // testing
////        
//        let params: [String: Any] = [
//                "username": "TheebUser1",
//                "password": "ZT>Qs#NXbt=9yzVb6A@Z",
//                "client_id": "CarProAPI",
//                "client_secret": "EB074A7D-F6BE-4F55-B8E3-D64CA0F4AD5D"
//        ]
////
//
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]

        
        let url =   self.convertToQueryParamters(params: params, apiURL: NetworkConfigration.EndPoint.accessToken.rawValue)
      //  CustomLoader.customLoaderObj.startAnimating()
        AF.request(NetworkConfigration.urlString + url.absoluteString, method: .post, headers: headers).responseDecodable(of: AccessTokenResponse.self) { [weak self] response in
            switch response.result {
            case .success(let value):
                self?.token = value.access_token
                self?.saveToken(token: self?.token ?? "")
                completion(true)
            case .failure(_):
                completion(false)
            }
        }


    }
}

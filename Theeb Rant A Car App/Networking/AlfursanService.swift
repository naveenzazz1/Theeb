//
//  AfursanService.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 04/04/2024.
//

import Foundation
import Alamofire
import Firebase


actor AlfursanService {
    static let instance = AlfursanService()
    
    func requestAlfursan<T: Decodable>(
            isQueryString: Bool = true,
            method: HTTPMethod,
            url: String,
            headers: [String: String],
            params: Parameters?,
            of type: T.Type
    )  async throws -> T {
            var encoding: ParameterEncoding = JSONEncoding.default
            switch method {
            case .post:
                encoding = isQueryString ? URLEncoding.queryString:JSONEncoding.default
            case .get:
                encoding = URLEncoding.default
            default:
                encoding = JSONEncoding.default
            }

        return try await withCheckedThrowingContinuation { continuation in
                AF.request(
                    url,
                    method: method,
                    parameters: params,
                    encoding: encoding,
                    headers: HTTPHeaders(headers)
                ).responseDecodable(of: type) { response in
                    switch response.result {
                    case let .success(data):
                        continuation.resume(returning: data)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }

    func getAlfursanAccesTokenasync() async -> Result<AuthentcationModel, Error> {
        let AlfursanKey = "alfursan_api_credentials"
        // staging
        
        //        let params: [String: String] = [
        //            "username": "AlfursanUser",
        //            "password": "123456",
        //            "client_id": "Alfursan",
        //            "client_secret": "EB074A7D-F6BE-4F55-B8E3-D64CA0F4AD8D"
        //        ]
        
        // production
        
//                let params: [String: String] = [
//                    "username": "theebfursan",
//                    "password": "28PfM6NkapJiCPwd",
//                    "client_id": "AlfursanAPI",
//                    "client_secret": "93731471-C2B8-4B0E-AFB5-32787086DD62"
//                ]
        
        let remoteConfig = RemoteConfig.remoteConfig()
        guard let params = remoteConfig[AlfursanKey].jsonValue as? [String : AnyObject] else {return .failure(CreditialsErrors.creditialsNotFound)}
        do {
            let url = NetworkConfigration.AlforsanEndPoint.accessToken.rawValue
            let response = try await requestAlfursan(method: .post, url: url , headers: [:], params: params, of: AuthentcationModel.self)
               return .success(response)
           } catch {
               return .failure(error)
           }
    }
    
    func validateMembershipForAlforsan(alforsanId: String, accessToken:String) async -> Result<AlfursanValidation, Error> {
        
        let params: [String: String] = [
            "membershipNo": alforsanId
            ]
        
        let headers: [String: String] = [
           "Content-Type": "application/json",
           "Accept": "application/json",
           "Authorization" : "Bearer \(accessToken)"
       ]
        
        let url = NetworkConfigration.AlforsanEndPoint.validateElforsan.rawValue
        do {
            let response = try await requestAlfursan(method: .get, url: url , headers: headers, params: params, of: AlfursanValidation.self)
            return .success(response)
        }catch {
            return .failure(error)
        }
    }
    
    func convertLoyalityPoint(
            accessToken:String,
            pointsToTransfeer: Int,
            driverCode: String,
            loginUser: String,
            lastName: String?,
            licenseIdNo: String,
            mobileNumber:String,
            passportNumber: String,
            email: String
    ) async -> Result<ConvertLoyalityModel, Error> {
        
        let headers: [String: String] = [
           "Content-Type": "application/json",
           "Accept": "application/json",
           "Authorization" : "Bearer \(accessToken)"
        ]
        
        let body: [String : Any] = [
            "driverCode": driverCode,
            "pointsToRedeem": pointsToTransfeer,
            "loginUser": loginUser,
            "reqFrom": "IOS-APP",
            "lastName": lastName ?? "",
            "licenseIdNo": licenseIdNo,
            "mobileNumber": mobileNumber,
            "passportIdNumber": passportNumber,
            "internetAddress": email
        ]
        let url = NetworkConfigration.AlforsanEndPoint.convertLoyalityPoints.rawValue
        do {
            let response = try await requestAlfursan(isQueryString: false, method: .post, url: url , headers: headers, params: body, of: ConvertLoyalityModel.self)
            return .success(response)
        }catch {
            return .failure(error)
        }
    }
    
    func getElforsanHistory(
        accessToken:String,
        lastName: String?,
        licenseIdNo: String,
        mobileNumber:String,
        passportNumber: String,
        email: String,
        fromDate: String,
        toDate: String
    ) async -> Result<AlfursanHistoryModel, Error> {
        
        let body: [String : Any] = [
            "lastName": lastName ?? "",
            "licenseIdNo": licenseIdNo,
            "mobileNumber": mobileNumber,
            "passportIdNumber": passportNumber,
            "internetAddress": email,
            "fromDate": fromDate,
            "toDate": toDate
        ]
        
        let headers: [String: String] = [
           "Content-Type": "application/json",
           "Accept": "application/json",
           "Authorization" : "Bearer \(accessToken)"
        ]
        
        let url = NetworkConfigration.AlforsanEndPoint.alfoursanHistory.rawValue
        do {
            let response = try await requestAlfursan(isQueryString: false, method: .post, url: url , headers: headers, params: body, of: AlfursanHistoryModel.self)
            return .success(response)
        }catch {
            return .failure(error)
        }

    }
}

enum CreditialsErrors:Error{
    case creditialsNotFound
}

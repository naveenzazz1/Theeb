//
//  NetworkManager.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 24/04/1443 AH.
//

import Foundation
import Alamofire
import XMLMapper
import SystemConfiguration
typealias APISuccess = ((_ response: Any?) -> ())?
typealias APIFailure = ((_ response: Any?, _ error: Error?) -> ())?
typealias APIResponseHeaders = ((_ responseHeaders: [AnyHashable : Any?]?) -> ())?

struct NetworkManager {
    
    let timeoutInSeconds: TimeInterval = 300
    
    static let manager: NetworkManager = {
        return NetworkManager()
    }()
    
    
    
    func urlRequestwithSoapAction(soapAction: String? , url : String? ,xmlString : String? ) -> URLRequest {
       
        let url = URL(string:url ?? "" )
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.addValue(soapAction ?? "" , forHTTPHeaderField: "soapAction")
        xmlRequest.httpBody = xmlString?.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = HTTPMethod.post.rawValue
        xmlRequest.addValue("application/xml", forHTTPHeaderField: "Content-Type")
        xmlRequest.addValue("Theeb CPro", forHTTPHeaderField: "User-Agent")
        
        return xmlRequest
    }
    
    func request(isCustomLoader:Bool = true,soapAction: String? ,xmlString : String?, url: String? , success: APISuccess, failure: APIFailure, responseHeaders: APIResponseHeaders = nil) {
        if isCustomLoader{
   //     CustomLoader.customLoaderObj.startAnimating()
        }
        let xmlRequest =   self.urlRequestwithSoapAction(soapAction: soapAction ?? "", url: url , xmlString: xmlString)
      
        if isConnectedToNetwork() {
            AF.request(xmlRequest).responseData(completionHandler:  { response in
                CustomLoader.customLoaderObj.stopAnimating()
                let responseString: String = String(data: response.data ?? Data() , encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as String? ?? ""
             let finalResponse = responseString.replacingOccurrences(of: "<?xml version=\"1.0\" encoding=\"us-ascii\" ?>", with: "")
                print("wwwww",finalResponse)
                success?(finalResponse)
                failure?(finalResponse,nil)
                
            })
        } else {
            
            CustomLoader.customLoaderObj.stopAnimating()

            CustomAlertController.initialization().showAlertWithOkButton(message: "login_checkConnection".localized) { (index, title) in
                 print(index,title)
            }
        }
    
    }
    
    
    func requestoofers(url: String?, success: APISuccess, failure: APIFailure, responseHeaders: APIResponseHeaders = nil) {
        
        AF.request(url ?? "").validate().responseJSON{ (response) in
         
            switch response.result {
            case .success(let value): success?(value)
            case .failure(let error): failure?(nil, error)
           
            
            }
            
        }
    
    }
    
    
     func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                
                
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    
    func cancelAllRequests() {
        
        let sessionManager = Alamofire.Session.default
        sessionManager.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    
    func requestForCalculateDistance(endPoint: EndPoint, success: APISuccess, failure: APIFailure, responseHeaders: APIResponseHeaders = nil) {
        
        if !(endPoint.configurations?.handleNetworkActivityIndicatorManually ?? false) {
        
        }
        
        AF.request(endPoint.url,
                   method: httpMethod(forEndPoint: endPoint),
                   parameters: endPoint.parameters,
                   encoding: encoding(forEndPoint: endPoint),
                   headers: httpHeaders(forEndPoint: endPoint)){ $0.timeoutInterval = self.timeoutInSeconds }.validate().responseJSON { response in
                    
                    
                    if !(endPoint.configurations?.handleActivityIndicatorManually ?? false) {
                    
                    }
                    
                    responseHeaders?(response.response?.allHeaderFields)
                    
                    if !(endPoint.configurations?.handleNetworkActivityIndicatorManually ?? false) {
                    
                    }
                    
                    if endPoint.configurations?.handleResponseModelManually ?? false {
                        
                        switch response.result {
                        case .success(let value): success?(value)
                        case .failure(let error): failure?(nil, error)
                        }
                        return
                    }
                    
                  
        }
    }
    
    func requestForJson(endPoint: EndPoint, success: APISuccess, failure: APIFailure, responseHeaders: APIResponseHeaders = nil) {
        
        if !(endPoint.configurations?.handleNetworkActivityIndicatorManually ?? false) {
        
        }
        
        AF.request(endPoint.url,
                   method: httpMethod(forEndPoint: endPoint),
                   parameters: endPoint.parameters,
                   encoding: encoding(forEndPoint: endPoint),
                   headers: httpHeaders(forEndPoint: endPoint)).responseJSON { response in
                    
                    
                    if !(endPoint.configurations?.handleActivityIndicatorManually ?? false) {
                    
                    }
                    
                    responseHeaders?(response.response?.allHeaderFields)
                    
                    if !(endPoint.configurations?.handleNetworkActivityIndicatorManually ?? false) {
                    
                    }
                    
                    if endPoint.configurations?.handleResponseModelManually ?? false {
                        
                        switch response.result {
                        case .success(let value): success?(value)
                        case .failure(let error): failure?(nil, error)
                        }
                        return
                    }
                    
                  
        }
    }
    
    
    
    
    func cancelRequestWithURL(url: String) {
        
        let sessionManager = Alamofire.Session.default
        sessionManager.session.getAllTasks { tasks in
            
            tasks.forEach {
                if ($0.originalRequest?.url?.absoluteString.contains(url) ?? false) {
                    $0.cancel()
                }
            }
        }
    }
}


extension NetworkManager {
    
    func httpMethod(forEndPoint endPoint: EndPoint) -> HTTPMethod {
        
        switch endPoint.method {
            
        case .get:
            return HTTPMethod.get
            
        case .post:
            return HTTPMethod.post
            
        case .put:
            return HTTPMethod.put
            
        case .delete:
            return HTTPMethod.delete
        }
    }
    
    func encoding(forEndPoint endPoint: EndPoint) -> ParameterEncoding {
        
        if let encoding = endPoint.encoding {
            
            return parameterEncoding(forAPIEncoding: encoding)
        }
        
        switch endPoint.method {
            
        case .get:
            return URLEncoding.default
            
        case .post:
            return JSONEncoding.default
            
        default:
            return JSONEncoding.default
        }
    }
    
    func parameterEncoding(forAPIEncoding apiEncoding: APIEncoding) -> ParameterEncoding {
        
        switch apiEncoding {
            
        case .url:
            return URLEncoding.default
            
        case .json:
            return JSONEncoding.default
            
        case .query:
            return URLEncoding.queryString
            
        case .noBrackets:
            return CustomGetEncodingWithoutBrackets()
            
        }
    }
    
    func httpHeaders(forEndPoint endPoint: EndPoint) -> HTTPHeaders? {
        
        var headers: HTTPHeaders = [:]
        
        headers = defaultHTTPHeaders()
        
        guard let endPointHeaders = endPoint.headers else {
            
            return headers
        }
        
        for header in endPointHeaders {
            headers.add(name: header.key, value: header.value)
        }
        
        return headers
    }

    func defaultHTTPHeaders() -> HTTPHeaders {
        
        var headers: HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        if let userToken = CachingManager.ehsanToken() {
            headers["Authorization"] = "Bearer\(userToken)"
        }
        
   
        return headers
    }
}


extension NetworkManager {
    
    struct CustomGetEncodingWithoutBrackets: ParameterEncoding {
        
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var request = try! URLEncoding().encode(urlRequest, with: parameters)
            let urlString = request.url?.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "=")
            request.url = URL(string: urlString!)
            return request
        }
    }
}

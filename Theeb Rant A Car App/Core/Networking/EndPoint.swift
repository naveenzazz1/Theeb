//
//  EndPoint.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 24/04/1443 AH.
//


import UIKit

enum APIMethod {
    
    case get
    case post
    case put
    case delete
}

enum APIEncoding {
    
    case url
    case json
    case query
    case noBrackets
}

struct EndPoint {
    
    // MARK: - Variables
    
    var path: String
    var method: APIMethod
    var parameters: [String : Any]?
    var encoding: APIEncoding?
    var headers: [String : String]?
    var configurations: APIConfiguration?
    var fullURL: String?
    
    var url: String {
        
        return fullURL ?? "\(environment.baseURL)"
    }
    
    
    // MARK: - Initialization

    init() {
        
        self.path = ""
        self.method = .get
        self.parameters = nil
        self.encoding = nil
        self.headers = nil
        self.configurations = nil
        self.fullURL = nil
    }
    

    init(path: String, method: APIMethod,
         parameters: [String : Any]?,
         encoding: APIEncoding? = nil,
         headers: [String : String]? = nil,
         configurations: APIConfiguration? = nil,
         fullURL: String? = nil) {
        

        self.path = path
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        self.configurations = configurations
        self.fullURL = fullURL
    }
}


struct APIConfiguration {
    
    var hideRetryRequestView: Bool = false
    var handleErrorsManually: Bool = false
    var handleNetworkErrorsManually: Bool = false
    var handleNetworkActivityIndicatorManually: Bool = false
    var handleResponseModelManually: Bool = false
    var handleActivityIndicatorManually: Bool = false
}

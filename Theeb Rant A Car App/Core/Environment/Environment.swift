//
//  Environment.swift
//  Theeb Rant A Car App
//
//  Created by Moustafa Gadallah on 24/04/1443 AH.
//

import Foundation
import UIKit
import XMLMapper




#if TEST
let environment: Environment = Environment.test
#elseif STAGING
let environment: Environment = Environment.staging
#elseif PRODUCTION
let environment: Environment = Environment.production
#else
let environment: Environment = Environment.test
#endif


#if TEST || STAGING
let debug: Bool = true
#elseif PRODUCTION
let debug: Bool = false
#else
let debug: Bool = true
#endif



enum Environment {
    
    case test
    case staging
    case production
    
    
    var baseURL: String {
        
        switch self {
            
        case .test: return BaseURL.test
        case .staging: return BaseURL.staging
        case .production: return BaseURL.production
        }
    }
    
    var payfortEnvironment: KPayFortEnviroment {
        
        switch self {
            
        case .test: return KPayFortEnviromentSandBox
        case .staging: return KPayFortEnviromentSandBox
        case .production: return KPayFortEnviromentProduction
        }
    }
}

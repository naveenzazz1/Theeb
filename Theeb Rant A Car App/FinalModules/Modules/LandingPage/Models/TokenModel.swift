//
//  TokenModel.swift
//  Theeb Rent A Car App
//
//  Created by ahmed elshobary on 24/07/2023.
//

import Foundation

struct TokenModel: Codable {
    
    var access_token: String?
    var token_type: String?
    var expires_in: Double?
    
}

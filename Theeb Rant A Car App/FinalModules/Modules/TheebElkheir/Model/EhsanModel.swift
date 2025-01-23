//
//  EhsanModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 28/12/1443 AH.
//

import Foundation



struct AuthentcationModel: Codable {
    let accessToken, tokenType: String?
    let expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
        tokenType = try values.decodeIfPresent(String.self, forKey: .tokenType)
        expiresIn = try values.decodeIfPresent(Int.self, forKey: .expiresIn)
    }
    
}



class IntiativeTypesModel {
    
    
}


class DonateModel {
    
    
}

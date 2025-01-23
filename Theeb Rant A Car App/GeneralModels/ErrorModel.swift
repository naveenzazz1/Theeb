//
//  ErrorModel.swift
//  Theeb Rent A Car App
//
//  Created by ahmed elshobary on 17/07/2023.
//

import Foundation

// MARK: - ...  Erros model

class Errors: Codable {
    var detail: String?
    var status : Int?
    var title : String?
}

class ErrorModel: Codable {
    var message: String?
}

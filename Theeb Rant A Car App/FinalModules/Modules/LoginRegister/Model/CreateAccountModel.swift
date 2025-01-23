//
//  CreateAccountModel.swift
//  Theeb Rent A Car App
//
//  Created by ahmed elshobary on 09/08/2023.
//

import Foundation

struct CreateAccountResponseModel: Codable {
    var DriverImportRS: DriverImportRS?
}
class DriverImportRS: Codable {
    var Success: String?
    var VarianceReason: String?
    var DriverCode: String?
}

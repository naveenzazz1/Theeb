//
//  PrettyPrint.swift
//

import Foundation

struct PrettyPrint {
    
    static func prettyPrintJson(data: NSDictionary) -> String {
        let dataData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        return String(data: dataData, encoding: .utf8)!
    }
    
    static func prettyPrintJson(data: Data) -> String {
        return String(data: data, encoding: .utf8)!
    }
}

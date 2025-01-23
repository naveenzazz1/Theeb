//
//  Double+Extentions.swift
//  Theeb Rent A Car App
//
//  Created by ahmed elshobary on 11/06/2024.
//

import Foundation
extension Double {
    /// Rounds the double to two decimal places.
    func roundedToTwoDecimalPlaces() -> Double {
        let divisor = pow(10.0, 2.0)
        return (self * divisor).rounded() / divisor
    }
}

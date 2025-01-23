//
//  CeullarNetwork.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 30/05/1443 AH.
//

import Foundation
import CoreTelephony

class CellularNetworkUtils : NSObject {
    
    class func isoCode() -> String? {
        
        let networkInfo = CTTelephonyNetworkInfo()
        
        if let carrier = networkInfo.subscriberCellularProvider,
           let isoCode = carrier.isoCountryCode {
            return isoCode.uppercased()
        }
        
        return nil
    }
}

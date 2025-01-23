//
//  GoogleMapsManager.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 19/06/1443 AH.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GoogleMapsManager: NSObject {
    
    static let APIKey = "AIzaSyCOwoQFlFJs4bjkf__wy_rPVZfMbg1tPaE"
    

    class func initializeSDK() {
        
        GMSServices.provideAPIKey(APIKey)
        GMSPlacesClient.provideAPIKey(APIKey)
    }
}

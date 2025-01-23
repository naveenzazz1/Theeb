//
//  AppsFlyerManager.swift
//  Theeb Rent A Car App
//
//  Created by ahmed elshobary on 19/09/2023.
//

import Foundation
import AppsFlyerLib

class AppsFlyerManager {
    
    
    class func logAPI(apiName: String? , response: String?, request: String?) {
        
        
        AppsFlyerLib.shared().logEvent("TheebAPI", withValues: [
            "name": (apiName ?? "") as String,
            "response": (response ?? "") as String,
            "request" : (request ?? "") as String
        ])
        
        
    }
    
    class func logScreenView(screenName: String? , screenClass: String?) {
        
        AppsFlyerLib.shared().logEvent(screenClass ?? "", withValues: [:])
        
        
    }
    
    
    class func logPrimaryEvent(eventName: String) {
        
        let params: [String: Any] = [
            "UserId": CachingManager.loginObject()?.iDNo ?? "",
            "FullName": ((CachingManager.loginObject()?.firstName ?? "") + (CachingManager.loginObject()?.lastName ?? "")),
            "PhoneNumber": CachingManager.loginObject()?.mobileNo ?? "",
            "Email": CachingManager.loginObject()?.email ?? CachingManager.email(),
        ]
        
        
        AppsFlyerLib.shared().logEvent(eventName, withValues: params)
        
        
    }
    
    class func logPrimaryEventBooking(eventName: String, amount: Double) {
        
        let params: [String: Any] = [
            "booking_amount": amount,
            "UserId": CachingManager.loginObject()?.iDNo ?? "",
            "FullName": ((CachingManager.loginObject()?.firstName ?? "") + (CachingManager.loginObject()?.lastName ?? "")),
            "PhoneNumber": CachingManager.loginObject()?.mobileNo ?? "",
            "Email": CachingManager.loginObject()?.email ?? CachingManager.email(),
        ]
        
        
        AppsFlyerLib.shared().logEvent(eventName, withValues: params)
        
        
    }
    
    class func logPayment(payment: Double) {
        
        AppsFlyerLib.shared().logEvent(AFEventPurchase,
                                       withValues: [
                                        AFEventParamRevenue: payment,
                                        AFEventParamCurrency: "SAR",
                                        "UserId": CachingManager.loginObject()?.iDNo ?? "",
                                        "FullName": ((CachingManager.loginObject()?.firstName ?? "") + (CachingManager.loginObject()?.lastName ?? "")),
                                        "PhoneNumber": CachingManager.loginObject()?.mobileNo ?? "",
                                        "Email": CachingManager.loginObject()?.email ?? CachingManager.email() ?? ""
                                       ]);
        
    }
}
